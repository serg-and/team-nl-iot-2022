import 'package:app/routing.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAY 3 APP UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Routing(),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final navigatorKey = GlobalKey<NavigatorState>();
  final String title;

  CustomAppBar(this.title, {Key? key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('TeamNL'),
      centerTitle: true,
      backgroundColor: Colors.deepOrange,
      actions: [
        PopupMenuButton(
            itemBuilder: (ctx) => [
                  const PopupMenuItem(
                      value: "Settings", child: Text("Settings"))
                ],
            onSelected: (result) {
              if (title != "Settings") {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              }
            })
      ],
    );
  }
}
