import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import material.dart file

class Home extends StatefulWidget { // Create Home class that extends StatefulWidget
  @override
  State<Home> createState() => _MyHomePageState(); // Override createState() method to return a new instance of _MyHomePageState
}

class _MyHomePageState extends State<Home> { // Create _MyHomePageState class that extends State and takes in a generic type of Home
  @override
  Widget build(BuildContext context) { // Override build() method to return a new Scaffold widget
    return Scaffold(
      appBar: CustomAppBar("Home"), // Set the app bar to a CustomAppBar widget with a title of "Home"
      body: Center(
        child: Text("Homepage"), // Set the body of the Scaffold to a Center widget that contains a Text widget with the text "Homepage"
      ),
    );
  }
}
