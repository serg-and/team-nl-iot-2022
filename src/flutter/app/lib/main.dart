import 'package:app/bluetooth_page.dart';
import 'package:app/home_page.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Bluetooth(),
  ];

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
          bottomNavigationBar: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: Colors.black, // put the color here
            ),
            child: BottomNavigationBar(
                elevation: 0.0,
                currentIndex: _selectedIndex,
                backgroundColor: Colors.transparent,
                unselectedItemColor: Colors.white,
                selectedItemColor: Colors.deepOrange,
                showUnselectedLabels: false,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: "Bluetooth"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.accessibility_sharp),
                      label: "Session"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.history), label: "History"),
                ]), // don't forget to put it
          ),
          body: Center(
            child: _widgetOptions[_selectedIndex],
          )
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
              )
            ],
            onSelected: (result) {
              if (title != "Settings") {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Settings()));
              }
            }
        )
      ],
    );
  }
}

