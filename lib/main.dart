import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/hive_db_service.dart';
import 'package:remaining_lifetime/remaining_lifetime_app.dart';

void main() async {
  // Bind the framework and the Flutter engine together to set the system UI style.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Hive database.
  await HiveDBService().initDB();
  // Set the system UI style.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: LitColors.mediumGrey.withOpacity(0.5),
    statusBarIconBrightness: Brightness.light,
  ));
  // Run the actual app.
  runApp(RemainingLifetimeApp());
}
