import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:jiffy/jiffy.dart';

// Model for the scripts that can be used to create data
class Script {
  int id; // ID of the script
  String name; // Name of the script
  String? description;
  String outputType; // bar_chart || line_chart
  String outputName; // Display name of the value

  Script.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        outputType = map['output_type'],
        outputName = map['output_name'];

  Script(
      this.id, this.name, this.description, this.outputType, this.outputName);
}

class OutputValue {
  dynamic value; // The output value
  int timestamp; // Timestamp for when the value was generated

  OutputValue(this.value, this.timestamp);
}

class ScriptOutput {
  int id; // ID of the script output
  Script script; // The script that generated the output
  List<OutputValue> values =
      []; // List of output values generated by the script

  ScriptOutput.fromMap(Map<String, dynamic> map, Script _script)
      : id = map['id'],
        script = _script;

  ScriptOutput(this.id, this.script, this.values);
}

//Model of the team
class Team {
  int id;
  String name;
  List<TeamMember> teamMembers = List.empty(growable: true);

  Team.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        teamMembers = createTeamMembersList(map['team_members']);

  Team(this.id, this.name);
}

class Coach {
  int id;
  String name;

  Coach(this.id, this.name);
}

class TeamMember extends ChangeNotifier {
  int id;
  String name;
  List<DiscoveredDevice> device = List.empty(growable: true);

  TeamMember.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];

  TeamMember(this.id, this.name);
}

List<TeamMember> createTeamMembersList(List<dynamic> list) {
  return list.map((member) => TeamMember.fromMap(member)).toList();
}

//Model of the session with end time and start time
class Session {
  int id;
  String name;
  Jiffy startedAt;
  Jiffy endedAt;

  Session.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        startedAt = Jiffy(map['started_at']),
        endedAt = Jiffy(map['ended_at']);

  Session(this.id, this.name, this.startedAt, this.endedAt);
}
