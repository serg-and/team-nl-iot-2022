# Code Documentation
This page contains the code for the app. In the code of the TeamNL MoveSens app, comments have been added so that the reader can understand what the functionalities do that have been used in the app. These comments are represented with a //. 
## Homepage
This is how the home page is written. At this point there is not much to say about the home page. A piece of text has been added showing that the user is on the home page. More about the home page is coming soon!

```
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
```

