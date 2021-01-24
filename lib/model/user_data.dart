import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'user_data.g.dart';

/// A model class to store user information.
@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final int dayOfBirth;

  UserData({
    @required this.dayOfBirth,
  });
}
