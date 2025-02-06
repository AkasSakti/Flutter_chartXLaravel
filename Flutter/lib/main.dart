import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReportChart(),
    );
  }
}

class ReportChart extends StatefulWidget {
  @override
  _ReportChartState createState() => _ReportChartState();
}

class _ReportChartState extends State<ReportChart> {
  List<PieChartSectionData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/report?filter=bulan'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _chartData = data.map((item) {
          return PieChartSectionData(
            title: item['nama_ruang'],
            value: item['total'].toDouble(),
            color: Colors.blue, // Anda bisa menyesuaikan warna
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load report data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Chart'),
      ),
      body: Center(
        child: _chartData.isEmpty
            ? CircularProgressIndicator()
            : PieChart(
                PieChartData(
                  sections: _chartData,
                ),
              ),
      ),
    );
  }
}
