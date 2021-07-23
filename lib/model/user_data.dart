import 'package:hive/hive.dart';

part 'user_data.g.dart';

/// A model class to store user information.
@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final int? dayOfBirth;
  @HiveField(1)
  final int? color;
  UserData({
    required this.dayOfBirth,
    required this.color,
  });
}
