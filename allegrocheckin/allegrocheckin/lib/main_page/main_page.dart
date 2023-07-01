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

  final List<Widget> _pages = [
    ReservationList(),
    ProductListPage(),
    Widget3(),
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
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bed),
            label: 'Reservas ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Widget 3',
          ),
        ],
      ),
    );
  }
}

class Widget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Proximamenta'),
    );
  }
}

class Widget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Proximamenta'),
    );
  }
}
