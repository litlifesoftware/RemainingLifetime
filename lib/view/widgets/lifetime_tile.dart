import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/model/app_settings.dart';

/// A [StatefulWidget] to display the total month count of the user.
///
/// Once the user long-presses the [LifetimeTile], the displayed text will
/// change from the total count to the precise month and year of the tile.
///
/// In order to extract the information necessary to calculate the month and
/// year, a [LifetimeController] must be provided.
class LifetimeTile extends StatefulWidget {
  final LifetimeController? lifetimeController;

  final int index;

  final int? longPressedId;

  final int? pastLifeTimeInMonths;

  final AppSettings appSettings;

  final void Function() handleTilePress;

  final void Function(int index) setLongPressedId;

  final void Function() resetLongPressedId;

  final AnimationController animation;

  final double width;

  final double height;

  /// Creates a [LifetimeTile].
  ///
  /// Depending on the [AppSetting].
  const LifetimeTile({
    Key? key,
    required this.lifetimeController,
    required this.index,
    required this.longPressedId,
    required this.pastLifeTimeInMonths,
    required this.appSettings,
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
  Duration get _durationSinceBirth {
    return Duration(
        milliseconds: widget.index *
            widget.lifetimeController!.millisecondsPerMonth.toInt());
  }

  /// Returns the user's day of birth.
  DateTime get _birth {
    return DateTime.fromMillisecondsSinceEpoch(widget
            .lifetimeController!.dayOfBirthDateTime.millisecondsSinceEpoch)
        .add(_durationSinceBirth);
  }

  /// The month value of the tile.
  int get _tileMonth {
    return _birth.month;
  }

  /// The year value of the tile.
  int get _tileYear {
    return _birth.year;
  }

  /// State whether or not this [LifetimeTile] has
  /// already been spent.
  bool get isPast {
    return widget.pastLifeTimeInMonths! >= widget.index;
  }

  /// Evaluates whether the currently displayed tile is belonging to the
  /// current month.
  bool get _isTileNow {
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    return _tileMonth == currentMonth && _tileYear == currentYear;
  }

  /// Returns the tile's background color depending on the current date it's
  /// belonging to.
  Color get _backgroundColor {
    return _isTileNow
        ? LitColors.lightGrey
        : isPast
            ? Color(0xff5f5f5f)
            : Color(0xff576770);
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
          onLongPressStart: (details) => widget.setLongPressedId(widget.index),
          onTap: widget.handleTilePress,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.index == widget.longPressedId
                    ? (1 + widget.animation.value)
                    : 1.0,
                child: Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.width / 3),
                    color: _backgroundColor,
                    boxShadow: LitBoxShadows.md,
                  ),
                  child: Center(
                    child: _TileLabel(
                      appSettings: widget.appSettings,
                      isTileNow: _isTileNow,
                      index: widget.index,
                      longPressedId: widget.longPressedId,
                      tileMonth: _tileMonth,
                      tileYear: _tileYear,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A widget to display the tile's label depending on the [AppSettings].
class _TileLabel extends StatefulWidget {
  const _TileLabel({
    Key? key,
    required this.appSettings,
    required this.index,
    required this.longPressedId,
    required this.isTileNow,
    required this.tileMonth,
    required this.tileYear,
  }) : super(key: key);
  final AppSettings appSettings;

  final int index;

  final int? longPressedId;

  final int tileMonth;

  final int tileYear;

  final bool isTileNow;

  @override
  __TileLabelState createState() => __TileLabelState();
}

class __TileLabelState extends State<_TileLabel> {
  List<BoxShadow> get _textShadow {
    return widget.isTileNow
        ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              spreadRadius: -2.0,
            ),
          ]
        : [
            BoxShadow(
              color: Colors.white38,
              blurRadius: 4.0,
              spreadRadius: -2.0,
            ),
          ];
  }

  Color get _color {
    return widget.isTileNow ? LitColors.mediumGrey : Color(0xFFFFF4dc);
  }

  String get _dateLabel {
    return "${widget.tileMonth}\n${widget.tileYear}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.index == widget.longPressedId
          ? _dateLabel
          : (widget.appSettings.showDate != null &&
                  widget.appSettings.showDate!)
              ? _dateLabel
              // Increase the index by one to display the month number.
              : "${widget.index + 1}",
      style: LitSansSerifStyles.subtitle2.copyWith(
        color: _color,
        shadows: _textShadow,
      ),
      textAlign: TextAlign.center,
    );
  }
}
