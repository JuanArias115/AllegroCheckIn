import 'package:allegrocheckin/Configuration/categorias_config_page.dart';
import 'package:flutter/material.dart';

class ConfiguracionesPage extends StatelessWidget {
  final List<String> configuraciones = [
    'Configuración De Categorias',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: configuraciones.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: ListTile(
              title: Text(configuraciones[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriasCrudPage(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
