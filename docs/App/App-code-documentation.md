# Code Documentation
This page contains the code for the app. In the code of the TeamNL MoveSens app, comments have been added so that the reader can understand what the functionalities do that have been used in the app. These comments are represented with a //. 

## Main 
In the main, the database is set up. In the main, the text TeamNL is also displayed in the appbar. The settings button is also placed in the main. Because the appbar and settings button are placed in the main, these options are displayed on every page. 

```
// Import the pages
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/configure_supabase.dart';
import 'package:app/onboarding_page.dart';
import 'package:app/routing.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await configureApp(); // Awaiting the configuration of the app

  final prefs = await SharedPreferences.getInstance();// Getting the shared preferences instance
  final showHome = prefs.getBool('showHome') ?? false;// Getting the value for 'showHome' from the shared preferences, or false if it does not exist

  runApp(MyApp(showHome: showHome));// Running the MyApp widget
}

class MyApp extends StatelessWidget {
  final bool showHome; // Declaring a boolean variable 'showHome'

  const MyApp({
    Key? key,
    required this.showHome, // The 'showHome' variable is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showHome ? Routing() : OnBoardingPage(),// If showHome is true, display the Routing widget, otherwise display the OnBoardingPage
      debugShowCheckedModeBanner: false, // Don't show the debug banner
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize; // The preferred size of the app bar
  final navigatorKey = GlobalKey<NavigatorState>(); // A key to access the app's navigator
  final String title; // The title to display in the app bar

  CustomAppBar(this.title, {Key? key})
      : preferredSize = Size.fromHeight(50.0), // Set the app bar's preferred height to 50.0
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('TeamNL'), // Set the app bar's title to 'TeamNL'
      centerTitle: true,
      backgroundColor: Color(0xFFF59509), // Set the background color to a hex color code
      actions: [
        PopupMenuButton(
            itemBuilder: (ctx) => [
                  const PopupMenuItem(
                      value: "Settings", child: Text("Settings"))
                ],// Set the items in the popup menu to a single 'Settings' option
            onSelected: (result) {
              if (title != "Settings") { // If the selected item is not 'Settings'
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              }
            })
      ],
    );
  }
}

```

### Routing
This Dart code is a simple routing class that manages the navigation between different pages in an app. The code imports several classes from other files, including Home, Bluetooth, Current, and History, which are the different pages that the user can navigate to.

```
// Import the other pages
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/current_session.dart';
import 'package:app/sessions.history.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'home_page.dart';


class Routing extends StatefulWidget {
  const Routing({Key? key}) : super(key: key);

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {

  var currentIndex = 0;

  List routing = [
    Home(),
    const Bluetooth(),
    const Current(),
    const History()
  ];
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [ // This is the widget that will be displayed at the current index
            routing.elementAt(currentIndex),
            Container(
              margin: EdgeInsets.all(displayWidth * .05),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFFF59509),
                  borderRadius: BorderRadius.all(Radius.circular(displayWidth))),
              child: currentIndex == 4
                  ? GestureDetector( // This is the "Book Now" button that will be displayed on the last screen
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Book Now ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.home,
                      color: Colors.white,
                    )
                  ],
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(bottomBar.length, (i) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        currentIndex = i;
                      }),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bottomBar[i],
                          const SizedBox(height: 4),
                          currentIndex == i
                              ? Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          )
                              : Container()
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ));
  }
}
```
### Settings
Three dots have been added in the main dart. These three dots is the settings button. The user can click on settings and will be redirected.  

```
import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package

class Settings extends StatelessWidget {
  const Settings({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Settings"), // Use CustomAppBar with "Settings" as title
      body: Center(
        child: Text('Settings'), // Display "Settings" text in the center of the screen
      ),
    ); // End Scaffold
  }
}
```
## Home page
This is how the home page is written. At this point there is not much to say about the home page. A piece of text has been added showing that the user is on the home page. More about the home page is coming soon!

```
import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import material.dart file

class Home extends StatefulWidget { // Create Home class that extends StatefulWidget
  @override
  State<Home> createState() => _MyHomePageState(); // Override createState() method to return a new instance of _MyHomePageState
}

class _MyHomePageState extends State<Home> { // Create _MyHomePageState class that extends State and takes in a generic type of Home
  @override
  Widget build(BuildContext context) { // Override build() method to return a new Scaffold widget
    return Scaffold(
      appBar: CustomAppBar("Home"), // Set the app bar to a CustomAppBar widget with a title of "Home"
      body: Center(
        child: Text("Homepage"), // Set the body of the Scaffold to a Center widget that contains a Text widget with the text "Homepage"
      ),
    );
  }
}
```
## Bluetooth page
```

```

### Bluetooth off Page
```

```

### Bluetooth find device page
```

```

## Current session page
On the current page there is a button that causes the session to be started. Pressing this button redirects the user to the heartbeat page. 

```
import 'package:app/HeartbeatData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `Current`
class Current extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const Current ({super.key});

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing an `ElevatedButton`
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Current"),
      body: Center(
          child: ElevatedButton(
              // When the button is pressed, it will navigate to the `HeartBeatPage`
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HeartBeatPage()));
              },
              // The button will have the text "Start session"
              child: Text('Start session'),
            // The button's style is set to a background color of black
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black
            ),
          ),

      ),
    ); //
  }
}


```

### Heartbeat data
In the heartbeat page, a session is started when the user has pressed the start button. The graph shows the processed data. In this case, it is the heartbeat. The data is written in a script. This script is read and eventually the data is fed to a database. If the session needs to be stopped, the user can click on stop session. The user is then navigated to the current page.

```
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

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: false,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}

```

## Sessions history page
A page has been created for the sessions history. The page now contains only a text with Sessions History. There will be more on this page soon.

```
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `History`
class History extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const History({super.key});

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing text that reads "Sessions History"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("History"),
      body: Center(
        child: Text("Sessions History")
      ),
    ); //
  }
}
```