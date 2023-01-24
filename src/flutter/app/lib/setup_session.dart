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

//index variable
int index = 0;
//variable for the fake data timer
Timer? fakeDataTimer;
List<int> subscriptions = [];
List dbSubscriptions = [];
IO.Socket? socket;

//function to initialize the output values
List<OutputValue> initOutputValues(jsonValues) {
  //list to store the output values
  List<OutputValue> outputValues = [];
  //iterate through the jsonValues
  jsonValues.forEach((item) =>
      //add the output value to the outputValues list
      outputValues.add(OutputValue(item['value'], item['timestamp'])));

  //return the outputValues list
  return outputValues;
}

// function to start sending fake data
// only if enabled in DebugConfig
Timer? startSendingFakeData(int sessionId, List<int> memberIds) {
  if (!DebugConfig.sendFakeData) return null;

  print('starting fake data for session session: ${sessionId}');
  //create a new random object
  Random random = new Random();

  // generate random acceleration value
  double randAccValue() {
    double value = (random.nextInt(4000) - 2000) / 100; // -10 >= value > 10
    return value;
  }

  String getData() {
    return jsonEncode({
      'Timestamp': DateTime.now().millisecondsSinceEpoch,
      'ArrayAcc': [
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()},
        {'x': randAccValue(), 'y': randAccValue(), 'z': randAccValue()}
      ]
    });
  }

  //return a timer that runs periodically
  return Timer.periodic(Duration(milliseconds: 100), (Timer t) {
    //emit the data-point event with the heart rate and current timestamp
    memberIds.forEach((id) => socket?.emit(
        'data-point',
        jsonEncode({
          'member': id,
          'data': getData(),
        })));
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
    scriptOutputs
        .add(ScriptOutput.fromMap(record, Script.fromMap(record['scripts'])));
  });

  return scriptOutputs;
}

// start session by opening a websocket
Future<void> createSession(
  String? name,
  List<int> scriptIds,
  List<int> memberIds,
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
      'members': memberIds,
    });

    // session started, start retrieving outputs
    _socket.on('sessionId', (sessionId) async {
      print('started session: ${sessionId}');
      callback(await getOutputs(sessionId));
      fakeDataTimer = startSendingFakeData(sessionId, memberIds);
    });
  });
  _socket.onDisconnect((_) => print('Connection Disconnection'));
  _socket.onConnectError((err) => print('onConnectError: ${err}'));
  _socket.onError((err) => print('onError: ${err}'));
}

class LiveSession extends StatefulWidget {
  final String? name;
  final List<int> scriptIds;
  final List<int> memberIds;
  final Function stopSession;
  const LiveSession({
    super.key,
    this.name,
    required this.scriptIds,
    required this.memberIds,
    required this.stopSession,
  });

  @override
  State<LiveSession> createState() => _LiveSessionState();
}

class _LiveSessionState extends State<LiveSession> {
  List<ScriptOutput> outputs = [];

  @override
  void initState() {
    // reset variables
    index = 0;
    fakeDataTimer = null;
    subscriptions = [];
    dbSubscriptions = [];
    socket = null;

    super.initState();
    createSession(
      widget.name,
      widget.scriptIds,
      widget.memberIds,
      onSessionStart,
    );
  }

  @override
  void dispose() {
    // stop sending fake data before diposing of page
    fakeDataTimer?.cancel();

    subscriptions.forEach((subscribtion) {
      Mds.unsubscribe(subscribtion);
    });

    // cancel all database subscriptions
    dbSubscriptions.forEach((subscribtion) {
      subscribtion.cancel();
    });

    // send signal to stop session
    socket?.emit('stop-session');
    socket?.disconnect();

    super.dispose();
  }

  void onSessionStart(List<ScriptOutput> sessionOutputs) {
    setState(() => outputs = sessionOutputs);
  }

  // stop the current session,
  // navigates back to start session page
  void stopSession() {
    widget.stopSession();
    subscriptions.forEach((element) {
      print(element);
      print("TEST");
      Mds.unsubscribe(element);
    });
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
              memberIds: widget.memberIds,
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
    required this.memberIds,
  });

  //scannerState variable
  final BleScannerState scannerState;
  //list of member ids
  final List<int> memberIds;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  //controller for the uuid text field
  late TextEditingController _uuidController;
  //variable for the device model
  late DeviceModel deviceModel;

  List<int> subscriptions = [];

  @override
  void initState() {
    super.initState();
    //initializing the controller
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));

    //iterating through the connected devices
    widget.scannerState.connectedDevices.forEach((element) {
      //creating a device model
      deviceModel =
          DeviceModel(element.name, Device(element.name, element.id).serial);

      subscriptions.add(Mds.subscribe(
          Mds.createSubscriptionUri(
              Device(element.name, element.id).serial.toString(),
              "/Meas/Acc/104"),
          "{}",
          //callbacks for success, error and data
          (d, c) => {},
          (e, c) => {},
          (data) => sendData(data),
          (e, c) => {}));

      subscriptions.add(Mds.subscribe(
          Mds.createSubscriptionUri(
              Device(element.name, element.id).serial.toString(), "/Meas/HR"),
          "{}",
          //callbacks for success, error and data
          (d, c) => {},
          (e, c) => {},
          (data) => sendData(data),
          (e, c) => {}));
    });
  }

  void sendData(String data) {
    widget.memberIds.forEach((id) => socket?.emit(
        'data-point',
        jsonEncode({
          'member': id,
          'data': jsonEncode(jsonDecode(data)['Body']),
        })));
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
                            children: [],
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
  //list to store the output values
  List<OutputValue> values = [];

  void subscribeToData() async {
    //get the supabase instance
    final supabase = Supabase.instance.client;
    //subscribe to the script_outputs table for the output with the given id
    final subscription = await supabase
        .from('script_outputs')
        .stream(primaryKey: ['id'])
        .eq('id', widget.output.id)
        //when data is received, update the state
        .listen((List<Map<String, dynamic>> data) {
          if (!data.isEmpty) {
            setState(() {
              //get the last MAX_GRAPH_VALUES values
              final int start = data[0]['values'].length - MAX_GRAPH_VALUES;
              final range = data[0]['values']
                  .getRange(start >= 0 ? start : 0, data[0]['values'].length);
              //initialize the output values
              values = initOutputValues(range);
            });
          }
        });
    // add to subscritions so that subscription can be cancled on page dispose
    dbSubscriptions.add(subscription);
  }

  @override
  void initState() {
    super.initState();
    subscribeToData();
  }

  @override
  Widget build(BuildContext context) {
    //builds the DropDownBar with the given title and dataWidget
    return DropDownBar(
        widget.output.script.name,
        HeartBeatData(
            //outputName of the script
            outputName: widget.output.script.outputName,
            //values of the script
            values: values,
            //outputType of the script
            outputType: widget.output.script.outputType));
  }
}

class DropDownBar extends StatefulWidget {
  //title of the dropdown bar
  final String title;
  //widget to be shown when the bar is pressed
  final Widget dataWidget;
  //constructor
  const DropDownBar(this.title, this.dataWidget);
  //create the state
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
