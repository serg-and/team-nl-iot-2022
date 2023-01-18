import 'package:app/setup_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// This class defines a stateless widget called `Current`
class Current extends StatefulWidget {
  // The constructor takes a `Key` as an argument
  const Current({super.key});

  static const scripts = [
    {'name': "serge", 'description': "rosario"},
    {'name': "serge", 'description': "rosario"},
    {'name': "serge", 'description': "rosario"},
  ];

  @override
  State<Current> createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  List<int> selected = [];

  void onScriptClick(script) {
    if (selected.contains(script.id)) {
      selected.removeWhere((element) => element == script.id);
    } else {
      selected.add(script.id);
    }
  }

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Current"),
      body: Stack(
        children: [
          ListView(
              children: Current.scripts
                  .map((Map script) => Overview(
                      name: script['name'],
                      description: script['description'],
                      onClick: () => onScriptClick(script)))
                  .toList()),
          Positioned(
            child: Align(
              alignment: FractionalOffset.centerLeft,
              child: ElevatedButton(
                // When the button is pressed, it will navigate to the `LiveSession`
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LiveSession(
                                scriptIds: [],
                                memberIds: [],
                                stopSession: () => null,
                              )));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                // The button will have the text "Start session"
                child: Text('Start session'),
                // The button's style is set to a background color of black
              ),
            ),
          ),
        ],
      ),
    ); //
  }
}

class Overview extends StatelessWidget {
  final String name;
  final String description;
  final void onClick;

  const Overview(
      {Key? key,
      required this.name,
      required this.description,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(description),
    );
  }
}
