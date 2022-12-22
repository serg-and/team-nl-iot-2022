import 'package:app/start_session.dart';
import 'package:flutter/material.dart';
import 'data.dart';
// Import the other pages
import 'package:app/setup_session.dart';
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/select_scripts.dart';
import 'package:app/sessions.history.dart';
import 'home_page.dart';

List<int> sessionScripts = [];

class Routing extends StatefulWidget {
  const Routing({Key? key}) : super(key: key);

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  var currentIndex = 0;
  bool sessionActive = false;

  void startSession(List<int> scriptIds) {
    sessionScripts = scriptIds;
    setState(() {
      sessionActive = true;
    });
  }

  void stopSession() {
    sessionScripts = [];
    setState(() {
      sessionActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    Widget sessionPage = sessionActive
        ? HeartBeatPage(scriptIds: sessionScripts, stopSession: stopSession)
        // : SelectScripts(startSession: startSession);
        : StartSession(startSession: startSession);

    List routing = [
      Home(),
      const Bluetooth(),
      sessionPage,
      const History(),
    ];

    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // This is the widget that will be displayed at the current index
        routing.elementAt(currentIndex),
        Container(
          margin: EdgeInsets.all(displayWidth * .05),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xFFF59509),
              borderRadius: BorderRadius.all(Radius.circular(displayWidth))),
          child: currentIndex == 4
              ? GestureDetector(
                  // This is the "Book Now" button that will be displayed on the last screen
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
