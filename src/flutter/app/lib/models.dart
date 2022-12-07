class Script {
  int id;
  String name;
  String? description;
  String outputType;
  String outputName;

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
