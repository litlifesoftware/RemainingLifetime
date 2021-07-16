import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/config/config.dart';
import 'package:remaining_lifetime/controller/hive_db_service.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/model/user_data.dart';
import 'package:remaining_lifetime/view/screens/home_screen.dart';
import 'package:remaining_lifetime/view/screens/loading_screen.dart';
import 'package:remaining_lifetime/view/screens/privacy_screen.dart';
import 'package:remaining_lifetime/view/screens/confirm_age_screen.dart';

/// A widget to retrieve data objects from local storage (Hive database) and to
/// provide these to the corresponding screen [Widget]s.
class DatabaseStateScreenBuilder extends StatefulWidget {
  @override
  _DatabaseStateScreenBuilderState createState() =>
      _DatabaseStateScreenBuilderState();
}

class _DatabaseStateScreenBuilderState extends State<DatabaseStateScreenBuilder>
    with TickerProviderStateMixin {
  /// The controller to calculate the user's lifetime months.
  late LifetimeController? _lifetimeController;

  /// The startup screen's animation duration.
  final Duration _startupAnimationDuration = const Duration(
    milliseconds: 6000,
  );

  /// States whether to show the starup screen at launch. This should be set to
  /// `true` once the initial starup has been detected.
  bool _shouldShowStartupScreen = false;

  /// States whether it's the initial startup of the app. The value should be
  /// set to `true` once the initial starup has been detected.
  bool _initalStartup = false;

  /// Initializes the lifetime controller using the provided birth timestamp.
  void initLifetimeController(int? dateOfBirthTimestamp) {
    _lifetimeController =
        LifetimeController(dayOfBirthTimestamp: dateOfBirthTimestamp);
  }

  /// Initializes the [Box] content by creating the required entries.
  ///
  /// The [LifetimeController] will be used to add one entry for each
  /// expected lifetime month.
  void initializeGoalsBoxContent(goalsBox) {
    for (int i = 0; i < _lifetimeController!.lifeExpectancyInMonths; i++) {
      final Goal goal = Goal(
        // Increase the index by one to create the id.
        id: i,
        title: "",
        month: _lifetimeController!.convertTotalMonthToDateTime(i).month,
        year: _lifetimeController!.convertTotalMonthToDateTime(i).year,
      );
      goalsBox.add(goal);
    }
  }

  /// Creates the user data entry on the database.
  void createUserData(DateTime age, Box<dynamic> userDataBox) {
    UserData userData = UserData(
        dayOfBirth: age.millisecondsSinceEpoch,
        color: DefaultUserData.defaultColor.value);
    userDataBox.add(userData);
    initLifetimeController(userData.dayOfBirth);
  }

  /// Handles the actions required to be performed after the user has agreed to
  /// the privacy policy.
  void _onPrivacyAgreed(Box<dynamic> appSettingsBox, Box<dynamic> userDataBox) {
    AppSettings appSettings = AppSettings(
      agreedPrivacy: true,
      animated: true,
      darkMode: false,
    );
    appSettingsBox.add(appSettings);
    LitRouteController(context).pushCupertinoWidget(
      ConfirmAgeScreen(
        onSubmit: (age) {
          createUserData(age, userDataBox);
          LitRouteController(context).pop();
        },
      ),
    );
  }

  /// Toggles the [_shouldShowStartupScreen] state value.
  void _toggleShouldShowStartupScreen() {
    setState(() {
      _shouldShowStartupScreen = !_shouldShowStartupScreen;
    });
  }

  /// Shows the startup screen if required.
  void _showStartupScreen() {
    _toggleShouldShowStartupScreen();
    Future.delayed(
      _startupAnimationDuration,
    ).then((_) {
      if (_initalStartup & !AppConfig.DEBUG) {
        _toggleShouldShowStartupScreen();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _showStartupScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiveDBService().openBoxes(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasError) {
            return _ErrorText();
          } else {
            return ValueListenableBuilder(
              valueListenable: HiveDBService().getAppSettings(),
              builder: (BuildContext context, Box<dynamic> appSettingsBox,
                  Widget? child) {
                return ValueListenableBuilder(
                  valueListenable: HiveDBService().getUserData(),
                  builder: (BuildContext context, Box<dynamic> userDataBox,
                      Widget? _) {
                    if (userDataBox.isNotEmpty) {
                      UserData userData = userDataBox.getAt(0);
                      initLifetimeController(userData.dayOfBirth);

                      return ValueListenableBuilder(
                        valueListenable: HiveDBService().getGoals(),
                        builder: (BuildContext context, Box<dynamic> goalsBox,
                            Widget? child) {
                          if (goalsBox.isEmpty) {
                            initializeGoalsBoxContent(goalsBox);
                          }
                          return HomeScreen(
                            goalsBox: goalsBox,
                            appSettingsBox: appSettingsBox,
                            lifetimeController: _lifetimeController,
                          );
                        },
                      );
                    } else {
                      return Builder(
                        builder: (context) {
                          _initalStartup = true;
                          // Show the startup screen only on the first app start.
                          if (_shouldShowStartupScreen && !AppConfig.DEBUG) {
                            return LitStartupScreen(
                              animationDuration: _startupAnimationDuration,
                            );
                          } else {
                            return PrivacyScreen(
                              onConfirm: () => _onPrivacyAgreed(
                                appSettingsBox,
                                userDataBox,
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

/// A widget displaying a default error text (if fetching from local storage
/// has failed).
class _ErrorText extends StatelessWidget {
  const _ErrorText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Something unexpected happed. Please restart this app.",
      ),
    );
  }
}
