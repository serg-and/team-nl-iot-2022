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
    teamButtonWidget = _CreateTeamButton(this.callback);
  }

  void callback(){
    setState(() {

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            padding: EdgeInsets.only(bottom: 128.0, left: 16.0, right: 16.0, top: 16.0),
            children: [
              Container(
              padding: EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Text('Create New Team', style: TextStyle(),)
                        ),
                        Container(
                            child: teamButtonWidget
                        ),
                      ]
                  )
              ),
                  Column(
                    children: teams.map((team) => TeamOverView(team, callback)).toList()
                  )
                ],
              ),
        );

  }
}


class _CreateTeamButton extends StatefulWidget {
  Function callback;

  _CreateTeamButton(this.callback, {super.key});

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
    return SizedBox(
        width: 50,
        height: 50,
        child: ElevatedButton(
          child: Icon(
              size: 20.0,
              Icons.add
          ),
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
                          this.widget.callback();
                        });
                      },
                      child: const Text('Create'))
                ],
              );
            })
      },
    ));
  }
}

class TeamOverView extends StatefulWidget {
  final TeamModel _teamModel;
  final Function _callBack;
  TeamOverView(this._teamModel, this._callBack);

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
                  Text('${widget._teamModel.name}', textAlign: TextAlign.center),
                  Row(
                    children: [
                    SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Create Team'),

                                actions: [
                                  TextField(
                                    controller: _myControllerName,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'name',
                                    ),
                                  ),
                                  TextField(
                                    controller: _myControllerId,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'player ID',
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          print('name: ${_myControllerName.text} id: ${_myControllerId}');
                                          this.widget._teamModel.teamMembers.add(new TeamMemberModel(int.parse(_myControllerId.text), _myControllerName.text));
                                          Navigator.pop(context);
                                          print(this.widget._teamModel.teamMembers.map((teamMember) => 'name: ${teamMember.name} id: ${teamMember.id}'));
                                        });
                                      },
                                      child: const Text('Create'))
                                ],
                              );
                            })
                      },

                      child: Icon(
                        size: 20.0,
                        Icons.add
                      )
                  ),),
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Are you sure you want remove team "${widget._teamModel.name}"'),

                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              teams.remove(this.widget._teamModel);
                                              this.widget._callBack();
                                              Navigator.pop(context);
                                              });
                                          },
                                          child: const Text('Remove')),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text('Cancel')),
                                    ],
                                  );
                                })
                          },

                          child: Icon(
                              size: 20.0,
                              Icons.remove,
                          )
                      )

                  )])
                ]
              ),
            )
          )
      ),
      TeamView(this.widget._teamModel)
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
      padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 16.0),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),

              child: Row(
                  children: [Text('name: ${teamMember.name} \t\t\t ID: ${teamMember.id}')]
              )
          )
      )
    );
  }
}
