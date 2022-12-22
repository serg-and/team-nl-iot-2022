import 'package:app/main.dart';
import 'package:app/select_scripts.dart';
import 'package:flutter/material.dart';

class StartSession extends StatefulWidget {
  final Function startSession;
  const StartSession({Key? key, required this.startSession});

  @override
  State<StartSession> createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  static TextEditingController sessionNameController = TextEditingController();
  List<int> scriptIds = [];
  bool validState = false;

  void validateState() {
    setState(() {
      validState = scriptIds.isNotEmpty;
    });
  }

  void onStartSession() {
    if (!validState) return;
    widget.startSession(sessionNameController.text, scriptIds);
  }

  void navigateToSelectScripts() async {
    // wait for script select page to finish,
    // page will return a list of selected script ids
    List<int>? newScriptIds = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectScripts(
          alreadySelected: scriptIds,
        ),
      ),
    );

    setState(() {
      scriptIds = newScriptIds != null ? newScriptIds : scriptIds;
    });

    validateState();
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
                      runSpacing: 20,
                      children: [
                        Text(
                          'Start a Session',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextFormField(
                          onChanged: (value) => validateState(),
                          controller: sessionNameController,
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
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 1),
                                  title: Text(
                                      'Configure Scripts  ${scriptIds.isEmpty ? "❗" : ""}'),
                                  subtitle: Text(scriptIds.isEmpty
                                      ? 'No scripts selected'
                                      : '${scriptIds.length.toString()} scripts selected'),
                                ),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => print('confiugre team'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 1),
                                  title: Text(
                                      'Configure Team Members  ${[].isEmpty ? "❗" : ""}'),
                                  subtitle: Text([].isEmpty
                                      ? 'No team members'
                                      : '${[].length.toString()} Team Members'),
                                ),
                              ),
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
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 90),
                    child: ElevatedButton(
                      onPressed: validState ? onStartSession : null,
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
