import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/hive_db_service.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/data/default_user_data.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/model/user_data.dart';
import 'package:remaining_lifetime/view/screens/home_screen.dart';
import 'package:remaining_lifetime/view/screens/loading_screen.dart';
import 'package:remaining_lifetime/view/screens/initial_start_screen.dart';

/// A [StatefulWidget] to retrieve data from the [Hive] database and to
/// provided it to the corresponding screen [Widget]s.
class DatabaseInterfaceWidget extends StatefulWidget {
  @override
  _DatabaseInterfaceWidgetState createState() =>
      _DatabaseInterfaceWidgetState();
}

class _DatabaseInterfaceWidgetState extends State<DatabaseInterfaceWidget>
    with TickerProviderStateMixin {
  LifetimeController? _lifetimeController;

  void setLifetimeController(int? dateOfBirthTimestamp) {
    print("lifetime controller set");
    _lifetimeController =
        LifetimeController(dayOfBirthTimestamp: dateOfBirthTimestamp);
  }

  /// Initializes the [Box] content by creating the required entries.
  ///
  /// The [LifetimeController] will be used to add one entry for each
  /// expected lifetime month.
  void initializeGoalsBoxContent(goalsBox) {
    for (int i = 0; i < _lifetimeController!.lifeExpectancyInMonths; i++) {
      // print(
      //     "goal date ${widget.lifetimeController.convertTotalMonthToDateTime(i)}");
      goalsBox.add(
        Goal(
            // Increase the index by one to create the id.
            id: i,
            title: "",
            month: _lifetimeController!.convertTotalMonthToDateTime(i).month,
            year: _lifetimeController!.convertTotalMonthToDateTime(i).year),
      );
    }
  }

  void createUserData(DateTime age, Box<dynamic> userDataBox) {
    UserData userData = UserData(
      dayOfBirth: age.millisecondsSinceEpoch,
      color: DefaultUserData.defaultColor.value,
    );
    userDataBox.add(userData);
    setLifetimeController(userData.dayOfBirth);
  }

  @override
  Widget build(BuildContext context) {
    const Text errorText =
        Text("Something unexpected happed. Please restart this app.");
    return FutureBuilder(
      future: HiveDBService().openBoxes(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasError) {
            return errorText;
          } else {
            return ValueListenableBuilder(
                valueListenable: HiveDBService().getAppSettings(),
                builder: (BuildContext context, Box<dynamic> appSettingsBox,
                    Widget? child) {
                  return appSettingsBox.isNotEmpty
                      ? ValueListenableBuilder(
                          valueListenable: HiveDBService().getUserData(),
                          builder: (BuildContext context,
                              Box<dynamic> userDataBox, Widget? child) {
                            if (userDataBox.isNotEmpty) {
                              UserData userData = userDataBox.getAt(0);
                              setLifetimeController(userData.dayOfBirth);
                            }
                            return userDataBox.isNotEmpty
                                ? ValueListenableBuilder(
                                    valueListenable: HiveDBService().getGoals(),
                                    builder: (BuildContext context,
                                        Box<dynamic> goalsBox, Widget? child) {
                                      if (goalsBox.length == 0) {
                                        initializeGoalsBoxContent(goalsBox);
                                      }
                                      return HomeScreen(
                                          goalsBox: goalsBox,
                                          appSettingsBox: appSettingsBox,
                                          lifetimeController:
                                              _lifetimeController);
                                    })
                                :
                                // AgeConfirmationScreen(
                                //     titleLabel:
                                //         RemainingLifetimeLocalizations.of(
                                //                 context)
                                //             .setYourDayOfBirth,
                                //     submitButtonLabel:
                                //         RemainingLifetimeLocalizations.of(
                                //                 context)
                                //             .continueWithThisDayOfBirth,
                                //     notOldEnoughLabel:
                                //         RemainingLifetimeLocalizations.of(
                                //                 context)
                                //             .youAreNotOldEnoughToUseThisApp,
                                //     changeTheMonthLabel:
                                //         RemainingLifetimeLocalizations.of(
                                //                 context)
                                //             .changeTheMonthToApplyThisDate,
                                //     monthLabel:
                                //         RemainingLifetimeLocalizations.of(
                                //                 context)
                                //             .month,
                                //     yearLabel:
                                //         RemainingLifetimeLocalizations.of(
                                //                 context)
                                //             .year,
                                //     onSubmitCallback: (DateTime age) {
                                //       createUserData(age, userDataBox);
                                //     },
                                //   );
                                //TODO: Implement confirm age screen
                                Scaffold(
                                    body: Center(
                                      child: ElevatedButton(
                                        child: Text("Set day of birth"),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return LitDatePickerDialog(
                                                    onBackCallback:
                                                        Navigator.of(context)
                                                            .pop,
                                                    onSubmit: (age) {
                                                      createUserData(
                                                          age, userDataBox);
                                                    });
                                              });
                                        },
                                      ),
                                    ),
                                  );
                          },
                        )
                      : InitialStartInformation(
                          appSettingsBox: appSettingsBox,
                        );
                });
          }
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
