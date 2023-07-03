import 'package:allegrocheckin/Configuration/configuration_main_page.dart';
import 'package:allegrocheckin/Reports/chart_page.dart';
import 'package:allegrocheckin/Reports/main_report_page.dart';
import 'package:allegrocheckin/Reservas/main_reservas.dart';
import 'package:allegrocheckin/catalog_products/catalog_products.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  Color colorTheme = Colors.blue;
  final List<Widget> _pages = [
    ReservationList(),
    ProductListPage(),
    SalesReportPage(),
    ConfiguracionesPage()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponents(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        fixedColor: colorTheme,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bed,
            ),
            label: 'Reservas ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
