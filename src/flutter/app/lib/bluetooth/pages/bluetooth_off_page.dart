import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color.fromRGBO(43, 126, 189, 1),
              Color.fromRGBO(33, 142, 203, 1),
              Color.fromRGBO(21, 160, 220, 1),
              Color.fromRGBO(14, 172, 230, 1),
              Color.fromRGBO(6, 185, 241, 1),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.bluetooth,
              size: MediaQuery.of(context).size.width * 0.15,
              color: Colors.white,
            ),
            Column(
              children: <Widget>[
                Text(
                  'Connect',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white, fontSize: 40),
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    'to any movesense sensor nearby you',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle2
                        ?.copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
                TextButton(
                  child: const Text('TURN ON',
                      style: TextStyle(color: Colors.orange)),
                  onPressed: Platform.isAndroid
                      ? () => FlutterBluePlus.instance.turnOn()
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
