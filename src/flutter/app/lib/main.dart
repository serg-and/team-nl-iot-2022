import 'package:app/HeartbeatData.dart';
import 'package:app/home_page.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Home()
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final navigatorKey = GlobalKey<NavigatorState>();
  final String title;

  CustomAppBar(this.title, { Key? key }) : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('TeamNL'),
      centerTitle: true,
      backgroundColor: Colors.deepOrange,
      actions: [
        PopupMenuButton(
            itemBuilder: (ctx) =>
            [
              const PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings")
              ),
              const PopupMenuItem(
                  value: "HeartBeatData",
                  child: Text('HeartBeatData')
              )
            ],
            onSelected: (result) {
              if (result == "Settings") {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Settings()));
              }else{
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const HeartBeatPage()));
              }
            }
        )
      ],
    );
  }
}

