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
