
import 'package:app/HeartbeatData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Current extends StatelessWidget {
  const Current ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Current"),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HeartBeatPage()));
              },
              child: Text('Start session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black
            ),
          ),

      ),
    ); //
  }
}
