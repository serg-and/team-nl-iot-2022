import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package
import 'models.dart';

List<TeamModel> teams = [];

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Settings"),
        body: Container(
            padding: EdgeInsets.only(top: 24),
            child: _CreateTeam()) // Use CustomAppBar with "Settings" as title
        );
// End Scaffold
  }
}

class _CreateTeam extends StatelessWidget {
  const _CreateTeam({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            children: [
              Row(children: [
                Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text('Create New Team')),
                Container(
                    padding: EdgeInsets.only(left: 16.0), child: _CreateTeamButton()),
              ]),
              Column(
                children: teams.map((team) => TeamOverView(team)).toList()
              )
    ]));
  }
}

class _CreateTeamButton extends StatefulWidget {
  const _CreateTeamButton({super.key});

  @override
  State<_CreateTeamButton> createState() => _CreateTeamButtonState();
}

class _CreateTeamButtonState extends State<_CreateTeamButton> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Icon(Icons.add),
      onPressed: () => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Create Team'),
                actions: [
                  TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Team name',
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          print('Team name: ' + myController.text);
                          teams.add(new TeamModel(myController.text));
                          Navigator.pop(context);
                          print(teams.map((team) => team.name));
                          _CreateTeam();
                        });
                      },
                      child: const Text('Create'))
                ],
              );
            })
      },
    );
  }
}

class TeamOverView extends StatelessWidget {
  final TeamModel _teamModel;
  TeamOverView(this._teamModel);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          child: Card(
            child: Text('${_teamModel.name}'),
      ))
    ]);
  }
}

class TeamView extends StatelessWidget {
  final TeamModel _teamModel;
  TeamView(this._teamModel);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: _teamModel.teamMembers
            .map((teamMember) => TeamMember(teamMember))
            .toList());
  }
}

class TeamMember extends StatelessWidget {
  final TeamMemberModel teamMember;
  TeamMember(this.teamMember);

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [Text(teamMember.name), Text(teamMember.id.toString())],
    ));
  }
}
