import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: Center(
        child: Text('Homepage'),
      ),
    ); //
  }
}