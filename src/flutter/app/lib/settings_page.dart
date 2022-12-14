import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package

class Settings extends StatelessWidget {
  const Settings({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Settings"), // Use CustomAppBar with "Settings" as title
      body: Center(
        child: Text('Settings'), // Display "Settings" text in the center of the screen
      ),
    ); // End Scaffold
  }
}