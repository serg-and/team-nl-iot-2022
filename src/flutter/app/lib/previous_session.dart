import 'dart:ffi';
import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/graph_builder.dart';
import 'package:app/main.dart';
import 'package:app/models.dart';
import 'package:app/widgets/items.dart';
import 'package:flutter/material.dart';

class Result {
  String name;
  String outputName;
  List<MemberResult> members;

  Result(this.name, this.outputName, this.members);
}

class MemberResult {
  String name;
  List values;

  MemberResult(this.name, this.values);
}

class PreviousSession extends StatefulWidget {
  final Session session;
  const PreviousSession({super.key, required this.session});

  @override
  State<PreviousSession> createState() => _PreviousSessionState();
}

class _PreviousSessionState extends State<PreviousSession> {
  // List<Widget> outputs = [];
  final Map<int, Result> results = {};

  @override
  void initState() {
    fetchSessionOutputs();
    super.initState();
  }

  void fetchSessionOutputs() async {
    final _outputs = await supabase
        .from('script_outputs')
        .select('*, script(id, name, output_name), team_member(name)')
        .eq('session', widget.session.id);

    setState(() {
      _outputs.forEach((output) {
        if (!results.containsKey(output['script']['id'])) {
          results[output['script']['id']] = Result(
            output['script']['name'],
            output['script']['output_name'],
            [],
          );
        }

        Result result = results[output['script']['id']]!;

        result.members.add(MemberResult(
          output['team_member']['name'],
          output['values'],
        ));
      });
    });
  }

  List<Widget> getOutputListings() {
    List<Widget> widgets = [];

    results.forEach((key, result) {
      widgets.add(OutputListing(result: result));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(widget.session.name),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: getOutputListings(),
            ),
          ),
        ],
      ),
    );
  }
}

class OutputListing extends StatelessWidget {
  final Result result;

  const OutputListing({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return LiftedCard(
      child: Padding(
          padding: EdgeInsets.all(12),
          child: Wrap(
            // crossAxisAlignment: CrossAxisAlignment.start,
            runSpacing: 10,
            children: [
              Text(
                result.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Column(
                children: result.members
                    .map((member) => MemberValues(memberValues: member))
                    .toList(),
              ),
            ],
          )),
    );
  }
}

class MemberValues extends StatelessWidget {
  final MemberResult memberValues;

  const MemberValues({super.key, required this.memberValues});

  @override
  Widget build(BuildContext context) {
    final List<double> values = memberValues.values
        .map((value) => double.parse(value['value'].toString()))
        .toList();

    final _min = values.reduce(min);
    final _max = values.reduce(max);
    final avarage = values.reduce((a, b) => a + b) / values.length;

    Widget value(String name, double value) {
      return Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.button,
          ),
          Text(value.toStringAsFixed(2)),
        ],
      );
    }

    return Row(
      children: [
        Text(
          memberValues.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              value('Min', _min),
              value('Average', avarage),
              value('Max', _max),
            ],
          ),
        )
      ],
    );
  }
}
