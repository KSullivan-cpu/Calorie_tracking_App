import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/app_database.dart';
import '../data/produce/produce_reference.dart';

final db = AppDatabase();

/// Loaded once at startup; available app-wide (entry sizing, later slices).
late final ProduceReference produce;

// Run-time keys from env.json via `flutter run --dart-define-from-file=env.json`.
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseKey = String.fromEnvironment('SUPABASE_KEY');
const _fdcKey = String.fromEnvironment('FDC_API_KEY');

/// True once Supabase initialized this run. False => on-device only (the app
/// stays fully usable; cloud backup just doesn't run). Slice 2 FSD §5.1:
/// cloud is never required at launch.
bool cloudConfigured = false;

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.userDao.ensureUser();
  produce = await ProduceReference.load();
  _checkFdcKey();
  await _initSupabase();
}

/// Slice 1 lesson: a missing FDC key fails silently (every lookup returns
/// empty). Say so loudly at startup instead.
void _checkFdcKey() {
  if (_fdcKey.isEmpty || _fdcKey == 'PASTE_YOURS_HERE') {
    debugPrint('WARNING FDC_API_KEY missing — online food lookup disabled. '
        'Set it in env.json and run with --dart-define-from-file=env.json.');
  }
}

/// Initializes the Supabase client. Needs no network; never blocks or fails
/// the launch — any problem degrades to on-device only for this run.
Future<void> _initSupabase() async {
  if (_supabaseUrl.isEmpty || _supabaseKey.isEmpty) {
    debugPrint('WARNING Supabase not configured (SUPABASE_URL / SUPABASE_KEY '
        'missing) — cloud backup disabled this run. '
        'Run with --dart-define-from-file=env.json.');
    return;
  }
  try {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseKey);
    cloudConfigured = true;
    debugPrint('Supabase configured ($_supabaseUrl)');
  } catch (e) {
    debugPrint('WARNING Supabase init failed — cloud backup disabled this '
        'run: $e');
  }
}
