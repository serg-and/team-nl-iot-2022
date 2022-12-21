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
  List<int> scriptIds = [];
  bool validState = false;

  void validateState() {
    print(scriptIds);
    setState(() {
      validState = true;
    });
  }

  void startSession() {}

  void navigateToSelectScripts() async {
    // wait for script select page to finish,
    // page will return a list of selected script ids
    List<int> newScriptIds = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectScripts(
          alreadySelected: scriptIds,
        ),
      ),
    );

    setState(() {
      scriptIds = newScriptIds;
    });
  }

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
                          onChanged: (value) => validateState(),
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
                          onTap: navigateToSelectScripts,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Scripts',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(scriptIds.length.toString()),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 80),
                    child: ElevatedButton(
                      onPressed: validState ? startSession : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Session',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ]),
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
