import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package
import 'package:app/constants.dart';
import 'models.dart';

List<Team> teams = [];

class PairSensorPage extends StatelessWidget {
  const PairSensorPage({super.key}); // Constructor for Settings class

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
  Team? selected = null;

  void initState() {
    teams = []; // reset teams
    super.initState();
    fetchTeams();
  }

  void fetchTeams() async {
    final data =
        await supabase.from('teams').select('id, name, team_members(id, name)');
    setState(() {
      data.forEach((record) => teams.add(Team.fromMap(record)));
    });
  }

  void callback() {
    setState(() {});
  }

  // send the IDs of the members back to the start_session page
  void onConfirm() {
    Navigator.pop(
      context,
      selected?.teamMembers.map((member) => member.id).toList(),
    );
  }

  void unpairAll() {
    print('unpair all sensors');
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonExample(
          setTeam: (Team team) => setState(() => selected = team),
        ),
        Expanded(
          child: (selected == null)
              ? SizedBox.shrink()
              : ListView(
                  padding: EdgeInsets.only(
                      bottom: 128.0, left: 16.0, right: 16.0, top: 16.0),
                  children: [
                    Column(
                        children: selected!
                                .teamMembers.isEmpty //Shows the teams
                            ? [
                                Text('Team has no team members')
                              ] // Shows that there are no team members in the teams, the user have to create them
                            : selected!.teamMembers
                                .map((member) => TeamMemberWidget(
                                    member, selected!, callback))
                                .toList())
                  ],
                ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: unpairAll,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: Icon(Icons.close),
                label: Text(
                  'Unpair All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF59509)),
                icon: Icon(Icons.check),
                label: Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TeamOverView extends StatefulWidget {
  final Team _team;
  final Function _callBack;
  TeamOverView(this._team, this._callBack);

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
                      Text('${widget._team.name}', textAlign: TextAlign.center),
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

class DropdownButtonExample extends StatefulWidget {
  final Function setTeam;
  const DropdownButtonExample({super.key, required this.setTeam});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    // Dropdown options
    List<DropdownMenuItem<String>>? items = teams.map((Team item) {
      return DropdownMenuItem<String>(
        value: item.id.toString(),
        child: Text(item.name),
      );
    }).toList();

    // add empty value option of no value is selected
    if (selected == '')
      items.insert(
          0,
          DropdownMenuItem<String>(
            value: '',
            child: Text('Select Team'), //Text
          ));

    return DropdownButton<String>(
      value: selected,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      underline: Container(
        height: 4,
        color: Colors.orange,
      ),
      onChanged: (String? id) {
        // This is called when the user selects an item.
        setState(() => selected = id!);
        widget.setTeam(teams.firstWhere((team) => team.id.toString() == id));
      },
      items: items,
    );
  }
}

class _TeamMemberState extends State<TeamMemberWidget> {
  void pairSensor() {}

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
                    ElevatedButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Pair Sensor'),
                              actions: [
                                Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sensor Name'),
                                      ElevatedButton(
                                          onPressed: () =>
                                              print('pressed button'),
                                          child: Text('pair'))
                                    ],
                                  ),
                                ])
                                // TextField(
                                //   controller: myController,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(),
                                //     labelText: 'Team name',
                                //   ),
                                // ),
                                // TextButton(
                                //     onPressed: createTeam,
                                //     child: const Text('Create'))
                              ],
                            );
                          }),
                      child: Text('Pair Sensor'),
                    )
                  ],
                ))));
  }
}