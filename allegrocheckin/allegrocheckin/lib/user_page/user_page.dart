import 'package:allegrocheckin/Configuration/categorias_config_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserPage extends StatelessWidget {
  final User user;
  final VoidCallback onLogout;

  UserPage({
    required this.user,
    required this.onLogout,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL!),
          ),
          title: Text(user.displayName ?? ''),
          subtitle: Text(user.email!),
        ),
        ElevatedButton(
          onPressed: onLogout,
          child: Text('Cerrar sesión'),
        ),
      ],
    ));
  }
}
