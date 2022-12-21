// import '../flutter_flow/flutter_flow_icon_button.dart';
// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_util.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/main.dart';
import 'package:app/models.dart';

const Map<String, String> outputTypeDisplayNames = {
  'line_chart': 'Line Chart',
  'bar_chart': 'Bar Chart',
};

class SelectScripts extends StatefulWidget {
  final Function switchToSession;
  const SelectScripts({Key? key, required this.switchToSession})
      : super(key: key);

  @override
  _SelectScriptsState createState() => _SelectScriptsState();
}

class _SelectScriptsState extends State<SelectScripts> {
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
    scrollableSection.addAll(filteredScripts
        .map((Script script) => ScriptListing(
            script: script,
            selected: selectedScripts.contains(script.id),
            onClick: () => onScriptClick(script)))
        .toList());

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
    widget.switchToSession(selectedScripts);
  }

  Color getStartButtonColor() {
    if (selectedScripts.isEmpty) {
      return Colors.grey;
    }
    return Color(0xFFF59509);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          "Select Scripts",
          showOptions: false,
        ),
        // backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: searchBarController,
                    onChanged: (value) => filterScripts(),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Search for scripts',
                      // labelStyle:
                      //     FlutterFlowTheme.of(context)
                      //         .bodyText2,
                      // hintStyle:
                      //     FlutterFlowTheme.of(context)
                      //         .bodyText2,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          // color:
                          //     FlutterFlowTheme.of(context)
                          //         .lineColor,
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
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(19, 19, 19, 19),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                    // style: FlutterFlowTheme.of(context)
                    //     .bodyText1,
                    maxLines: 1,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: getScrollableSection(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 30),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Ok',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 30),
              ],
            ),
          ],
        ));
  }
}

class ScriptListing extends StatelessWidget {
  final Script script;
  final bool selected;
  final Function onClick;

  const ScriptListing(
      {Key? key,
      required this.script,
      required this.selected,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x34111417),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Theme(
                    data: ThemeData(
                      checkboxTheme: CheckboxThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      unselectedWidgetColor: Color(0xFF95A1AC),
                    ),
                    child: CheckboxListTile(
                      value: selected,
                      onChanged: (value) => onClick(),
                      title: Text(
                        script.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      tileColor: Color(0xFFF1F4F8),
                      subtitle: Text(
                          outputTypeDisplayNames[script.outputType] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge),
                      activeColor: Color(0xFFF59509),
                      checkColor: Colors.white,
                      dense: false,
                      controlAffinity: ListTileControlAffinity.trailing,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                if (script.description != '')
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 24, 0),
                    child: Text(script.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
