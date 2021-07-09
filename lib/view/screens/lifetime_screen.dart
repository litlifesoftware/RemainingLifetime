import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_starfield/view/lit_starfield_container.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/bottom_bar.dart';
import 'package:remaining_lifetime/view/widgets/goal_preview_card.dart';
import 'package:remaining_lifetime/view/widgets/lifetime_grid.dart';

class LifetimeScreen extends StatefulWidget {
  final Box<dynamic> appSettingsBox;
  final Box<dynamic> goalsBox;
  final LifetimeController? lifetimeController;
  final void Function() toggleHideNavigationBar;
  const LifetimeScreen({
    Key? key,
    required this.appSettingsBox,
    required this.goalsBox,
    required this.lifetimeController,
    required this.toggleHideNavigationBar,
  }) : super(key: key);

  @override
  _LifetimeScreenState createState() => _LifetimeScreenState();
}

class _LifetimeScreenState extends State<LifetimeScreen>
    with TickerProviderStateMixin {
  /// The [FocusNode] used on the [TextField] corresponding to the goals
  /// title input.
  FocusNode? _editingFocus;

  /// [AnimatinonController] used to animate the appear animatinon on start of the
  /// displayed [Widgets] on start of the app.
  late AnimationController _appearAnimation;

  /// [AnimationController] used to translate the [BottomBar] on start and whenever
  /// required to enable the user to input text.
  late AnimationController _bottomBarAnimation;
  late LitSnackbarController _customSnackBarController;
  late CollapsibleCardController _collapsibleCardController;

  /// [TextEditingController] to controller the user input required to create or
  /// edit a [Goal].
  TextEditingController? _goalTitleController;

  /// The currently selected [Goal] object on the [LifetimeGrid].
  Goal? _selectedGoal;
  // Future<bool> privacyOnPress() async {
  //   return await UrlLauncher.launch(
  //       "https://litlifesoftware.github.io/privacy");
  // }

  /// Sets the [_selectedGoal] value using the provided [Goal].
  /// After setting the value, the [TitledCollapsibleCard] will be
  /// transformed using the [_pressedAnimation] [AnimationController].
  void setPressedGoal(Goal? value) {
    _collapsibleCardController.expandCard(() {
      setState(() {
        _selectedGoal = value;
        _goalTitleController =
            TextEditingController(text: "${_selectedGoal!.title}");
      });
    });
    _bottomBarAnimation.reverse(from: 1.0);
    widget.toggleHideNavigationBar();
  }

  /// Resets the [_selectedGoal] value.
  /// Before resetting the [_selectedGoal], the child's [TextField] is unfocused
  /// and the animation will be played back in reverse. Only after doing so, the
  /// [_selectedGoal] value is set to null.
  void resetPressedGoal() {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedGoal = null;
    });
    _bottomBarAnimation.forward(from: 0.0);
    widget.toggleHideNavigationBar();
    // _pressedAnimation.reverse(from: 1.0).then((value) => setState(() {
    //       _selectedGoal = null;
    //     }));
  }

  /// Updates the corresponding [Goal] entry in the database using the currently
  /// selected [Goal] attributes and the [TextEditingController]'s text value.
  void handleGoalSave(Box<dynamic> goalsBox) {
    goalsBox.putAt(
        _selectedGoal!.id!,
        Goal(
            id: _selectedGoal!.id,
            title: _goalTitleController!.text,
            month: _selectedGoal!.month,
            year: _selectedGoal!.year));
    resetPressedGoal();
    _customSnackBarController.showSnackBar();
  }

  /// Sets or resets the [_selectedGoal] object depending on its current value.
  void handleTilePress(int index) {
    _selectedGoal == null
        ? setPressedGoal(widget.goalsBox.getAt(index))
        : _collapsibleCardController.collapseCard(() {
            resetPressedGoal();
          });
  }

  /// Shows the [AboutAppDialog] as a dialog.
  void showCustomAboutDialog(bool? darkMode) {
    //TODO implement about dialog
    print("about dialog");
    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   child: AboutAppDialog(
    //     websiteInfo: WebsiteInfo(
    //       websiteDescription: "Click here for more apps",
    //       websiteUrl: "https://litlifesoftware.github.io",
    //     ),
    //     title: "About",
    //     subtitle: "a product of LitLifeSoftware",
    //     infoLabel: "Design and development",
    //     infoDescription: "Michael Grigorenko",
    //     appName: "Remaining Lifetime",
    //     backgroundColor: darkMode ? LitColors.darkBlue : Colors.white,
    //     textStyle: LitTextStyles.sansSerif.copyWith(
    //       color: darkMode ? Colors.white : LitColors.mediumGrey,
    //     ),
    //     accentColor: darkMode ? LitColors.mediumGrey : Colors.white,
    //     launcherImageUrl:
    //         "assets/images/Remaining_Lifetime_App_Launcher_Icon_Rounded.png",
    //   ),
    // );
  }

  /// Dismisses the [BottomBar] by playing the [Animation] in reverse.
  void dismissBottomBar() {
    _bottomBarAnimation.reverse(from: 1.0);
  }

  /// Shows the [BottomBar] by playing the [Animation] forwards.
  void showBottomBar() {
    _bottomBarAnimation.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _editingFocus = FocusNode();
    _customSnackBarController = LitSnackbarController();
    _collapsibleCardController = CollapsibleCardController();
    _goalTitleController = TextEditingController(text: "");

    _appearAnimation = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 200,
        ));
    _bottomBarAnimation = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    _bottomBarAnimation.forward();
  }

  @override
  void dispose() {
    _appearAnimation.dispose();
    _bottomBarAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Initialize with null if null, if no user data is found.
    /// The object should be declared in the build method to
    /// ensure the latest database entry is returned everytime.
    AppSettings appSettings = widget.appSettingsBox.getAt(0);

    return LitScaffold(
      collapsibleCard: GoalPreviewCard(
        lifetimeController: widget.lifetimeController,
        saveGoalCallback: () => handleGoalSave(widget.goalsBox),
        collapsibleCardController: _collapsibleCardController,
        goal: _selectedGoal,
        onCloseCallback: resetPressedGoal,
        focusNode: _editingFocus,
        textEditingController: _goalTitleController,
        darkMode: appSettings.darkMode,
      ),
      snackbars: [
        LitIconSnackbar(
          snackBarController: _customSnackBarController,
          text: RemainingLifetimeLocalizations.of(context)!.achievementSaved!,
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
                      handleTilePress: handleTilePress,
                      focusNode: _editingFocus,
                      customSnackBarController: _customSnackBarController,
                      goalsBox: widget.goalsBox,
                      lifetimeController: widget.lifetimeController,
                      darkMode: appSettings.darkMode,
                      dismissBottomBar: dismissBottomBar,
                      showBottomBar: showBottomBar,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
