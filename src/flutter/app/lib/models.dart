class Script {
  int id;// ID of the script
  String name; // Name of the script
  String? description;
  String outputType; // bar_chart || line_chart
  String outputName; // Display name of the value

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
  List<OutputValue>? values; // List of output values generated by the script

  ScriptOutput(this.id, this.script, this.values);
}

class TeamModel{
  int id;
  String name;
  List<TeamMemberModel> teamMembers;
  TeamModel(this.id, this.name, this.teamMembers);
}

class TeamMemberModel{
  int id;
  String name;

  TeamMemberModel(this.id, this.name);
}
