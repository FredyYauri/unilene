import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage2 extends StatelessWidget {
  HomePage2({Key? key}) : super(key: key);

  final dataMap = <String, double>{"Flutter": 5, "C#": 18, "SAP": 12};

  final colorList = <Color>[
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent,
    Colors.blueAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pie Chart 1"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          colorList: colorList,
          chartValuesOptions: ChartValuesOptions(
            showChartValuesInPercentage: false,
          ),
          totalValue: 35,
        ),
      ),
    );
  }
}
