import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'models.dart';

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

// class HeartBeatDataGraph extends StatefulWidget {
class DataLineGraph extends StatelessWidget {
  final List<OutputValue> values;
  const DataLineGraph({super.key, required this.values});

//   @override
//   State<HeartBeatDataGraph> createState() => _HeartBeatDataGraphState();
// }

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
