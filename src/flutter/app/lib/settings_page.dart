import 'package:app/main.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Settings"),
      body: Center(
        child: Text('Settings'),
      ),
    ); //
  }
}