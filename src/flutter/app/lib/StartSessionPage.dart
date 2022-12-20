// import '../flutter_flow/flutter_flow_icon_button.dart';
// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_util.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:app/main.dart'; // Import main.dart file

List<int> activeScripts = [];

class SelectScriptPageWidget extends StatefulWidget {
  const SelectScriptPageWidget({Key? key}) : super(key: key);

  @override
  _SelectScriptPageWidgetState createState() => _SelectScriptPageWidgetState();
}

class _SelectScriptPageWidgetState extends State<SelectScriptPageWidget> {
  TextEditingController? searchBarController;
  bool? checkboxListTileValue1;
  bool? checkboxListTileValue2;
  bool? checkboxListTileValue3;
  bool? checkboxListTileValue4;
  bool? checkboxListTileValue5;
  bool? checkboxListTileValue6;
  bool? checkboxListTileValue7;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchBarController = TextEditingController();
  }

  @override
  void dispose() {
    searchBarController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const scripts = [
      {'id': 4, 'name': "serge", 'description': "rosario"},
      {'id': 5, 'name': "serge", 'description': "rosario"},
      {'id': 6, 'name': "serge", 'description': "rosario"},
    ];

    void onScriptClick(script) {
      if (activeScripts.contains(script.id)) {
        activeScripts.removeWhere((element) => element == script.id);
      } else {
        activeScripts.add(script.id);
      }
    }

    List<Widget> scrollableSection = [];
    scrollableSection.add(Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
      child: Text(
        'Select scripts to use',
        // style: FlutterFlowTheme.of(context)
        //     .title3,
      ),
    ));
    scrollableSection.addAll(scripts
        .map((Map script) => ScriptListing(
            name: script['name'],
            description: script['description'],
            selected: false,
            onClick: () => onScriptClick(script)))
        .toList());

    return Scaffold(
      appBar: CustomAppBar("Current"),
      key: scaffoldKey,
      // backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      // labelColor: FlutterFlowTheme.of(context).primaryColor,
                      // unselectedLabelColor:
                      //     FlutterFlowTheme.of(context).secondaryText,
                      // labelStyle: FlutterFlowTheme.of(context).subtitle1,
                      // indicatorColor: FlutterFlowTheme.of(context).primaryColor,
                      tabs: [
                        Tab(
                          text: 'Scripts',
                        ),
                        Tab(
                          text: 'Sensors',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 70, 0, 120),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    children: scrollableSection,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 12, 8, 0),
                                      child: TextFormField(
                                        controller: searchBarController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Search for your shoes...',
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              // color:
                                              //     FlutterFlowTheme.of(context)
                                              //         .lineColor,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          // fillColor:
                                          //     FlutterFlowTheme.of(context)
                                          //         .primaryBackground,
                                          contentPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24, 24, 20, 24),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            // color: FlutterFlowTheme.of(context)
                                            //     .secondaryText,
                                            size: 16,
                                          ),
                                        ),
                                        // style: FlutterFlowTheme.of(context)
                                        //     .bodyText1,
                                        maxLines: null,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 12, 0),
                                    // child: FlutterFlowIconButton(
                                    //   borderColor: Colors.transparent,
                                    //   borderRadius: 30,
                                    //   borderWidth: 1,
                                    //   buttonSize: 50,
                                    //   icon: Icon(
                                    //     Icons.search_sharp,
                                    //     color: FlutterFlowTheme.of(context)
                                    //         .primaryText,
                                    //     size: 30,
                                    //   ),
                                    //   onPressed: () {
                                    //     print('IconButton pressed ...');
                                    //   },
                                    // ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: AlignmentDirectional(0, 1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 70),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        // color: FlutterFlowTheme.of(context)
                                        //     .secondaryBackground,
                                        ),
                                    // child: FFButtonWidget(
                                    //   onPressed: () {
                                    //     print('Button pressed ...');
                                    //   },
                                    //   text: 'Button',
                                    //   options: FFButtonOptions(
                                    //     width: 130,
                                    //     height: 40,
                                    //     color: FlutterFlowTheme.of(context)
                                    //         .primaryColor,
                                    //     textStyle: FlutterFlowTheme.of(context)
                                    //         .subtitle2
                                    //         .override(
                                    //           fontFamily: 'Poppins',
                                    //           color: Colors.white,
                                    //         ),
                                    //     borderSide: BorderSide(
                                    //       color: Colors.transparent,
                                    //       width: 1,
                                    //     ),
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 16, 0, 0),
                                  child: Text(
                                    'Categories',
                                    // style: FlutterFlowTheme.of(context).title3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScriptListing extends StatelessWidget {
  // final Map script;
  final String name;
  final String description;
  final bool selected;
  final void onClick;

  const ScriptListing(
      {Key? key,
      required this.name,
      required this.description,
      required this.selected,
      required this.onClick})
      : super(key: key);

  // const ScriptListing({Key? key, required this.script}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onScriptClick() {
      // if (activeScripts.contains(script['id'])) {
      //   activeScripts.removeWhere((element) => element == script['id']);
      // } else {
      //   activeScripts.add(script['id']);
      // }
    }

    // bool selected = activeScripts.contains(script['id']);

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
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
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
                      onChanged: ((bool? newValue) => true),
                      title: Text(
                        'Script name',
                        // style: FlutterFlowTheme
                        //         .of(context)
                        //     .title3,
                      ),
                      tileColor: Color(0xFFF1F4F8),
                      activeColor: Color(0xFF4B39EF),
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 24, 0),
                  child: Text(
                    'A very long description of the script goes here, it might be multiple lines',
                    // style:
                    //     FlutterFlowTheme.of(
                    //             context)
                    //         .bodyText2
                    //         .override(
                    //           fontFamily:
                    //               'Outfit',
                    //           color: Color(
                    //               0xFF57636C),
                    //           fontSize: 14,
                    //           fontWeight:
                    //               FontWeight
                    //                   .normal,
                    //         ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
