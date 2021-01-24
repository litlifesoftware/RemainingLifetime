import 'package:flutter/foundation.dart';

/// A controller class to handle the calculation of the user's lifetime and other
/// operations using the provided [dayOfBirthTimestamp].
class LifetimeController {
  /// The user's day of birth provided as an unix timestamp.
  final int dayOfBirthTimestamp;

  /// The user's day of birth returned as [DateTime]
  /// used to calculate various statistical values.
  DateTime get dayOfBirthDateTime {
    return DateTime.fromMillisecondsSinceEpoch(dayOfBirthTimestamp);
  }

  /// Creates a new [LifetimeController].
  ///
  /// Providing the [dayOfBirthTimestamp] will be required for various operations.

  LifetimeController({@required this.dayOfBirthTimestamp});

  /// The current [DateTime] provided by the system.
  DateTime now = DateTime.now();

  /// The world average life expectancy defined by
  /// 'The World Factbook'.
  static const int averageLifeExpectancy = 71;

  /// The constant values defined for time.

  static const int hoursPerDay = 24;
  static const int minutesPerHour = 60;
  static const int secondsPerMinute = 60;
  static const int millisecondsPerSecond = 1000;

  /// One calender common month has 365 days on default. To adjust this
  /// v
  static const double daysPerYear = (365 + 1 / 4 - 1 / 100 + 1 / 400);

  /// The months per year.
  static const int monthsPerYear = 12;

  /// The days per month are represented as a ratio to due to
  /// the uneven amount of days distributed among all months.
  double get daysPerMonth {
    return daysPerYear / monthsPerYear;
  }

  /// The milliseconds per day calculated by multiplying
  /// the constants defined for time.
  int get millisecondsPerDay {
    return hoursPerDay *
        minutesPerHour *
        secondsPerMinute *
        millisecondsPerSecond;
  }

  /// The milliseconds per month.
  double get millisecondsPerMonth {
    return millisecondsPerDay * daysPerMonth;
  }

  /// The milliseconds per year.
  double get millisecondsPerYear {
    return millisecondsPerMonth * monthsPerYear;
  }

  /// The milliseconds per month.
  int get lifeExpectancyInMonths {
    return averageLifeExpectancy * monthsPerYear;
  }

  /// The expected obit of the user calculated using the user provided
  /// [dayOfBirthDateTime].
  DateTime get expectedObit {
    return dayOfBirthDateTime.add(Duration(
        milliseconds: (millisecondsPerYear * averageLifeExpectancy).round()));
  }

  /// The total months passed of the user's lifetime calculated using the user provided
  /// [dayOfBirthDateTime]. To ensure only completed months are counting, floor the result.
  int get pastLifeTimeInMonths {
    print((now.millisecondsSinceEpoch -
            dayOfBirthDateTime.millisecondsSinceEpoch) /
        millisecondsPerMonth);
    return ((now.millisecondsSinceEpoch -
                dayOfBirthDateTime.millisecondsSinceEpoch) /
            millisecondsPerMonth)
        .floor();
  }

  /// The remaining months of the user's lifetime calculated using the user provided
  /// [dayOfBirthDateTime].
  int get remainingLifeTimeInMonths {
    return ((expectedObit.millisecondsSinceEpoch -
            now.millisecondsSinceEpoch) ~/
        millisecondsPerMonth);
  }

  /// Translates the given [totalMonth] count of the user's expected lifetime to a
  /// [DateTime] object.
  DateTime convertTotalMonthToDateTime(int totalMonth) {
    return DateTime.fromMillisecondsSinceEpoch(
            dayOfBirthDateTime.millisecondsSinceEpoch)
        .add(
      Duration(
        milliseconds: totalMonth * millisecondsPerMonth.toInt(),
      ),
    );
  }
}
