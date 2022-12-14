class Script {
  int id;
  String name; // Name of the script
  String? description;
  String outputType; // bar_chart || line_chart
  String outputName; // Display name of the value

  Script(
      this.id, this.name, this.description, this.outputType, this.outputName);
}

class OutputValue {
  dynamic value;
  int timestamp;

  OutputValue(this.value, this.timestamp);
}

class ScriptOutput {
  int id;
  Script script;
  List<OutputValue>? values;

  ScriptOutput(this.id, this.script, this.values);
}
