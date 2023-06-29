import 'package:allegrocheckin/Reservas/main_reservas.dart';
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
    Widget2(),
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
            icon: Icon(Icons.home),
            label: 'Widget 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Widget 2',
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

class Widget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Widget 1'),
    );
  }
}

class Widget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Widget 2'),
    );
  }
}

class Widget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Widget 3'),
    );
  }
}
