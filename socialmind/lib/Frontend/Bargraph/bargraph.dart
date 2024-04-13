import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Bargraph/bardata.dart';

class Bargraph extends StatelessWidget {
  final List
      AverageAppUseTime; //array or list, backend bata yo change garnu parxa
  const Bargraph({super.key, required this.AverageAppUseTime});
  @override
  Widget build(BuildContext context) {
    BarData Bargraph = BarData(
      sunAmount: AverageAppUseTime[0],
      monAmount: AverageAppUseTime[1],
      tusAmount: AverageAppUseTime[2],
      wedAmount: AverageAppUseTime[3],
      thursAmount: AverageAppUseTime[4],
      friAmount: AverageAppUseTime[5],
      satAmount: AverageAppUseTime[6],
    );
    Bargraph.initializeBarData();
    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, getTitlesWidget: getbottomtitle),
          ),
        ),
        barGroups: Bargraph.barData
            .map((data) => BarChartGroupData(x: data.x.toInt(), barRods: [
                  BarChartRodData(
                      toY: data.y,
                      color: Colors.grey[800],
                      width: 20,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 100,
                        color: Colors.grey[200],
                      ))
                ]))
            .toList(),
      ),
    );
  }
}

Widget getbottomtitle(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;

  if (value == 0) {
    // yo xai array ko 0 lai sunday testo gardai gako
    text = const Text(
      'S',
      style: TextStyle(color: Colors.red),
    );
  } else if (value == 1) {
    //1 lai monday ...
    text = const Text('M');
  } else if (value == 2) {
    text = const Text('T');
  } else if (value == 3) {
    text = const Text('W');
  } else if (value == 4) {
    text = const Text('Th');
  } else if (value == 5) {
    text = const Text('F');
  } else if (value == 6) {
    text = const Text(
      'St',
      style: TextStyle(color: Colors.red),
    );
  } else {
    text = const SizedBox();
  }

  return SideTitleWidget(
      child: text, axisSide: meta.axisSide); //returning the widget
}
