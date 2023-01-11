import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package

import 'models.dart';

List<TeamModel> teams = [];


class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Team Settings"),
        body: Container(
            child: _CreateTeam()) // Use CustomAppBar with "Settings" as title
    );
// End Scaffold
  }
}

class _CreateTeam extends StatefulWidget {
  const _CreateTeam({super.key});

  @override
  State<_CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<_CreateTeam> {
  late Widget teamButtonWidget;
  @override
  void initState() {
    super.initState();

  }

  void callback() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
        EdgeInsets.only(bottom: 128.0, left: 16.0, right: 16.0, top: 16.0),
        children: [
          Column(
              children:
              teams.map((team) => TeamOverView( callback)).toList())
        ],
      ),
    );
  }
}

class TeamOverView extends StatefulWidget {
  final Function _callBack;
  TeamOverView(this._callBack);

  @override
  State<TeamOverView> createState() => _TeamOverViewState();
}

class _TeamOverViewState extends State<TeamOverView> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final _myControllerName = TextEditingController();
  final _myControllerId = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _myControllerName.dispose();
    _myControllerId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              color: Colors.grey[300],
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.15,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget._teamModel.name}',
                          textAlign: TextAlign.center),
                      Row(children: [

                      ])
                    ]),
              ))),
      TeamView(this.widget._teamModel, this.widget._callBack)
    ]);
  }
}

class TeamView extends StatelessWidget {
  final TeamModel _teamModel;
  final Function _callBack;
  TeamView(this._teamModel, this._callBack);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: _teamModel.teamMembers
            .map((teamMember) => TeamMember(teamMember, _teamModel, _callBack))
            .toList());
  }
}

class TeamMember extends StatefulWidget {
  final TeamModel _teamModel;
  final TeamMemberModel teamMember;
  final Function _callback;
  TeamMember(this.teamMember, this._teamModel, this._callback);

  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'name: ${widget.teamMember.name} \t\t\t ID: ${widget.teamMember.id}'),
                    ]))));
  }
}

