
import 'package:flutter/material.dart';

import 'main.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("History"),
      body: Container(
        child: Text("Sessions History")
      ),
    ); //
  }
}