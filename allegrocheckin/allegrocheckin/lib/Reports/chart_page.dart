import 'package:allegrocheckin/models/SalesData.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartWidget extends StatefulWidget {
  final int selectedMonth;
  final ValueChanged<int> onMonthChanged;
  final Future<List<SalesData>> Function(int) fetchSalesData;

  const ChartWidget({
    required this.selectedMonth,
    required this.onMonthChanged,
    required this.fetchSalesData,
  });

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<SalesData> _salesData = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    final salesData = await widget.fetchSalesData(widget.selectedMonth);
    setState(() {
      _salesData = salesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Expanded(child: _buildChart()),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChart() {
    List<charts.Series<SalesData, String>> series = [
      charts.Series(
        id: 'Sales',
        data: _salesData,
        domainFn: (SalesData sales, _) => sales.categoria,
        measureFn: (SalesData sales, _) => double.parse(sales.valor),
        labelAccessorFn: (SalesData sales, _) =>
            '${sales.categoria}: \$${sales.valor}',
      ),
    ];

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }
}
