import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/lifetime_tile.dart';

class LifetimeGrid extends StatefulWidget {
  final LifetimeController? lifetimeController;
  final bool? darkMode;
  final void Function() showBottomBar;
  final void Function() dismissBottomBar;
  final Box<dynamic> goalsBox;
  final LitSnackbarController? customSnackBarController;
  final FocusNode? focusNode;
  final void Function(int index) handleTilePress;
  final double tileWidth;

  /// Creates a [LifetimeGrid] [StatelessWidget].
  ///
  /// Its main purpose is to display all remaining months of the user as
  /// a [GridView]. This will enable the user to select a specific month
  /// in order to edit the corresponding [Goal] object.
  const LifetimeGrid({
    Key? key,
    required this.lifetimeController,
    required this.darkMode,
    required this.showBottomBar,
    required this.dismissBottomBar,
    required this.goalsBox,
    required this.customSnackBarController,
    required this.focusNode,
    required this.handleTilePress,
    this.tileWidth = 64.0,
  }) : super(key: key);

  @override
  _LifetimeGridState createState() => _LifetimeGridState();
}

class _LifetimeGridState extends State<LifetimeGrid>
    with TickerProviderStateMixin {
  late AnimationController _longPressedAnimation;
  late AnimationController _pressedAnimation;

  /// The currently long pressed [Goal] object is retrieved using its
  /// index.
  int? _longPressedId;

  int? _pastLifetimeInMonths;
  int? _totalMonths;
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

    _pastLifetimeInMonths = widget.lifetimeController!.pastLifeTimeInMonths;
    _totalMonths = widget.lifetimeController!.lifeExpectancyInMonths;
  }

  @override
  void dispose() {
    _longPressedAnimation.dispose();
    _pressedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LayoutBuilder(builder: (context, constraints) {
            final int portraitAxisCount =
                (constraints.maxWidth ~/ widget.tileWidth);
            final int landscapeAxisCount =
                (constraints.maxWidth ~/ widget.tileWidth) - 4;
            return OrientationBuilder(builder: (context, orientation) {
              return Container(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LitConstrainedSizedBox(
                    landscapeWidthFactor: 0.75,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 128.0,
                        top: 16.0,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemCount: _totalMonths,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: orientation == Orientation.portrait
                            ? portraitAxisCount
                            : landscapeAxisCount,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return LifetimeTile(
                          darkMode: widget.darkMode,
                          lifetimeController: widget.lifetimeController,
                          index: index,
                          longPressedId: _longPressedId,
                          pastLifeTimeInMonths: _pastLifetimeInMonths,
                          resetLongPressedId: resetLongPressedId,
                          animation: _longPressedAnimation,
                          handleTilePress: () => widget.handleTilePress(index),
                          setLongPressedId: setLongPressedId,
                        );
                      },
                    ),
                  ),
                ),
              );
            });
          }),
        )
      ],
    );
  }
}
