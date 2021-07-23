import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/lifetime_tile.dart';

/// A widget displaying all remaining months of the user on a [GridView].
///
/// This grid enables the user to select a specific month in order to edit
/// the corresponding [Goal] object.
class LifetimeGrid extends StatefulWidget {
  /// Creates a [LifetimeGrid].
  const LifetimeGrid({
    Key? key,
    required this.lifetimeController,
    required this.appSettings,
    required this.goalsBox,
    required this.snackBarController,
    required this.focusNode,
    required this.handleTilePress,
    this.tileSize = 64.0,
  }) : super(key: key);

  /// Provides details about the user's lifetime.
  final LifetimeController? lifetimeController;

  /// Provides data to customize the styling.
  final AppSettings appSettings;

  /// The box storing the [Goal] objects.
  final Box<dynamic> goalsBox;

  /// Controlls the [LitSnackbar].
  final LitSnackbarController snackBarController;

  /// Focuses on the input field.
  final FocusNode? focusNode;

  /// Specifies the size of each tile.
  final double tileSize;
  final void Function(int index) handleTilePress;

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

  /// Returns the user's past months.
  int get _pastLifetimeInMonths {
    return widget.lifetimeController!.pastLifeTimeInMonths;
  }

  /// Returns the user's total months.
  int get _totalMonths {
    return widget.lifetimeController!.lifeExpectancyInMonths;
  }

  /// Set the index value of the long pressed [Goal].
  void setLongPressedId(int value) {
    setState(() {
      _longPressedId = value;
    });

    _longPressedAnimation.forward(from: 0.0);
  }

  /// Reset the index value of the long pressed [Goal].
  void resetLongPressedId() {
    _longPressedAnimation.reverse(from: 1.0).then(
          (value) => setState(
            () {
              _longPressedId = null;
            },
          ),
        );
  }

  /// Calculates the grid's cross axis count based on the provided [constraints]
  /// and [orientation].
  int _calcCrossAxisCount(
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    int portraitAxisCount = (constraints.maxWidth ~/ widget.tileSize);
    int landscapeAxisCount = (constraints.maxWidth ~/ widget.tileSize) - 4;
    return orientation == Orientation.portrait
        ? portraitAxisCount
        : landscapeAxisCount;
  }

  @override
  void initState() {
    super.initState();

    _longPressedAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );

    _pressedAnimation = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
  }

  @override
  void dispose() {
    _longPressedAnimation.dispose();
    _pressedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
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
                        crossAxisCount: _calcCrossAxisCount(
                          constraints,
                          orientation,
                        ),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return LifetimeTile(
                          appSettings: widget.appSettings,
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
            },
          );
        },
      ),
    );
  }
}
