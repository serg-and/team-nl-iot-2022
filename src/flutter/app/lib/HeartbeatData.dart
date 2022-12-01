import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class HeartBeatPage extends StatelessWidget {

  const HeartBeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Center(
        child: HeartBeatData(),
      ),
    ); //
  }
}

class HeartBeatData extends StatefulWidget {
  _HeartBeatState createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeatData>{
  int heartBeat = 0;
  late Timer update;
  Random random = new Random();

  @override
  void initState(){
    super.initState();

    update = Timer.periodic(Duration(milliseconds: 100), (Timer t){
      setState(() {
        heartBeat = 40 + random.nextInt(150 - 40);
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: new Text('HeartBeat = ' + heartBeat.toString()),
      ),
    );
  }
}