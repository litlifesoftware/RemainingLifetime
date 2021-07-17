import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_starfield/view/lit_starfield_container.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/hive_db_service.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/goal_preview_card.dart';
import 'package:remaining_lifetime/view/widgets/lifetime_grid.dart';

/// A screen widget displaying the lifetime grid view and provides elements to
/// interact with the underlying database-layer.
///
/// A bottom card will either display the user created data or will be used to
/// allow user input.
class LifetimeScreen extends StatefulWidget {
  /// Creates a [LifetimeScreen].
  const LifetimeScreen({
    Key? key,
    required this.lifetimeController,
    required this.toggleHideNavigationBar,
  }) : super(key: key);
  final LifetimeController? lifetimeController;
  final void Function() toggleHideNavigationBar;

  @override
  _LifetimeScreenState createState() => _LifetimeScreenState();
}

class _LifetimeScreenState extends State<LifetimeScreen>
    with TickerProviderStateMixin {
  /// Captures the user input on the bottom card.
  late FocusNode _editingFocus;

  /// Animates the initial screen build-up.
  late AnimationController _appearAnimation;

  /// Controlls the [LitSnackbar] instance.
  late LitSnackbarController _snackBarController;

  /// Controlls the [GoalPreviewCard] instance.
  late CollapsibleCardController _collapsibleCardCon;

  /// Controlls the text input on the [GoalPreviewCard].
  late TextEditingController _goalEditingController;

  /// The currently selected [Goal] object on the [LifetimeGrid].
  Goal? _selectedGoal;

  /// Sets the [_selectedGoal] value using the provided [Goal].
  ///
  /// While the goal is selected, the [GoalPreviewCard] will be expanded.
  void setPressedGoal(Goal? value) {
    _collapsibleCardCon.expandCard(
      () {
        setState(
          () {
            _selectedGoal = value;
            _goalEditingController =
                TextEditingController(text: "${_selectedGoal!.title}");
          },
        );
      },
    );

    widget.toggleHideNavigationBar();
  }

  /// Resets the [_selectedGoal] and removes the keyboard.
  void resetPressedGoal() {
    FocusScope.of(context).unfocus();
    setState(
      () {
        _selectedGoal = null;
      },
    );

    widget.toggleHideNavigationBar();
  }

  /// Saves the [Goal] to the database using the [TextEditingController] state.
  ///
  /// The [GoalPreviewCard] will be collapsed.
  void handleGoalSave(Box<dynamic> goalsBox) {
    goalsBox.putAt(
      _selectedGoal!.id!,
      Goal(
          id: _selectedGoal!.id,
          title: _goalEditingController.text,
          month: _selectedGoal!.month,
          year: _selectedGoal!.year),
    );
    resetPressedGoal();
    _snackBarController.showSnackBar();
  }

  /// Sets or resets the [_selectedGoal] object depending on its current value.
  void handleTilePress(int index, Box<dynamic> goalsBox) {
    _selectedGoal == null
        ? setPressedGoal(goalsBox.getAt(index))
        : _collapsibleCardCon.collapseCard(
            () {
              resetPressedGoal();
            },
          );
  }

  @override
  void initState() {
    super.initState();
    _editingFocus = FocusNode();
    _snackBarController = LitSnackbarController();
    _collapsibleCardCon = CollapsibleCardController();
    _goalEditingController = TextEditingController(text: "");

    _appearAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _appearAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getAppSettings(),
      builder: (BuildContext context, Box<dynamic> settingsBox, _) {
        /// Initialize with null if null, if no user data is found.
        /// The object should be declared in the build method to
        /// ensure the latest database entry is returned everytime.
        AppSettings appSettings = settingsBox.getAt(0);
        return ValueListenableBuilder(
          valueListenable: HiveDBService().getGoals(),
          builder: (BuildContext context, Box<dynamic> goalsBox, __) {
            return LitScaffold(
              collapsibleCard: GoalPreviewCard(
                lifetimeController: widget.lifetimeController,
                onSave: () => handleGoalSave(goalsBox),
                collapsibleCardController: _collapsibleCardCon,
                goal: _selectedGoal,
                onClose: resetPressedGoal,
                focusNode: _editingFocus,
                textEditingController: _goalEditingController,
                darkMode: appSettings.darkMode,
              ),
              snackbars: [
                LitIconSnackbar(
                  snackBarController: _snackBarController,
                  text: RemainingLifetimeLocalizations.of(context)!
                      .achievementSaved!,
                  iconData: LitIcons.check,
                )
              ],
              body: AnimatedBuilder(
                animation: _appearAnimation,
                builder: (context, child) {
                  _appearAnimation.forward();
                  return AnimatedOpacity(
                    duration: _appearAnimation.duration!,
                    opacity: _appearAnimation.value < 0.5
                        ? _appearAnimation.value + 0.5
                        : _appearAnimation.value,
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            LitStarfieldContainer(
                              animated: appSettings.animated!,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.white38,
                                    Color(0x1edc9f9f),
                                  ],
                                ),
                              ),
                            ),
                            LifetimeGrid(
                              handleTilePress: (index) => handleTilePress(
                                index,
                                goalsBox,
                              ),
                              focusNode: _editingFocus,
                              snackBarController: _snackBarController,
                              goalsBox: goalsBox,
                              lifetimeController: widget.lifetimeController,
                              darkMode: appSettings.darkMode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
