import 'package:remaining_lifetime/model/user_data.dart';

/// A controller to implement analyses and features based on [UserData].
class UserDataController {
  /// The data on which the analyses are performed.
  final UserData userData;

  /// Creates a [UserDataController].
  const UserDataController(this.userData);

  /// Returns the user's age.
  int get age {
    DateTime now = DateTime.now();
    DateTime birth = DateTime.fromMillisecondsSinceEpoch(userData.dayOfBirth!);
    int ageTimestamp =
        now.millisecondsSinceEpoch - birth.millisecondsSinceEpoch;
    int ageYears = Duration(milliseconds: ageTimestamp).inDays ~/ 365;

    return ageYears;
  }
}
