import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/hive_db_service.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/controller/user_data_controller.dart';
import 'package:remaining_lifetime/data/default_user_data.dart';
import 'package:remaining_lifetime/model/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color get _userColor {
    return DefaultUserData.defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getUserData(),
      builder: (context, Box<dynamic> userDataBox, _) {
        UserData userData = userDataBox.getAt(0)!;
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFFFE9E9),
                Color(0xFFDDDDDD),
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
                style: LitSansSerifStyles.header6,
              ),
              SizedBox(
                height: 32.0,
              ),
              LitUserIcon(
                username: "${UserDataController(userData).age}",
                primaryColor: _userColor,
              ),
              _UserColorCard(),
              _StatisticsCard(
                userData: userData,
              ),
              SizedBox(
                height: 128.0,
              ),
            ],
          ),
        );
      },
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
      children: [
        Text(
          value,
          style: LitSansSerifStyles.header6.copyWith(
            color: Colors.white,
            shadows: [
              BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black12,
                blurRadius: 4.0,
              )
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Text(label, style: LitSansSerifStyles.body),
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
    print(_indicatorAnimation.value);
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
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
                Column(
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserColorCard extends StatelessWidget {
  const _UserColorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitGradientCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
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
              style: LitSansSerifStyles.body,
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
