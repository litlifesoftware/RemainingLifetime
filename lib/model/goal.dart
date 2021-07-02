import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'goal.g.dart';

/// A model class to store information required to
/// identify and describe the user's goals.
@HiveType(typeId: 1)
class Goal {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final int? month;
  @HiveField(3)
  final int? year;

  const Goal({
    required this.id,
    required this.title,
    required this.month,
    required this.year,
  });
}
