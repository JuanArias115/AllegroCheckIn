import 'package:flutter/material.dart';

class AppBarComponents extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponents({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Allegro Check-In'),
      actions: [],
    );
  }
}
