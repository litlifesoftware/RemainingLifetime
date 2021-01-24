import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/lifetime_tile.dart';

class LifetimeGrid extends StatefulWidget {
  final LifetimeController lifetimeController;
  final bool darkMode;
  final void Function() showBottomBar;
  final void Function() dismissBottomBar;
  final Box<dynamic> goalsBox;
  final LitSnackbarController customSnackBarController;
  final FocusNode focusNode;
  final void Function(int index) handleTilePress;

  /// Creates a [LifetimeGrid] [StatelessWidget].
  ///
  /// Its main purpose is to display all remaining months of the user as
  /// a [GridView]. This will enable the user to select a specific month
  /// in order to edit the corresponding [Goal] object.
  const LifetimeGrid({
    Key key,
    @required this.lifetimeController,
    @required this.darkMode,
    @required this.showBottomBar,
    @required this.dismissBottomBar,
    @required this.goalsBox,
    @required this.customSnackBarController,
    @required this.focusNode,
    @required this.handleTilePress,
  }) : super(key: key);

  @override
  _LifetimeGridState createState() => _LifetimeGridState();
}

class _LifetimeGridState extends State<LifetimeGrid>
    with TickerProviderStateMixin {
  AnimationController _longPressedAnimation;
  AnimationController _pressedAnimation;

  /// The currently long pressed [Goal] object is retrieved using its
  /// index.
  int _longPressedId;

  int _pastLifetimeInMonths;
  int _totalMonths;
  void initGoals(Box<Goal> goalsBox) {}

  /// Set the index value of the long pressed [Goal].
  void setLongPressedId(int value) {
    setState(() {
      _longPressedId = value;
    });
    _longPressedAnimation.forward(from: 0.0);
  }

  /// Reset the index value of the long pressed [Goal].
  void resetLongPressedId() {
    _longPressedAnimation.reverse(from: 1.0).then((value) => setState(() {
          _longPressedId = null;
        }));
  }

  @override
  void initState() {
    super.initState();

    _longPressedAnimation = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 200,
        ));
    _pressedAnimation = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 500,
        ));

    _pastLifetimeInMonths = widget.lifetimeController.pastLifeTimeInMonths;
    _totalMonths = widget.lifetimeController.lifeExpectancyInMonths;
  }

  @override
  void dispose() {
    _longPressedAnimation.dispose();
    _pressedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double tileWidth = 46.0;
    final double availableWidth = MediaQuery.of(context).size.width - 60.0;
    final int portraitAxisCount = (availableWidth ~/ tileWidth);
    final int landscapeAxisCount = (availableWidth ~/ tileWidth) - 1;
    return OrientationBuilder(builder: (context, orientation) {
      return Stack(
        children: [
          GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 40.0,
              bottom: 115.0,
              left: 15.0,
              right: 15.0,
            ),
            itemCount: _totalMonths,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait
                  ? portraitAxisCount
                  : landscapeAxisCount,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: tileWidth,
                  height: tileWidth,
                  child: GestureDetector(
                      onLongPressEnd: (details) => resetLongPressedId(),
                      onLongPressStart: (details) => setLongPressedId(index),
                      onTap: () => widget.handleTilePress(index),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                              animation: _longPressedAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: index == _longPressedId
                                      ? (1 + _longPressedAnimation.value)
                                      : 1.0,
                                  child: LifetimeTile(
                                    darkMode: widget.darkMode,
                                    lifetimeController:
                                        widget.lifetimeController,
                                    index: index,
                                    longPressedId: _longPressedId,
                                    pastLifeTimeInMonths: _pastLifetimeInMonths,
                                  ),
                                );
                              }),
                        ],
                      )),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
