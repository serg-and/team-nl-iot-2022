import 'package:app/HeartbeatData.dart';
import 'package:app/bluetooth/pages/bluetooth_page.dart';
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
    const HeartBeatPage(),
    const History()
  ];
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            routing.elementAt(currentIndex),
            Container(
              margin: EdgeInsets.all(displayWidth * .05),
              height: displayWidth * .155,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child: currentIndex == 4
                  ? GestureDetector(
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