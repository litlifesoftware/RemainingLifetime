import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/view/widgets/percent_indicator_painter.dart';

class BottomBar extends StatefulWidget {
  final LifetimeController lifetimeController;
  final void Function() onSettingsPressCallback;
  final bool darkMode;
  const BottomBar({
    Key key,
    @required this.lifetimeController,
    @required this.onSettingsPressCallback,
    @required this.darkMode,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  AnimationController _appearAnimation;

  int get animatedSpentMonths {
    return (widget.lifetimeController.pastLifeTimeInMonths *
            _appearAnimation.value)
        .toInt();
  }

  int get animatedRemainingMonths {
    return (widget.lifetimeController.remainingLifeTimeInMonths *
            _appearAnimation.value)
        .toInt();
  }

  double get spendMonthsRatio {
    return (widget.lifetimeController.pastLifeTimeInMonths /
        widget.lifetimeController.lifeExpectancyInMonths);
  }

  @override
  void initState() {
    super.initState();
    _appearAnimation = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _appearAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: OrientationBuilder(builder: (context, orientation) {
        return Padding(
          padding: orientation == Orientation.portrait
              ? const EdgeInsets.all(16.0)
              : const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Container(
            height: 80.0,
            //         AspectRatio(
            // aspectRatio: orientation == Orientation.portrait ? 4.3 : 8.6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: AnimatedBuilder(
                  animation: _appearAnimation,
                  builder: (context, child) {
                    _appearAnimation.forward();
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: LitColors.mediumGrey.withOpacity(0.25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                      32.0 -
                                      32.0) /
                                  3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ScaledDownText(
                                      RemainingLifetimeLocalizations.of(context)
                                          .spent
                                          .toUpperCase(),
                                      style: LitTextStyles.sansSerif.copyWith(
                                        color: Colors.white70,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    ScaledDownText(
                                      RemainingLifetimeLocalizations.of(context)
                                          .remaining
                                          .toUpperCase(),
                                      style: LitTextStyles.sansSerif.copyWith(
                                        color: Colors.white70,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                      32.0 -
                                      32.0) /
                                  3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$animatedSpentMonths",
                                      style: LitTextStyles.sansSerif.copyWith(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      "$animatedRemainingMonths",
                                      style: LitTextStyles.sansSerif.copyWith(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                      32.0 -
                                      32.0) /
                                  3,
                              child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: CustomPaint(
                                        painter: PercentIndicatorPainter(
                                          progressRatio: spendMonthsRatio,
                                          animationController: _appearAnimation,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: InkWell(
                                        onTap: widget.onSettingsPressCallback,
                                        child: Icon(
                                          LitIcons.gear_solid,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // ),
        );
      }),
    );
  }
}
