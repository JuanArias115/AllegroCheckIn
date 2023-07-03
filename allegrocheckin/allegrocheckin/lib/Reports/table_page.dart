import 'package:allegrocheckin/models/SalesData.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatefulWidget {
  final int selectedMonth;
  final ValueChanged<int> onMonthChanged;
  final Future<List<SalesData>> Function(int) fetchSalesData;

  const TableWidget({
    required this.selectedMonth,
    required this.onMonthChanged,
    required this.fetchSalesData,
  });

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
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
        Expanded(child: _buildTable()),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Value')),
        ],
        rows: _salesData.map((data) {
          return DataRow(cells: [
            DataCell(Text(data.categoria)),
            DataCell(Text(data.valor.toString())),
          ]);
        }).toList(),
      ),
    );
  }
}
