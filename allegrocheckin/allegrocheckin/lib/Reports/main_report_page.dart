import 'dart:io';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/SalesData.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class SalesReportPage extends StatefulWidget {
  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List<SalesData> _salesData = [];
  int _selectedMonth = DateTime.now().month;
  final oCcy = NumberFormat("#,##0", "en_US");
  List<String> months = [];

  Future<List<SalesData>> _fetchSalesData() async {
    return _getSalesDataForMonth(_selectedMonth);
  }

  Future<List<SalesData>> _getSalesDataForMonth(int month) async {
    CommandResult res = await ReserveService().getReport(month);
    var data = SalesData.parseMyDataList(res.data);
    return data;
  }

  // Future<void> _exportToPdf() async {
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _exportToPdf();
        //   },
        // ),
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: _selectedMonth,
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Enero'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('Febrero'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('Marzo'),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text('Abril'),
                    ),
                    DropdownMenuItem(
                      value: 5,
                      child: Text('Mayo'),
                    ),
                    DropdownMenuItem(
                      value: 6,
                      child: Text('Junio'),
                    ),
                    DropdownMenuItem(
                      value: 7,
                      child: Text('Julio'),
                    ),
                    DropdownMenuItem(
                      value: 8,
                      child: Text('Agosto'),
                    ),
                    DropdownMenuItem(
                      value: 9,
                      child: Text('Septiembre'),
                    ),
                    DropdownMenuItem(
                      value: 10,
                      child: Text('Octubre'),
                    ),
                    DropdownMenuItem(
                      value: 11,
                      child: Text('Noviembre'),
                    ),
                    DropdownMenuItem(
                      value: 12,
                      child: Text('Diciembre'),
                    ),
                    // Agrega los demás meses aquí
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                    });
                  },
                ),
              ],
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Reporte'),
                Tab(text: 'Grafico'),
              ],
            )),
        body: TabBarView(
          children: [
            FutureBuilder<List<SalesData>>(
              future: _fetchSalesData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Expanded(child: _buildTable(snapshot.data!)),
                      SizedBox(height: 20),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: Text('No hay datos disponibles'));
                }
              },
            ),
            FutureBuilder<List<SalesData>>(
              future: _fetchSalesData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Expanded(child: _buildChart(snapshot.data!)),
                      SizedBox(height: 20),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: Text('No hay datos disponibles'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<SalesData> salesData) {
    List<charts.Series<SalesData, String>> series = [
      charts.Series(
        id: 'Sales',
        data: salesData,
        domainFn: (SalesData sales, _) => sales.categoria,
        measureFn: (SalesData sales, _) => double.parse(sales.valor),
        labelAccessorFn: (SalesData sales, _) =>
            '${sales.categoria}: \$${oCcy.format(sales.valor)}',
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

  Widget _buildTable(List<SalesData> salesData) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text('Categorias')),
          DataColumn(label: Text('Valores')),
        ],
        rows: salesData.map((data) {
          return DataRow(cells: [
            DataCell(Text(data.categoria)),
            DataCell(Text(oCcy.format(double.parse(data.valor.toString())))),
          ]);
        }).toList(),
      ),
    );
  }
}
