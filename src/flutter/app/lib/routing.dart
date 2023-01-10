import 'package:app/auth/register_page.dart';
import 'package:app/constants.dart';
import 'package:app/current_session.dart';
import 'package:app/sessions.history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bluetooth/bluetooth_screen.dart';
import 'data.dart';
// Import the other pages
import 'package:app/setup_session.dart';
// import 'package:app/bluetooth/pages/bluetooth_page.dart';
import 'package:app/start_session.dart';
// import 'package:app/select_scripts.dart';
// import 'package:app/sessions.history.dart';

String? sessionName;
List<int> sessionScripts = [];

class Routing extends StatefulWidget {
  const Routing({Key? key}) : super(key: key);

  @override
  State<Routing> createState() => _RoutingState();
}

class _RoutingState extends State<Routing> {
  bool isAuthenticated = DebugConfig.loginDisabled;
  var currentIndex = 0;
  bool sessionActive = false;

  @override
  void initState() {
    restoreSession();
    setupAuthListener();
    super.initState();
  }

  void restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    bool exist = prefs.containsKey(PERSIST_SESSION_KEY);
    if (!exist) return;

    String? jsonStr = prefs.getString(PERSIST_SESSION_KEY);
    if (jsonStr == null) return;

    /**
     * TODO: we need a timer to call refresh session before the current session expired. 
     * The default expiring time is 3600. Only in 1 hour
     * */
    final response = await supabase.auth.recoverSession(jsonStr);
    if (response.session == null) {
      prefsRemovePersistSessionString();
      return;
    }
  }

  // listen to all authentication state changes and update routing state
  void setupAuthListener() {
    // supabase.auth.currentSession.persistSessionString;
    supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        setState(() => isAuthenticated = true);
        prefsSetPersistSessionString(
            supabase.auth.currentSession?.persistSessionString);
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() => isAuthenticated = false);
        prefsRemovePersistSessionString();
      }
    });
  }

  void prefsSetPersistSessionString(String? sessionString) async {
    if (sessionString == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PERSIST_SESSION_KEY, sessionString);
  }

  void prefsRemovePersistSessionString() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(PERSIST_SESSION_KEY);
  }

  void startSession(String? name, List<int> scriptIds) {
    sessionName = name;
    sessionScripts = scriptIds;
    setState(() {
      sessionActive = true;
    });
  }

  void stopSession() {
    sessionName = null;
    sessionScripts = [];
    setState(() {
      sessionActive = false;
    });
  }

  List routing = [Current(), const BluetoothScreen(), const History()];
  @override
  Widget build(BuildContext context) {
    // set routing to register/login page if user is not authenticated
    if (!isAuthenticated) {
      return RegisterPage(isRegistering: true);
    }

    double displayWidth = MediaQuery.of(context).size.width;
    Widget sessionPage = sessionActive
        ? HeartBeatPage(
            name: sessionName,
            scriptIds: sessionScripts,
            stopSession: stopSession,
          )
        // : SelectScripts(startSession: startSession);
        : StartSession(startSession: startSession);

    List routing = [
      sessionPage,
      const BluetoothScreen(),
      const History(),
    ];

    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // This is the widget that will be displayed at the current index
        routing.elementAt(currentIndex),
        Container(
          margin: EdgeInsets.all(displayWidth * .05),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xFFF59509),
              borderRadius: BorderRadius.all(Radius.circular(displayWidth))),
          child: currentIndex == 4
              ? GestureDetector(
                  // This is the "Book Now" button that will be displayed on the last screen
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Book Now ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.home,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(bottomBar.length, (i) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          currentIndex = i;
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            bottomBar[i],
                            const SizedBox(height: 4),
                            currentIndex == i
                                ? Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    })
                  ],
                ),
        ),
      ],
    ));
  }
}
