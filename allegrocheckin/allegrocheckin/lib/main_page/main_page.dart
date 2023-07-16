import 'package:allegrocheckin/Configuration/configuration_main_page.dart';
import 'package:allegrocheckin/Reports/chart_page.dart';
import 'package:allegrocheckin/Reports/main_report_page.dart';
import 'package:allegrocheckin/Reservas/main_reservas.dart';
import 'package:allegrocheckin/catalog_products/catalog_products.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:allegrocheckin/user_page/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  int _currentIndex = 0;
  Color colorTheme = Colors.blue;
  final List<Widget> _pages = [];
  User? user;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponents(),
      body: [
        ReservationList(),
        ProductListPage(),
        SalesReportPage(),
        UserPage(
          user: user!,
          onLogout: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                "login", (Route<dynamic> route) => false);
          },
        ),
        ConfiguracionesPage(),
      ][_currentIndex],
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
            icon: Icon(Icons.people),
            label: 'Perfil',
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
