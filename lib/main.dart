import 'package:flutter/material.dart';
import 'core/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
  final user = await db.userDao.getUser();
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(child: Text('DB OK â€” user: ${user?.id ?? "none"}')),
    ),
  ));
}
