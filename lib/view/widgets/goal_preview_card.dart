import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/goal_card_action_button.dart';

/// A [StatelessWidget] to extend the [CollapsibleCard] in order to implement
/// a custom style.
///
/// The [GoalPreviewCard] allows the user to create an [Goal] or to view and
/// edit an existing [Goal].
class GoalPreviewCard extends StatefulWidget implements CollapsibleCard {
  final CollapsibleCardController collapsibleCardController;
  final LifetimeController? lifetimeController;
  final Goal? goal;
  final void Function() onCloseCallback;
  final void Function() saveGoalCallback;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final bool? darkMode;

  /// Creates a [GoalPreviewCard].
  ///
  /// Change the appearance using the [darkMode] value.
  const GoalPreviewCard({
    Key? key,
    required this.collapsibleCardController,
    required this.lifetimeController,
    required this.goal,
    required this.onCloseCallback,
    required this.saveGoalCallback,
    required this.focusNode,
    required this.textEditingController,
    required this.darkMode,
  }) : super(key: key);

  @override
  _GoalPreviewCardState createState() => _GoalPreviewCardState();

  @override
  CollapsibleCardController get controller => collapsibleCardController;
}

class _GoalPreviewCardState extends State<GoalPreviewCard> {
  DateTime get _dateTime {
    return widget.goal != null
        ? DateTime(
            widget.goal!.year!,
            widget.goal!.month!,
          )
        : DateTime.now();
  }

  Color get _closedButtonColor {
    return widget.darkMode! ? Colors.white : LitColors.lightRed;
  }

  Color get _backgroundColor {
    return widget.darkMode! ? LitColors.darkBlue : Colors.white;
  }

  Color get _closeButtonBorderColor {
    return widget.darkMode! ? LitColors.lightGrey : LitColors.lightRed;
  }

  Color get _topBarColor {
    return widget.darkMode! ? LitColors.mediumGrey : LitColors.lightGrey;
  }

  String get _title {
    String langCode = Localizations.localeOf(context).languageCode;
    String monthFormat = DateFormat.MMMM(langCode).format(_dateTime);
    return "$monthFormat ${widget.goal!.year}";
  }

  Color get _textColor {
    return widget.darkMode! ? Colors.white : Colors.black45;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the provided Goal is initialized.
    return widget.goal != null
        ? TitledCollapsibleCard(
            collapsibleCardController: widget.collapsibleCardController,
            closeButtonBorderColor: _closeButtonBorderColor,
            closeButtonColor: _closedButtonColor,
            backgroundColor: _backgroundColor,
            onCloseCallback: widget.onCloseCallback,
            topBarColor: _topBarColor,
            title: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    child: Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: LitSansSerifStyles.header5.copyWith(
                        color: _textColor,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GoalCardActionButton(
                    goal: widget.goal!,
                    darkMode: widget.darkMode!,
                    textEditingController: widget.textEditingController,
                    saveGoalCallback: widget.saveGoalCallback,
                  ),
                ),
              ],
            ),
            child: _CardContent(
              darkMode: widget.darkMode!,
              focusNode: widget.focusNode,
              textEditingController: widget.textEditingController,
            ),
          )
        : SizedBox();
  }
}

class _CardContent extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final bool darkMode;
  final List<BoxShadow> boxShadow;
  final EdgeInsets padding;
  const _CardContent({
    Key? key,
    required this.darkMode,
    required this.textEditingController,
    required this.focusNode,
    this.boxShadow = const [
      const BoxShadow(
        blurRadius: 4.0,
        color: Colors.black26,
        spreadRadius: -1.0,
        offset: Offset(-2.0, 2.0),
      )
    ],
    this.padding = const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 32.0,
    ),
  }) : super(key: key);

  @override
  __CardContentState createState() => __CardContentState();
}

class __CardContentState extends State<_CardContent> {
  Color get _innerCardBackgroundColor {
    return widget.darkMode ? Color(0xFF204a62).withOpacity(0.5) : Colors.white;
  }

  Color get _textColor {
    return widget.darkMode ? Colors.white : LitColors.mediumGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: widget.boxShadow,
          color: _innerCardBackgroundColor,
          borderRadius: BorderRadius.circular(22.0),
        ),
        child: TextField(
          controller: widget.textEditingController,
          focusNode: widget.focusNode,
          maxLines: 5,
          style: LitSansSerifStyles.body.copyWith(
            color: _textColor,
          ),
          cursorColor: LitColors.mediumGrey,
          decoration: InputDecoration(
            hintText: widget.textEditingController.text.isEmpty
                ? RemainingLifetimeLocalizations.of(context)!
                        .addAnAchievement! +
                    " ..."
                : '',
            hintStyle: LitSansSerifStyles.body.copyWith(
              color: _textColor.withOpacity(0.65),
            ),
            focusColor: LitColors.mediumGrey,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}
