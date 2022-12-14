import 'dart:convert';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import 'models.dart';

const String SERVER = 'https://team-nl-iot-2022.onrender.com/';
const int MAX_GRAPH_VALUES = 30;

List<FlSpot> heartBeatList = [];
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
            outputName: widget.output.script.outputName, values: values));
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
  const HeartBeatData({required this.outputName, required this.values});

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          HeartBeatDataText(
            name: outputName,
            lastValue: values.isEmpty ? null : values.last,
          ),
          HeartBeatDataGraph(values: values)
        ],
      ),
    );
  }
}

class HeartBeatDataText extends StatelessWidget {
  final String name;
  final OutputValue? lastValue;
  const HeartBeatDataText({required this.name, required this.lastValue});

  // _HeartBeatState createState() => _HeartBeatState();

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: new Text('Last ${name} = ${lastValue?.value}'),
      ),
    );
  }
}

// class _HeartBeatState extends State<HeartBeatDataText> {
//   int heartBeat = 0;
//   late Timer update;
//   Random random = new Random();

//   @override
//   void initState() {
//     super.initState();
//     update = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
//       setState(() {
//         heartBeat = 40 + random.nextInt(150 - 40);
//         heartBeatList.add(FlSpot(index.toDouble(), heartBeat.toDouble()));
//         if (heartBeatList.length > 30) heartBeatList.removeAt(0);
//         index++;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: new Text('HeartBeat = ' + heartBeat.toString()),
//       ),
//     );
//   }
// }

// class HeartBeatDataGraph extends StatefulWidget {
class HeartBeatDataGraph extends StatelessWidget {
  final List<OutputValue> values;
  const HeartBeatDataGraph({super.key, required this.values});

//   @override
//   State<HeartBeatDataGraph> createState() => _HeartBeatDataGraphState();
// }

// class _HeartBeatDataGraphState extends State<HeartBeatDataGraph> {
  static List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  static bool showAvg = false;
//   late Timer update;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     update = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
//       setState(() {});
//     });
//   }

  List<FlSpot> getSpots() => values
      .map(
          (value) => FlSpot(value.timestamp.toDouble(), value.value.toDouble()))
      .toList();

  @override
  Widget build(BuildContext context) {
    // List<FlSpot> spots = this.values.map((value) => FlSpot(value.timestamp.toDouble(), value.value)).toList();

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              color: Color(0xff232d37),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 0,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\ ${value}',
        style: style,
      ),
      space: 8.0,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\ ${value}', style: style),
    );
  }

  LineChartData mainData() {
    final spots = getSpots();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 10,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 100,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
