import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models.dart';

// This file makes the graphs for the data

// This is for displaying data as text
class DataText extends StatelessWidget {
  final String name;
  final OutputValue? lastValue;
  const DataText({required this.name, required this.lastValue});

  // _HeartBeatState createState() => _HeartBeatState();

  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: new Text('Last ${name} = ${lastValue?.value}'),
      ),
    );
  }
}

// Creates the line graph with one data type
class DataLineGraph extends StatelessWidget {
  final List<OutputValue> values;
  const DataLineGraph({super.key, required this.values});



// class _HeartBeatDataGraphState extends State<HeartBeatDataGraph> {
  static List<Color> gradientColors = [
    const Color(0xffff0000),
    const Color(0xffff1a1a),
    const Color(0xffff5a5a),
  ];

  static bool showAvg = false;
//   late Timer update;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     update = Timer.periodic(Duration(milliseconds: 200), (Timer t) {
//       setState(() {});
//     });
//   }

  List<FlSpot> getSpots() => values
      .map(
          (value) => FlSpot(value.timestamp.toDouble(), value.value.toDouble()))
      .toList();

  @override
  Widget build(BuildContext context) {
    // List<FlSpot> spots = this.values.map((value) => FlSpot(value.timestamp.toDouble(), value.value)).toList();

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              color: Color(0xffececec),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 0,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\ ${value}',
        style: style,
      ),
      space: 8.0,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\ ${value}', style: style),
    );
  }

  LineChartData mainData() {
    final spots = getSpots();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 10,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 100,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}

//Creates the bar chart with one data type
class BarChartBuilder extends StatelessWidget {
  final List<OutputValue> values;
  const BarChartBuilder({super.key, required this.values});

  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;



  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'state',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 50,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: barGroups,
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text('\ ${value}', style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: Text('/ ${value}', style: style),
    );
  }
  List<BarChartGroupData> get barGroups => values
      .map(
          (value) => BarChartGroupData(
            x: value.timestamp,
            barRods: [
              BarChartRodData(
                toY: value.value.toDouble(),
              )
            ],
            showingTooltipIndicators: [0],
          )
      ).toList();
}
