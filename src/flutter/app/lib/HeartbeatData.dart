import 'package:app/main.dart';
import 'package:flutter/material.dart';

class HeartBeatData extends StatelessWidget {

  const HeartBeatData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Center(
        child: Text('HeartBeat: 80'),
      ),
    ); //
  }
}