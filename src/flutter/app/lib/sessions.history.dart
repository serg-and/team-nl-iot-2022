import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:app/models.dart';
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
      body: SessionHistoryPage(

      ),
    );
  }
}

class SessionHistoryPage extends StatefulWidget {
  const SessionHistoryPage({Key? key})
      : super(key: key);

  @override
  _SessionHistoryPageState createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends State<SessionHistoryPage> {
  final supabase = Supabase.instance.client;

  TextEditingController? searchBarController;
  List<Script> allScripts = [];
  List<Script> filteredScripts = [];
  List<int> selectedScripts = [];

  @override
  void initState() {
    super.initState();
    searchBarController = TextEditingController();
    getScripts();
  }

  @override
  void dispose() {
    searchBarController?.dispose();
    super.dispose();
  }

  void getScripts() async {
    final _scripts = await supabase.from('scripts').select();

    setState(() {
      _scripts.forEach((s) => allScripts.add(Script(s['id'], s['name'],
          s['description'], s['output_type'], s['output_name'])));

      filteredScripts = allScripts;
    });
  }

  void onScriptClick(Script script) {
    setState(() {
      if (selectedScripts.contains(script.id)) {
        selectedScripts.removeWhere((element) => element == script.id);
      } else {
        selectedScripts.add(script.id);
      }
    });
  }

  List<Widget> getScrollableSection() {
    List<Widget> scrollableSection = [];

    // // top padding, place below search bar
    // scrollableSection.add(Padding(
    //   padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
    //   child: Text('Select scripts to use',
    //       style: Theme.of(context).textTheme.headlineSmall
    //       // style: FlutterFlowTheme.of(context)
    //       //     .title3,
    //       ),
    // ));

    // All scripts

    return scrollableSection;
  }

  void filterScripts() {
    final String? query = searchBarController?.text.toLowerCase();

    setState(() {
      if (query == null || query == '') {
        filteredScripts = allScripts;
        return;
      }

      // only show scripts that have the query string in their name or description
      filteredScripts = allScripts
          .where((Script script) =>
              '${script.name.toLowerCase()} ${script.description?.toLowerCase()}'
                  .contains(query))
          .toList();
    });
  }

  void startSession() {
  }

  Color getStartButtonColor() {
    if (selectedScripts.isEmpty) {
      return Colors.grey;
    }
    return Color(0xFFF59509);
  }

  // This is the `build` method, which returns a `Scaffold` widget with a custom `AppBar` and a `Center` widget
  // containing text that reads "Sessions History"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: BoxDecoration(),
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
                  decoration: BoxDecoration(),
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
                        decoration: BoxDecoration(),
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
                        decoration: BoxDecoration(),
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
