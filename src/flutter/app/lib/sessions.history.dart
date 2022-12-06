
import 'package:flutter/material.dart';

import 'main.dart';

class History extends StatelessWidget {
  const History({super.key});

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