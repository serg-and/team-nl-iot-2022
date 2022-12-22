import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:app/models.dart' as models;
import 'package:supabase_flutter/supabase_flutter.dart';

const Map<String, String> outputTypeDisplayNames = {
  'line_chart': 'Line Chart',
  'bar_chart': 'Bar Chart',
};

// This class defines a stateless widget called `History`
class History extends StatelessWidget {
  // The constructor takes a `Key` as an argument
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('History'),
      body: SessionHistoryPage(),
    );
  }
}

class SessionHistoryPage extends StatefulWidget {
  const SessionHistoryPage({Key? key}) : super(key: key);

  @override
  _SessionHistoryPageState createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends State<SessionHistoryPage> {
  final supabase = Supabase.instance.client;

  TextEditingController? searchBarController;
  List<models.Session> allSessions = [];
  List<models.Session> filteredSessions = [];

  @override
  void initState() {
    super.initState();
    searchBarController = TextEditingController();
    getSessions();
  }

  @override
  void dispose() {
    searchBarController?.dispose();
    super.dispose();
  }

  void getSessions() async {
    final _sessions = await supabase.from('sessions').select();

    setState(() {
      _sessions.forEach((s) => allSessions.add(models.Session(
            s['id'],
            s['name'],
            s['stated_at'],
            s['ended_at'],
          )));

      filteredSessions = allSessions;
    });
  }

  void onSessionClick(models.Session session) {
    print('navigate to session specific page: ${session.id}');
  }

  List<Widget> getScrollableSection() {
    List<Widget> scrollableSection = [];

    filteredSessions.forEach((session) {
      scrollableSection.add(SessionListing(session: session));
    });

    return scrollableSection;
  }

  void filterSessions() {
    final String? query = searchBarController?.text.toLowerCase();

    setState(() {
      if (query == null || query == '') {
        filteredSessions = allSessions;
        return;
      }

      // only show sessions that have the query string in their name
      filteredSessions = allSessions
          .where((models.Session session) => session.name.contains(query))
          .toList();
    });
  }

  void startSession() {}

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing text that reads "Sessions History"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: TextFormField(
              cursorColor: Colors.black,
              controller: searchBarController,
              onChanged: (value) => filterSessions(),
              obscureText: false,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Search for sessions',
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
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                contentPadding: EdgeInsetsDirectional.fromSTEB(19, 19, 19, 19),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              maxLines: null,
            ),
          ),
          Expanded(
            child: ListView(
              children: getScrollableSection(),
            ),
          )
        ],
      ),
    );
  }
}

class SessionListing extends StatelessWidget {
  final models.Session session;
  const SessionListing({Key? key, required this.session});

  @override
  Widget build(BuildContext context) {
     print(session.startedAt);

    return Container(
      width: 367.7,
      height: 103.3,
      decoration: BoxDecoration(),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(-0.92, 0),

            child:
            Text(
              'Description',
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 24, 0),
            child: Text( '${session.id} -- ${session.name} -- ${session.endedAt}',
                style: Theme.of(context).textTheme.bodyMedium),
    ),
        ],
      ),
    );
  }
}
