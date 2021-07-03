import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';

/// A [StatefulWidget] to display the total month count of the user.
///
/// Once the user long-presses the [LifetimeTile], the displayed text
/// will change from the total count to the precise month and year
/// of the tile.
///
/// In order to extract the information necessary to calculate the
/// month and year, a [LifetimeController] must be provided.
class LifetimeTile extends StatefulWidget {
  final LifetimeController? lifetimeController;
  final int index;
  final int? longPressedId;
  final int? pastLifeTimeInMonths;
  final bool? darkMode;
  final void Function() handleTilePress;
  final void Function(int index) setLongPressedId;
  final void Function() resetLongPressedId;
  final AnimationController animation;
  final double width;
  final double height;

  /// Creates a [LifetimeTile].
  ///
  /// Change the appearance using the [darkMode] value.
  const LifetimeTile({
    Key? key,
    required this.lifetimeController,
    required this.index,
    required this.longPressedId,
    required this.pastLifeTimeInMonths,
    required this.darkMode,
    required this.handleTilePress,
    required this.setLongPressedId,
    required this.animation,
    required this.resetLongPressedId,
    this.height = 64.0,
    this.width = 64.0,
  }) : super(key: key);

  @override
  _LifetimeTileState createState() => _LifetimeTileState();
}

class _LifetimeTileState extends State<LifetimeTile> {
  /// The month value of the tile.
  int? tileMonth;

  /// The year value of the tile.
  int? tileYear;

  /// State whether or not this [LifetimeTile] has
  /// already been spent.
  bool get isPast {
    return widget.pastLifeTimeInMonths! >= widget.index;
  }

  @override
  void initState() {
    super.initState();
    tileMonth = DateTime.fromMillisecondsSinceEpoch(widget
            .lifetimeController!.dayOfBirthDateTime.millisecondsSinceEpoch)
        .add(Duration(
            milliseconds: widget.index *
                widget.lifetimeController!.millisecondsPerMonth.toInt()))
        .month;
    tileYear = DateTime.fromMillisecondsSinceEpoch(widget
            .lifetimeController!.dayOfBirthDateTime.millisecondsSinceEpoch)
        .add(Duration(
            milliseconds: widget.index *
                widget.lifetimeController!.millisecondsPerMonth.toInt()))
        .year;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: GestureDetector(
            onLongPressEnd: (details) => widget.resetLongPressedId(),
            onLongPressStart: (details) =>
                widget.setLongPressedId(widget.index),
            onTap: widget.handleTilePress,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                    animation: widget.animation,
                    builder: (context, child) {
                      return Transform.scale(
                          scale: widget.index == widget.longPressedId
                              ? (1 + widget.animation.value)
                              : 1.0,
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(widget.width / 3),
                                color: isPast
                                    ? widget.darkMode!
                                        ? LitColors.mediumGrey.withOpacity(0.55)
                                        : LitColors.lightRed.withOpacity(0.35)
                                    : Colors.grey.withOpacity(0.2)),
                            child: Center(
                              child: Text(
                                widget.index == widget.longPressedId
                                    ? "$tileMonth\n$tileYear"
                                    // Increase the index by one to display the month number.
                                    : "${widget.index + 1}",
                                style: LitTextStyles.sansSerif.copyWith(
                                  color: isPast
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.8),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ));
                    }),
              ],
            )),
      ),
    );
  }
}
