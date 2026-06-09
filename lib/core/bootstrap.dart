import 'package:flutter/widgets.dart';
import '../data/app_database.dart';

final db = AppDatabase();

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.userDao.ensureUser();
}
