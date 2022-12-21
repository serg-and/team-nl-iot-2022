import 'package:app/main.dart';
import 'package:app/select_scripts.dart';
import 'package:flutter/material.dart';

class StartSession extends StatefulWidget {
  final Function switchToSession;
  const StartSession({Key? key, required this.switchToSession});

  static TextEditingController sessionNameController = TextEditingController();

  @override
  State<StartSession> createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Start a Session"),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      runSpacing: 25,
                      children: [
                        Text(
                          'Start a Session',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextFormField(
                          controller: StartSession.sessionNameController,
                          cursorColor: Colors.black,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: 'Session name',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          maxLines: 1,
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SelectScripts(switchToSession: () => null),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Scripts',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 80),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          // color: FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                      child: TextButton(
                        child: Text('Start Sesson',
                            style: Theme.of(context).textTheme.button),
                        onPressed: () => null,
                        // onPressed: () => startSession(),
                        // style: ButtonStyle(
                        //   backgroundColor:
                        //       MaterialStatePropertyAll(getStartButtonColor()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
