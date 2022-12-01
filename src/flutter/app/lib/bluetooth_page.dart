import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/widgets/planing_grid.dart';

class Bluetooth extends StatelessWidget {
  const Bluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Bluetooth"),
      body: Container(
        child: PlaningGrid(),
      ),
    ); //
  }
}