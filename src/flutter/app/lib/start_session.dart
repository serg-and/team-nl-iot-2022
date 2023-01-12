import 'package:app/main.dart';
import 'package:app/select_scripts.dart';
import 'package:app/pair_sensor.dart';
import 'package:app/team_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    getPreferredScripts();
    super.initState();
  }

  void validateState() {
    setState(() {
      validState = scriptIds.isNotEmpty;
    });
  }

  void onStartSession() {
    if (!validState) return;
    savePreferredScripts();
    widget.startSession(sessionNameController.text, scriptIds);
  }

  void getPreferredScripts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList('scripts');
    if (ids == null) return;

    setState(() {
      scriptIds = ids.map((String id) => int.parse(id)).toList();
    });
  }

  void savePreferredScripts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = scriptIds.map((int id) => id.toString()).toList();
    print('got ${ids}');
    prefs.setStringList('scripts', ids);
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

  void pairSensors() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PairSensorPage(),
      ),
    );
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
                          onTap: pairSensors,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 1),
                                  title: Text(
                                      'Pair Team Members  ${[].isEmpty ? "❗" : ""}'),
                                  subtitle: Text([].isEmpty
                                      ? 'No team members paired'
                                      : '${[].length.toString()} team members paired'),
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
