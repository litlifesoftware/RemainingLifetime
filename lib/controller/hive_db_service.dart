import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/model/user_data.dart';
import 'package:remaining_lifetime/model/goal.dart';

/// A controller class used as interface to the [Hive] database.
///
/// It will provide methods to initialize the database and to retrieve data
/// by accessing the individual [Box]es.
///
/// The database content will be retured as [ValueListenable] objects. The
/// corresponding [ValueListenableBuilder] is able to extract the actual
/// model objects.
class HiveDBService {
  /// Initializes the [Hive] database instance.
  Future<void> initDB() async {
    // final appDocumentDirectory = await getApplicationDocumentsDirectory();
    // Hive.init(appDocumentDirectory.path);
    await Hive.initFlutter();

    /// Type id will be defined in the HiveType objects.

    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(GoalAdapter());
  }

  static const String _appSettingsBoxName = 'app_settings';
  static const String _userDataBoxName = 'user_data';
  static const String _goalsBoxName = 'goals';

  /// Either opens the [Box] containing the [AppSettings] data or returns
  /// the previously opened [Box].
  Future<Box<dynamic>> openAppSettingsBox() {
    if (!Hive.isBoxOpen(_appSettingsBoxName)) {
      return Hive.openBox(_appSettingsBoxName);
    } else {
      return Future(() {
        return Hive.box(_appSettingsBoxName);
      });
    }
  }

  /// Either opens the [Box] containing the [UserData] data or returns
  /// the previously opened [Box].
  Future<Box<dynamic>> openUserDataBox() {
    if (!Hive.isBoxOpen(_userDataBoxName)) {
      return Hive.openBox(_userDataBoxName);
    } else {
      return Future(() {
        return Hive.box(_userDataBoxName);
      });
    }
  }

  /// Either opens the [Box] containing the [Goal] data or returns
  /// the previously opened [Box].
  Future<Box<dynamic>> openGoalsBox() {
    if (!Hive.isBoxOpen(_goalsBoxName)) {
      return Hive.openBox(_goalsBoxName);
    } else {
      return Future(() {
        return Hive.box(_goalsBoxName);
      });
    }
  }

  /// Opens all [Box] objects available by executing the previously declared methods.
  /// This approach will enable to only await a single result instead of opening
  /// each [Box] individually. This way only one [FutureBuilder] is required.
  ///
  /// Providing the data can then be done using [ValueListenable] objects.
  Future<int> openBoxes() async {
    try {
      await openAppSettingsBox();
      await openUserDataBox();
      await openGoalsBox();
      return 0;
    } catch (e) {
      print("Error while opening the boxes");
      print(e);
      return 1;
    }
  }

  /// Returns a [ValueListenable] listening to changes made to the
  /// [Hive] box, which will store the [AppSettings] objects.
  ValueListenable<Box<dynamic>> getAppSettings() {
    return Hive.box(_appSettingsBoxName).listenable();
  }

  /// Returns a [ValueListenable] listening to changes made to the
  /// [Hive] box, which will store the [UserData]
  ValueListenable<Box<dynamic>> getUserData() {
    return Hive.box(_userDataBoxName).listenable();
  }

  /// Returns a [ValueListenable] listening to changes made to the
  /// [Hive] box, which will store the [Goal] objects.
  ValueListenable<Box<dynamic>> getGoals() {
    return Hive.box(_goalsBoxName).listenable();
  }
}
