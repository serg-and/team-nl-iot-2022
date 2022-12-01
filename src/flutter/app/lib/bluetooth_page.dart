import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Bluetooth extends StatelessWidget {
  const Bluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Bluetooth"),
      body: Center(
        child: Text('Bluetooth'),
      ),
    ); //
  }
}