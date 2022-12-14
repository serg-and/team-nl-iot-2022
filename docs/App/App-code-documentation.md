# Code Documentation
This page contains the code for the app. In the code of the TeamNL MoveSens app, comments have been added so that the reader can understand what the functionalities do that have been used in the app. These comments are represented with a //. 

## Home page
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
## Bluetooth page
```

```

### Bluetooth off Page
```

```

### Bluetooth find device page
```

```

## Current session page
On the current page there is a button that causes the session to be started. Pressing this button redirects the user to the heartbeat page. 

```
import 'package:app/HeartbeatData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `Current`
class Current extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const Current ({super.key});

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing an `ElevatedButton`
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Current"),
      body: Center(
          child: ElevatedButton(
              // When the button is pressed, it will navigate to the `HeartBeatPage`
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HeartBeatPage()));
              },
              // The button will have the text "Start session"
              child: Text('Start session'),
            // The button's style is set to a background color of black
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black
            ),
          ),

      ),
    ); //
  }
}


```

### Heartbeat data
```

```

## Sessions history page
A page has been created for the sessions history. The page now contains only a text with Sessions History. There will be more on this page soon.

```
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `History`
class History extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const History({super.key});

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing text that reads "Sessions History"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("History"),
      body: Center(
        child: Text("Sessions History")
      ),
    ); //
  }
}
```