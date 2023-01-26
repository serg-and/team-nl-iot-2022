import 'package:app/constants.dart';
import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package
import 'models.dart';

List<Team> teams = [];

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    teams = [];

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
    fetchTeams();
    teamButtonWidget = _CreateTeamButton(this.callback);
  }
  // fetches the teams from supa base
  void fetchTeams() async {
    final data =
        await supabase.from('teams').select('id, name, team_members(id, name)');
    setState(() {
      data.forEach((record) => teams.add(Team.fromMap(record)));
    });
  }
  // callback function to update higher in the widget tree
  void callback() {
    setState(() {});
  }
 // list view of the hole page
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
            EdgeInsets.only(bottom: 128.0, left: 16.0, right: 16.0, top: 16.0),
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Text(
                      'Create New Team',
                      style: TextStyle(),
                    )),
                    Container(child: teamButtonWidget),
                  ])),
          // creates a column with all the teams fetched from supabase
          Column(
              children:
                  teams.map((team) => TeamOverView(team, callback)).toList())
        ],
      ),
    );
  }
}

class _CreateTeamButton extends StatefulWidget {
  final Function callback;

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

  // sends data to supabase when creating a team
  void createTeam() async {
    if (supabase.auth.currentSession?.user.id == null) {
      throw 'USER NOT AUTHENTICATED';
    }

    // get user uuid
    String uuid = supabase.auth.currentSession!.user.id;

    final res = await supabase
        .from('teams')
        .insert({
          'name': myController.text,
          'coach': uuid,
        })
        .select('id, name, team_members(id, name)')
        .single();

    setState(() => teams.add(Team.fromMap(res)));

    Navigator.pop(context);
    this.widget.callback();
  }

  // creates the button to create a team
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 50,
        child: ElevatedButton(
          child: Icon(size: 20.0, Icons.add, color: Colors.white),
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
                          onPressed: createTeam, child: const Text('Create'))
                    ],
                  );
                })
          },
        ));
  }
}

class TeamOverView extends StatefulWidget {
  final Team _team;
  final Function _callBack;
  TeamOverView(this._team, this._callBack);

  @override
  State<TeamOverView> createState() => _TeamOverViewState();
}

// The team bar with button to add team members. Adds teammembers to team in supabase
class _TeamOverViewState extends State<TeamOverView> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final _myControllerName = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _myControllerName.dispose();
    super.dispose();
  }

  void removeTeam() async {
    await supabase.from('team_members').delete().eq('team', widget._team.id);
    await supabase.from('teams').delete().eq('id', widget._team.id);
    setState(() => teams.remove(this.widget._team));
    this.widget._callBack();
    Navigator.pop(context);
  }

  // makes a teammember card with a remove button
  void addMember() async {
    // final TeamMember newTeamMember = new TeamMember(
    //   int.parse(_myControllerId.text),
    //   _myControllerName.text,
    // );
    final String name = _myControllerName.text;

    // final membersData = [...widget._team.teamMembers, newTeamMember]
    //     .map((member) => {'id': member.id, 'name': member.name})
    //     .toList();

    // await supabase
    //     .from('teams')
    //     .update({'members': membersData}).eq('id', widget._team.id);

    final _newMember = await supabase
        .from('team_members')
        .insert({
          'name': name,
          'team': widget._team.id,
        })
        .select()
        .single();

    final TeamMember newTeamMember = TeamMember.fromMap(_newMember);

    setState(() => this.widget._team.teamMembers.add(newTeamMember));

    Navigator.pop(context);
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
                      Text('${widget._team.name}', textAlign: TextAlign.center),
                      Row(children: [
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
                                              TextButton(
                                                  onPressed: addMember,
                                                  child: const Text('Create'))
                                            ],
                                          );
                                        })
                                  },
                              child: Icon(size: 20.0, Icons.add, color: Colors.white)),
                        ),
                        SizedBox(
                            width: 50,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () => {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure you want remove team "${widget._team.name}"'),
                                              actions: [
                                                TextButton(
                                                    onPressed: removeTeam,
                                                    child:
                                                        const Text('Remove')),
                                                TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                              ],
                                            );
                                          })
                                    },
                                child: Icon(
                                  size: 20.0,
                                  Icons.remove,
                                    color: Colors.white
                                )))
                      ])
                    ]),
              ))),
      TeamView(this.widget._team, this.widget._callBack)
    ]);
  }
}

class TeamView extends StatelessWidget {
  final Team _team;
  final Function _callBack;
  TeamView(this._team, this._callBack);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: _team.teamMembers
            .map((teamMember) => TeamMemberWidget(teamMember, _team, _callBack))
            .toList());
  }
}

class TeamMemberWidget extends StatefulWidget {
  final Team _team;
  final TeamMember teamMember;
  final Function _callback;
  TeamMemberWidget(this.teamMember, this._team, this._callback);

  @override
  State<TeamMemberWidget> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMemberWidget> {
  void removeMember() async {
    // final membersData = widget._teamModel.teamMembers
    //     .where((member) => member != widget.teamMember)
    //     .map((member) => {'id': member.id, 'name': member.name})
    //     .toList();

    // await supabase
    //     .from('teams')
    //     .update({'members': membersData}).eq('id', widget._teamModel.id);

    await supabase.from('team_members').delete().eq('id', widget.teamMember.id);

    setState(() => widget._team.teamMembers.remove(widget.teamMember));

    this.widget._callback();
    Navigator.pop(context);
  }

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
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Are you sure you want remove team member "${widget.teamMember.name}"'),
                                            actions: [
                                              TextButton(
                                                  onPressed: removeMember,
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
                                size: 10.0,
                                Icons.remove,
                                  color: Colors.white
                              )))
                    ]))));
  }
}
