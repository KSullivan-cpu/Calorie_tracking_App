import 'package:flutter/widgets.dart';

import '../data/app_database.dart';
import '../data/produce/produce_reference.dart';

final db = AppDatabase();

/// Loaded once at startup; available app-wide (entry sizing, later slices).
late final ProduceReference produce;

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.userDao.ensureUser();
  produce = await ProduceReference.load();
}
