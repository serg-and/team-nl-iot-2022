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