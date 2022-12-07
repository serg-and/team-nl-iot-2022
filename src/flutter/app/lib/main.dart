import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/onboarding_page.dart';
import 'package:app/routing.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showHome ? Routing() : OnBoardingPage(),
      debugShowCheckedModeBanner: false,
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
      backgroundColor: Color(0xFFF59509),
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
