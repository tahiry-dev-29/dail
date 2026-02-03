import 'package:daily_os/app.dart';
import 'package:daily_os/core/storage/isar_database.dart';
import 'package:daily_os/features/planner/logic/planner_signals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr_FR', null);

  // Initialize Global Database
  await IsarDatabase.instance.init();

  // Initialize Global Features
  await initPlanner();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: DailyOsApp()));
}

// DailyOsApp moved to app.dart
