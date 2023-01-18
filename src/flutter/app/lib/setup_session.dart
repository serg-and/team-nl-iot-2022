import 'dart:convert';
import 'package:app/bluetooth/bluetooth_screen.dart';
import 'package:app/bluetooth/models/device.dart';
import 'package:app/bluetooth/models/device_model.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:mdsflutter/Mds.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:app/constants.dart';
import 'bluetooth/ble/ble_logger.dart';
import 'bluetooth/ble/ble_scanner.dart';
import 'bluetooth/ui/device_detail/device_detail_screen.dart';
import 'bluetooth/ui/device_list.dart';
import 'models.dart';
import 'graph_builder.dart';
import 'package:http/http.dart' as http;

const int MAX_GRAPH_VALUES = 30;

int index = 0;
Timer? fakeDataTimer;
List<dynamic> subscriptions = [];
IO.Socket? socket;

List<OutputValue> initOutputValues(jsonValues) {
  List<OutputValue> outputValues = [];
  jsonValues.forEach((item) =>
      outputValues.add(OutputValue(item['value'], item['timestamp'])));

  return outputValues;
}

Timer startSendingFakeData(int sessionId) {
  print('starting fake data for session session: ${sessionId}');
  Random random = new Random();

  return Timer.periodic(Duration(milliseconds: 1), (Timer t) {
    int heartBeat = 40 + random.nextInt(150 - 40);
    socket?.emit(
        'data-point',
        jsonEncode({
          'value': heartBeat,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        }));
  });
}

// retrieve all script_outputs of given session
// and initialise values
Future<List<ScriptOutput>> getOutputs(int sessionId) async {
  final supabase = Supabase.instance.client;
  final sessionOutputs = await supabase
      .from('sessions')
      .select(
          'script_outputs( id, scripts( id, name, description, output_type, output_name ) )')
      .eq('id', sessionId)
      .single();

  List<ScriptOutput> scriptOutputs = [];

  sessionOutputs['script_outputs'].forEach((record) {
    scriptOutputs.add(ScriptOutput(
        record['id'],
        Script(
            record['scripts']['id'],
            record['scripts']['name'],
            record['scripts']['description'],
            record['scripts']['output_type'],
            record['scripts']['output_name']),
        []));
  });

  return scriptOutputs;
}

// start session by opening a websocket
Future<void> createSession(
  String? name,
  List<int> scriptIds,
  Function callback,
) async {
  // initialize the Socket.io server
  await http.get(Uri.parse('${Secrets.server}/api/socket'));

  IO.Socket _socket = IO.io(Secrets.server, <String, dynamic>{
    'path': '/socket.io',
    'autoConnect': false,
    'transports': ['websocket'],
  });
  socket = _socket;
  _socket.connect();
  _socket.onConnect((_) {
    print('Connection established');

    print('start-session with scripts: ${scriptIds}');

    // send message to start session with the given options
    _socket.emit('start-session', {
      'name': name,
      'scripts': scriptIds,
    });

    // session started, start retrieving outputs
    _socket.on(
        'sessionId',
        (sessionId) async => {
              print('started session: ${sessionId}'),
              callback(await getOutputs(sessionId)),
              fakeDataTimer = startSendingFakeData(sessionId),
            });
  });
  _socket.onDisconnect((_) => print('Connection Disconnection'));
  _socket.onConnectError((err) => print('onConnectError: ${err}'));
  _socket.onError((err) => print('onError: ${err}'));
}

class HeartBeatPage extends StatefulWidget {
  final String? name;
  final List<int> scriptIds;
  final Function stopSession;
  const HeartBeatPage({
    super.key,
    this.name,
    required this.scriptIds,
    required this.stopSession,
  });

  @override
  State<HeartBeatPage> createState() => _HeartBeatPageState();
}

class _HeartBeatPageState extends State<HeartBeatPage> {
  List<ScriptOutput> outputs = [];

  @override
  void initState() {
    // reset variables
    index = 0;
    fakeDataTimer = null;
    subscriptions = [];
    socket = null;

    super.initState();
    createSession(
        widget.name,
        widget.scriptIds,
        (List<ScriptOutput> sessionOutputs) => setState(() {
              outputs = sessionOutputs;
            }));
  }

  @override
  void dispose() {
    // stop sending fake data before diposing of page
    fakeDataTimer?.cancel();
    // cancel all database subscriptions
    subscriptions.forEach((subscribtion) {
      subscribtion.cancel();
    });

    // send signal to stop session
    socket?.emit('stop-session');
    socket?.disconnect();

    super.dispose();
  }

  // stop the current session,
  // navigates back to start session page
  void stopSession() {
    widget.stopSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Stack(
        children: [
          ListView(
            children: outputs.map((output) => Output(output: output)).toList(),
          ),
          Consumer3<BleScanner, BleScannerState?, BleLogger>(
            builder: (_, bleScanner, bleScannerState, bleLogger, __) =>
                _DeviceList(
              scannerState: bleScannerState ??
                  const BleScannerState(
                    connectedDevices: [],
                    discoveredDevices: [],
                    scanIsInProgress: false,
                  ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 80),
                child: ElevatedButton(
                  onPressed: stopSession,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text('Stop session'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({
    required this.scannerState,
  });

  final BleScannerState scannerState;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late TextEditingController _uuidController;
  late DeviceModel deviceModel;

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));

    widget.scannerState.connectedDevices.forEach((element) {
      deviceModel =
          DeviceModel(element.name, Device(element.name, element.id).serial);
      Mds.subscribe(
          Mds.createSubscriptionUri(
              Device(element.name, element.id).serial.toString(),
              "/Meas/Acc/104"),
          "{}",
          (d, c) => {},
          (e, c) => {},
          (data) => sendData(data),
          (e, c) => {});

      Mds.subscribe(
          Mds.createSubscriptionUri(
              Device(element.name, element.id).serial.toString(), "/Meas/HR"),
          "{}",
          (d, c) => {},
          (e, c) => {},
          (data) => sendData(data),
          (e, c) => {});
    });
  }

  void sendData(String data) {
    print("Data sent");
    print(data);
    socket?.emit(
        'data-point',
        jsonEncode({
          'value': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        }));
  }

  Widget _accelerometerItem(DeviceModel deviceModel) {
    return Card(
      child: ListTile(
        title: Text("Accelerometer"),
        subtitle: Text(deviceModel.accelerometerData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: [
                  ...widget.scannerState.connectedDevices.map(
                    (device) => ChangeNotifierProvider(
                      create: (context) => deviceModel,
                      child: Consumer<DeviceModel>(
                        builder: (context, model, child) {
                          return Container(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[_accelerometerItem(model)],
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class Output extends StatefulWidget {
  const Output({Key? key, required this.output}) : super(key: key);
  final ScriptOutput output;

  @override
  State<Output> createState() => _Output();
}

class _Output extends State<Output> {
  List<OutputValue> values = [];

  void subscribeToData() async {
    final supabase = Supabase.instance.client;
    final subscription = await supabase
        .from('script_outputs')
        .stream(primaryKey: ['id'])
        .eq('id', widget.output.id)
        .listen((List<Map<String, dynamic>> data) {
          if (!data.isEmpty) {
            setState(() {
              final int start = data[0]['values'].length - MAX_GRAPH_VALUES;
              final range = data[0]['values']
                  .getRange(start >= 0 ? start : 0, data[0]['values'].length);
              values = initOutputValues(range);
            });
          }
        });
    // add to subscritions so that subscription can be cancled on page dispaose
    subscriptions.add(subscription);
  }

  @override
  void initState() {
    super.initState();
    subscribeToData();
  }

  @override
  Widget build(BuildContext context) {
    return DropDownBar(
        widget.output.script.name,
        HeartBeatData(
            outputName: widget.output.script.outputName,
            values: values,
            outputType: widget.output.script.outputType));
  }
}

class DropDownBar extends StatefulWidget {
  final String title;
  final Widget dataWidget;
  const DropDownBar(this.title, this.dataWidget);
  _DropDownBarState createState() => _DropDownBarState();
}

class _DropDownBarState extends State<DropDownBar> {
  bool showData = true;
  Widget build(BuildContext context) {
    Widget showWidget = widget.dataWidget;
    showWidget = showData ? widget.dataWidget : Container();
    return Center(
      child: Column(children: <Widget>[Bar(context), showWidget]),
    );
  }

  Widget Bar(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      fixedSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width * 0.1),
      backgroundColor: Colors.grey,
    );
    return Center(
      child: ElevatedButton(
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 20.0),
        ),
        style: style,
        onPressed: () {
          setState(() {
            showData = showData ? false : true;
          });
        },
      ),
    );
  }
}

class HeartBeatData extends StatelessWidget {
  final String outputName;
  final List<OutputValue> values;
  final String outputType;
  const HeartBeatData(
      {required this.outputName,
      required this.values,
      required this.outputType});

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          DataText(
            name: outputName,
            lastValue: values.isEmpty ? null : values.last,
          ),
          if (outputType == 'bar_chart') ...[
            BarChartBuilder(values: values)
          ] else ...[
            DataLineGraph(values: values)
          ]
        ],
      ),
    );
  }
}
