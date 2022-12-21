import 'package:app/main.dart';
import 'package:flutter/material.dart';


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
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(-0.3, -0.68),
                  child: Container(
                    width: 367.7,
                    height: 103.3,
                    decoration: BoxDecoration(
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.92, 0),
                          child: Text(
                            'Description',
                          ),
                        ),
                        Text(
                          'Script name',
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-0.3, -0.25),
                  child: Container(
                    width: 367.7,
                    height: 103.3,
                    decoration: BoxDecoration(
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.92, -0.34),
                        child: Text(
                          'Script name',
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.84, -0.22),
                        child: Text(
                          'Description',
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.3, 0.16),
                        child: Container(
                          width: 367.7,
                          height: 103.3,
                          decoration: BoxDecoration(
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(-0.9, 0),
                            child: Text(
                              'Description\n',
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.91, 0.03),
                        child: Text(
                          'Script name',
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.09, -0.92),
                        child: Text(
                          'All sessions history',
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-0.38, 0.58),
                        child: Container(
                          width: 367.7,
                          height: 103.3,
                          decoration: BoxDecoration(
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.9, 0),
                                child: Text(
                                  'Description\n',
                                ),
                              ),
                              Text(
                                'Script name',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

