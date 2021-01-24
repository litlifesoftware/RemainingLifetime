import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

/// A model class required to store information specific to the app current
/// configuration such as the dark mode.
@HiveType(typeId: 2)
class AppSettings {
  @HiveField(0)
  final bool agreedPrivacy;
  @HiveField(1)
  final bool darkMode;
  @HiveField(2)
  final bool animated;

  const AppSettings({
    @required this.agreedPrivacy,
    @required this.darkMode,
    @required this.animated,
  });
}
