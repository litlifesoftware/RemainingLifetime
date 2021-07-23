import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/config/config.dart';
import 'package:remaining_lifetime/controller/hive_db_service.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/controller/user_data_controller.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/model/user_data.dart';
import 'package:remaining_lifetime/view/screens/privacy_screen.dart';
import 'package:remaining_lifetime/view/screens/tour_screen.dart';
import 'package:remaining_lifetime/view/widgets/about_dialog.dart';

/// A screen widget allowing the user to view interact with his personal data.
///
/// It displays basic analytics and provides options to change app specific
/// settings.
class ProfileScreen extends StatefulWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({
    Key? key,
    required this.toggleHideNavigationBar,
  }) : super(key: key);

  /// Callback to notify the parent widget that the navigation bar should be
  /// hidden or shown.
  final void Function() toggleHideNavigationBar;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Controlls the [LitSettingsPanel] instance.
  late LitSettingsPanelController _settingsPanelCon;

  /// Returns the provided [UserData]'s user color member value.
  Color _getUserColor(UserData userData) {
    return userData.color != null
        ? Color(userData.color!)
        : DefaultUserData.defaultColor;
  }

  /// Updates the [UserData] in regard of the new provided [color] while other
  /// members will not be affected.
  void _setUserColor(
    Color color,
    UserData userData,
    Box<dynamic> userDataBox,
  ) {
    userDataBox.putAt(
      0,
      UserData(
        color: color.value,
        dayOfBirth: userData.dayOfBirth,
      ),
    );
  }

  @override
  void initState() {
    _settingsPanelCon = LitSettingsPanelController()
      ..addListener(widget.toggleHideNavigationBar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getUserData(),
      builder: (context, Box<dynamic> userDataBox, _) {
        UserData userData = userDataBox.getAt(0)!;
        return ValueListenableBuilder(
          valueListenable: HiveDBService().getAppSettings(),
          builder: (context, Box<dynamic> appSettingsBox, _) {
            AppSettings appSettings = appSettingsBox.getAt(0)!;
            return LitScaffold(
              settingsPanel: LitSettingsPanel(
                controller: _settingsPanelCon,
                darkMode: appSettings.darkMode!,
                title: RemainingLifetimeLocalizations.of(context)!.settings!,
                settingsTiles: [
                  LitSettingsPanelTile(
                    disabledLabel:
                        RemainingLifetimeLocalizations.of(context)!.turnedOff!,
                    enabledLabel:
                        RemainingLifetimeLocalizations.of(context)!.turnedOn!,
                    iconData: LitIcons.animation,
                    onValueToggled: (toggledValue) {
                      appSettingsBox.putAt(
                        0,
                        AppSettings(
                          agreedPrivacy: appSettings.agreedPrivacy,
                          darkMode: appSettings.darkMode,
                          animated: toggledValue,
                          showDate: appSettings.showDate,
                          tabIndex: appSettings.tabIndex,
                        ),
                      );
                    },
                    optionName:
                        RemainingLifetimeLocalizations.of(context)!.animations!,
                    darkMode: appSettings.darkMode!,
                    enabled: appSettings.animated ?? true,
                  ),
                  LitSettingsPanelTile(
                    disabledLabel:
                        RemainingLifetimeLocalizations.of(context)!.turnedOff!,
                    enabledLabel:
                        RemainingLifetimeLocalizations.of(context)!.turnedOn!,
                    onValueToggled: (toggledValue) {
                      appSettingsBox.putAt(
                        0,
                        AppSettings(
                          agreedPrivacy: appSettings.agreedPrivacy,
                          darkMode: toggledValue,
                          animated: appSettings.animated,
                          showDate: appSettings.showDate,
                          tabIndex: appSettings.tabIndex,
                        ),
                      );
                    },
                    darkMode: appSettings.darkMode!,
                    enabled: appSettings.darkMode ?? false,
                    optionName:
                        RemainingLifetimeLocalizations.of(context)!.darkMode!,
                    iconData: LitIcons.moon,
                  ),
                  LitSettingsPanelTile(
                    disabledLabel:
                        RemainingLifetimeLocalizations.of(context)!.turnedOff!,
                    enabledLabel:
                        RemainingLifetimeLocalizations.of(context)!.turnedOn!,
                    onValueToggled: (toggledValue) {
                      appSettingsBox.putAt(
                        0,
                        AppSettings(
                          agreedPrivacy: appSettings.agreedPrivacy,
                          darkMode: appSettings.darkMode,
                          animated: appSettings.animated,
                          showDate: toggledValue,
                          tabIndex: appSettings.tabIndex,
                        ),
                      );
                    },
                    darkMode: appSettings.darkMode!,
                    enabled: appSettings.showDate ?? false,
                    optionName: "Dates Only",
                    iconData: LitIcons.plus,
                  ),
                ],
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.99],
                    colors: [
                      Colors.white,
                      Color(0xFFFFFFFF),
                    ],
                  ),
                ),
                child: ScrollableColumn(
                  children: [
                    SizedBox(
                      height: 64.0,
                    ),
                    Text(
                      RemainingLifetimeLocalizations.of(context)!.yourAge,
                      textAlign: TextAlign.center,
                      style: LitSansSerifStyles.h6,
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    LitUserIcon(
                      username: "${UserDataController(userData).age}",
                      primaryColor: _getUserColor(userData),
                    ),
                    _UserColorCard(
                      userData: userData,
                      onApplyColor: (color) =>
                          _setUserColor(color, userData, userDataBox),
                    ),
                    _StatisticsCard(
                      userData: userData,
                    ),
                    SizedBox(
                      height: 64.0,
                    ),
                    _Footer(
                      appSettings: appSettings,
                      settingsPanelController: _settingsPanelCon,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Footer extends StatefulWidget {
  final LitSettingsPanelController settingsPanelController;
  final AppSettings appSettings;
  const _Footer({
    Key? key,
    required this.settingsPanelController,
    required this.appSettings,
  }) : super(key: key);

  @override
  __FooterState createState() => __FooterState();
}

class __FooterState extends State<_Footer> {
  void _onLicensesPressed() {
    LitRouteController(context).pushMaterialWidget(
      ApplicationLicensesScreen(
        darkMode: widget.appSettings.darkMode!,
      ),
    );
  }

  void _onPressedAdvanced() {
    widget.settingsPanelController.showSettingsPanel();
  }

  void _onPressedPrivacy() {
    LitRouteController(context).pushMaterialWidget(
      PrivacyScreen(),
    );
  }

  void _onPressedAbout() {
    LitRouteController(context).showDialogWidget(
      AboutAppDialog(),
    );
  }

  void _onPressedTour() {
    LitRouteController(context).pushMaterialWidget(
      TourScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LitSettingsFooter(
      title: RemainingLifetimeLocalizations.of(context)!.settings!,
      children: [
        LitPlainLabelButton(
          label: RemainingLifetimeLocalizations.of(context)!.advanced,
          onPressed: _onPressedAdvanced,
        ),
        LitPlainLabelButton(
          label: RemainingLifetimeLocalizations.of(context)!.tour,
          onPressed: _onPressedTour,
        ),
        LitPlainLabelButton(
          label: RemainingLifetimeLocalizations.of(context)!.aboutThisApp!,
          onPressed: _onPressedAbout,
        ),
        LitPlainLabelButton(
          label: RemainingLifetimeLocalizations.of(context)!.privacy!,
          onPressed: _onPressedPrivacy,
        ),
        LitPlainLabelButton(
          label: RemainingLifetimeLocalizations.of(context)!.licenses!,
          onPressed: _onLicensesPressed,
        ),
      ],
    );
  }
}

class _StatisticsItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatisticsItem({
    Key? key,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: LitSansSerifStyles.h6.copyWith(
            color: Colors.white,
            shadows: LitBoxShadows.textSm,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: LitSansSerifStyles.body2,
        ),
      ],
    );
  }
}

class _StatisticsIndicator extends StatefulWidget {
  final double relValue;
  const _StatisticsIndicator({
    Key? key,
    required this.relValue,
  }) : super(key: key);

  @override
  _StatisticsIndicatorState createState() => _StatisticsIndicatorState();
}

class _StatisticsIndicatorState extends State<_StatisticsIndicator>
    with TickerProviderStateMixin {
  late AnimationController _indicatorAnimation;

  @override
  void initState() {
    _indicatorAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _indicatorAnimation.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _indicatorAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AnimatedBuilder(
                animation: _indicatorAnimation,
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 96.0,
                        width: 32.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: widget.relValue > 0.5
                                ? Alignment.bottomCenter
                                : Alignment.topCenter,
                            end: widget.relValue > 0.5
                                ? Alignment.topCenter
                                : Alignment.bottomCenter,
                            stops: [
                              0.5 * _indicatorAnimation.value,
                              0.5 + 0.5 * _indicatorAnimation.value,
                            ],
                            colors: [
                              LitColors.lightGrey.withOpacity(0.45),
                              Color.lerp(
                                  Color(0xFFE2E2E2),
                                  widget.relValue > 0.5
                                      ? LitColors.lightBlue
                                      : LitColors.lightPink,
                                  _indicatorAnimation.value)!,
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              16.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: (widget.relValue * (96.0 - 32.0)),
                          ),
                          child: Container(
                            height: 32.0,
                            width: 32.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Colors.black26,
                                  offset: Offset(-1.0, 1.0),
                                  spreadRadius: -1.0,
                                )
                              ],
                              color: LitColors.lightGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LitBadge(
              backgroundColor: Color(0xFFf0F0f0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
              child: Text(
                "${(widget.relValue * 100).toStringAsFixed(0)} %",
                style: LitSansSerifStyles.caption.copyWith(
                  color: Color(0xff6c6c6c),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _StatisticsCard extends StatefulWidget {
  final UserData userData;
  const _StatisticsCard({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  __StatisticsCardState createState() => __StatisticsCardState();
}

class __StatisticsCardState extends State<_StatisticsCard> {
  late LifetimeController _lifetimeController;

  double get _monthsSpentRel {
    return _lifetimeController.pastLifeTimeInMonths /
        _lifetimeController.lifeExpectancyInMonths;
  }

  int get _monthsSpent {
    return _lifetimeController.pastLifeTimeInMonths;
  }

  double get _monthsRemainingRel {
    return _lifetimeController.remainingLifeTimeInMonths /
        _lifetimeController.lifeExpectancyInMonths;
  }

  int get _monthsRemaining {
    return _lifetimeController.remainingLifeTimeInMonths;
  }

  @override
  void initState() {
    _lifetimeController =
        LifetimeController(dayOfBirthTimestamp: widget.userData.dayOfBirth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitConstrainedSizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: constraints.maxWidth / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _StatisticsItem(
                          label: RemainingLifetimeLocalizations.of(context)!
                              .monthsSpent,
                          value: "$_monthsSpent",
                        ),
                        _StatisticsIndicator(
                          relValue: _monthsSpentRel,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _StatisticsItem(
                          label: RemainingLifetimeLocalizations.of(context)!
                              .monthsRemaining,
                          value: "$_monthsRemaining",
                        ),
                        _StatisticsIndicator(
                          relValue: _monthsRemainingRel,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UserColorCard extends StatelessWidget {
  final UserData userData;
  final void Function(Color color) onApplyColor;
  const _UserColorCard({
    Key? key,
    required this.userData,
    required this.onApplyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitGradientCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      colors: [
        Color(0xFFFFFFFF),
        Color(userData.color!).withAlpha(255),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              RemainingLifetimeLocalizations.of(context)!.yourColor,
              style: LitSansSerifStyles.body2.copyWith(
                  color: Color(userData.color!).applyColorByContrast(
                Colors.white,
                LitColors.mediumGrey,
              )),
            ),
            LitPushedThroughButton(
              backgroundColor: Color(0xFFFFF0F0),
              accentColor: Color(0xFFFDF7F7),
              child: Text(
                RemainingLifetimeLocalizations.of(context)!
                    .change
                    .toUpperCase(),
                style: LitSansSerifStyles.button.copyWith(
                  color: Color(0xff8a8a8a),
                ),
              ),
              onPressed: () {
                LitRouteController(context).showDialogWidget(
                  LitColorPickerDialog(
                    initialColor: Color(userData.color!),
                    onApplyColor: onApplyColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
