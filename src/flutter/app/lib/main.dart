// Import the pages
import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/configure_supabase.dart';
import 'package:app/onboarding_page.dart';
import 'package:app/routing.dart';
import 'package:app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await configureApp(); // Awaiting the configuration of the app

  final prefs = await SharedPreferences.getInstance();// Getting the shared preferences instance
  final showHome = prefs.getBool('showHome') ?? false;// Getting the value for 'showHome' from the shared preferences, or false if it does not exist

  runApp(MyApp(showHome: showHome));// Running the MyApp widget
}

class MyApp extends StatelessWidget {
  final bool showHome; // Declaring a boolean variable 'showHome'

  const MyApp({
    Key? key,
    required this.showHome, // The 'showHome' variable is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showHome ? Routing() : OnBoardingPage(),// If showHome is true, display the Routing widget, otherwise display the OnBoardingPage
      debugShowCheckedModeBanner: false, // Don't show the debug banner
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize; // The preferred size of the app bar
  final navigatorKey = GlobalKey<NavigatorState>(); // A key to access the app's navigator
  final String title; // The title to display in the app bar

  CustomAppBar(this.title, {Key? key})
      : preferredSize = Size.fromHeight(50.0), // Set the app bar's preferred height to 50.0
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('TeamNL'), // Set the app bar's title to 'TeamNL'
      centerTitle: true,
      backgroundColor: Color(0xFFF59509), // Set the background color to a hex color code
      actions: [
        PopupMenuButton(
            itemBuilder: (ctx) => [
                  const PopupMenuItem(
                      value: "Settings", child: Text("Settings"))
                ],// Set the items in the popup menu to a single 'Settings' option
            onSelected: (result) {
              if (title != "Settings") { // If the selected item is not 'Settings'
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()));
              }
            })
      ],
    );
  }
}
