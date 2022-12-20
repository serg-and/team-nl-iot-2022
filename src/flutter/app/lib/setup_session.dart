import 'dart:convert';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import 'models.dart';
import 'graph_builder.dart';

const String SERVER = 'https://team-nl-iot-2022.onrender.com/';
const int MAX_GRAPH_VALUES = 30;

int index = 0;
Timer? fakeDataTimer;
List<dynamic> subscriptions = [];

List<OutputValue> initOutputValues(jsonValues) {
  List<OutputValue> outputValues = [];
  jsonValues.forEach((item) =>
      outputValues.add(OutputValue(item['value'], item['timestamp'])));

  return outputValues;
}

Timer startSendingFakeData(IO.Socket socket, int sessionId) {
  print('starting fake data for session session: ${sessionId}');
  Random random = new Random();

  return Timer.periodic(Duration(milliseconds: 100), (Timer t) {
    int heartBeat = 40 + random.nextInt(150 - 40);
    socket.emit(
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
Future<void> createSession(Function callback) async {
  IO.Socket socket = IO.io(SERVER, <String, dynamic>{
    'path': '/socket.io',
    'autoConnect': false,
    'transports': ['websocket'],
  });
  socket.connect();
  socket.onConnect((_) {
    print('Connection established');
  });
  socket.onDisconnect((_) => print('Connection Disconnection'));
  socket.onConnectError((err) => print('onConnectError: ${err}'));
  socket.onError((err) => print('onError: ${err}'));

  // session started, start retrieving outputs
  socket.on(
      'sessionId',
          (sessionId) async => {
        print('started session: ${sessionId}'),
        callback(await getOutputs(sessionId)),
        fakeDataTimer = startSendingFakeData(socket, sessionId),
      });
}

class HeartBeatPage extends StatefulWidget {
  const HeartBeatPage({super.key});

  @override
  State<HeartBeatPage> createState() => _HeartBeatPageState();
}

class _HeartBeatPageState extends State<HeartBeatPage> {
  List<ScriptOutput> outputs = [];

  @override
  void initState() {
    super.initState();
    createSession((List<ScriptOutput> sessionOutputs) => setState(() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Stack(
        children: [
          ListView(
            children: outputs.map((output) => Output(output: output)).toList(),

            //Add extra data widget here with a button title
            // children: [
            //   DropDownBar("HeartBeat", HeartBeatData()),
            //   DropDownBar('HeartBeat2', HeartBeatData()),
            //   RetrievedDataSection()
            // ],
          ),
          Positioned(
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: ElevatedButton(
                  onPressed: () {
                    //navigate to the current page
                    Navigator.pop(context);
                  },
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text('Stop session')),
            ),
          )
        ],
      ),
    );
  }
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
            outputName: widget.output.script.outputName, values: values, outputType: widget.output.script.outputType));
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
  const HeartBeatData({required this.outputName, required this.values, required this.outputType});

  Widget build(BuildContext context) {
    return Center(
      child: Column(

        children: [
          DataText(
            name: outputName,
            lastValue: values.isEmpty ? null : values.last,
          ),
          if(outputType == 'bar_chart')...[
            BarChartBuilder(values: values)
          ]
          else...
          [
            DataLineGraph(values: values)
          ]
        ],
      ),
    );
  }
}

