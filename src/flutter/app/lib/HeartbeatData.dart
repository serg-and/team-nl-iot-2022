import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

List<FlSpot> heartBeatList = [];
int index = 0;

class HeartBeatPage extends StatelessWidget {

  const HeartBeatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Home"),
      body: ListView(
        //Add extra data widget here with a button title
        children: [DropDownBar("HeartBeat", HeartBeatData()), DropDownBar('HeartBeat2', HeartBeatData())],
      ),
    ); //
  }
}

class HeartBeatData extends StatelessWidget{
  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [HeartBeatDataText(), HeartBeatDataGraph()],
      ),
    );
  }
}

class DropDownBar extends StatefulWidget {
  final String title;
  final Widget dataWidget;
  const DropDownBar(this.title, this.dataWidget);
  _DropDownBarState createState() => _DropDownBarState();
}

class HeartBeatDataText extends StatefulWidget {
  _HeartBeatState createState() => _HeartBeatState();
}

class _DropDownBarState extends State<DropDownBar>{
  bool showData = true;
  Widget build(BuildContext context){
    Widget showWidget = widget.dataWidget;
    showWidget = showData? widget.dataWidget: Container();
    return Center(
      child: Column (
          children: <Widget> [Bar(context), showWidget]
      ),
    );
  }

  Widget Bar(BuildContext context){
    final ButtonStyle style =
    ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20, color: Colors.black),
        fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width * 0.1),
        backgroundColor: Colors.grey,
    );
    return Center(
      child: ElevatedButton(
        child: Text(widget.title, style: TextStyle(fontSize: 20.0),),
        style: style,
        onPressed: () {setState(() {
          showData = showData? false: true;
        });},
      ),
    );
  }
}


class _HeartBeatState extends State<HeartBeatDataText>{
  int heartBeat = 0;
  late Timer update;
  Random random = new Random();

  @override
  void initState(){
    super.initState();
    update = Timer.periodic(Duration(milliseconds: 100), (Timer t){
      setState(() {
        heartBeat = 40 + random.nextInt(150 - 40);
        heartBeatList.add(FlSpot(index.toDouble(), heartBeat.toDouble()));
        if(heartBeatList.length > 30) heartBeatList.removeAt(0);
        index++;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: new Text('HeartBeat = ' + heartBeat.toString()),
      ),
    );
  }
}
class HeartBeatDataGraph extends StatefulWidget {
  const HeartBeatDataGraph({super.key});

  @override
  State<HeartBeatDataGraph> createState() => _HeartBeatDataGraphState();
}

class _HeartBeatDataGraphState extends State<HeartBeatDataGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  late Timer update;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    update = Timer.periodic(Duration(milliseconds: 200), (Timer t){
      setState(() {

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              color: Color(0xff232d37),
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
      child: Text('\ ${value}', style: style,),
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
      maxY: 200    ,
      lineBarsData: [
        LineChartBarData(
          spots: heartBeatList,
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

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: false,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}