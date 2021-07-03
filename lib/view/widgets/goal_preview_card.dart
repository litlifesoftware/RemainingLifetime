import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/lifetime_controller.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/model/goal.dart';
import 'package:remaining_lifetime/view/widgets/goal_preview_card_action_button.dart';

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
  final FocusNode? focusNode;
  final TextEditingController? textEditingController;
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
  // TODO: implement controller
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

  @override
  Widget build(BuildContext context) {
    // Ensure the provided Goal is initialized.
    return widget.goal != null
        ? TitledCollapsibleCard(
            collapsibleCardController: widget.collapsibleCardController,
            closeButtonBorderColor:
                widget.darkMode! ? LitColors.mintGreen : LitColors.lightRed,
            closeButtonColor: widget.darkMode!
                ? Colors.white
                : LitColors.lightRed.withOpacity(0.8),
            backgroundColor: widget.goal!.id == 0
                ? widget.darkMode!
                    ? LitColors.darkBeige
                    : LitColors.beigeGrey
                : widget.goal!.id ==
                        widget.lifetimeController!.lifeExpectancyInMonths - 1
                    ? widget.darkMode!
                        ? LitColors.darkOliveGreen
                        : LitColors.lightPink
                    : widget.darkMode!
                        ? LitColors.darkBlue
                        : Colors.white,
            onCloseCallback: widget.onCloseCallback,
            topBarColor: widget.darkMode!
                ? LitColors.mediumGrey
                : LitColors.lightMintGreen.withOpacity(0.5),
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
                      "${DateFormat.MMMM('${Localizations.localeOf(context).languageCode}').format(_dateTime)} ${widget.goal!.year}",
                      textAlign: TextAlign.center,
                      style: LitTextStyles.sansSerif.copyWith(
                        fontSize: 16.5,
                        color: widget.darkMode! ? Colors.white : Colors.black45,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GoalPreviewCardActionButton(
                      goal: widget.goal,
                      darkMode: widget.darkMode,
                      textEditingController: widget.textEditingController,
                      saveGoalCallback: widget.saveGoalCallback),
                ),
              ],
            ),
            child: widget.goal!.id == 0
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                      child: Text(
                        "${RemainingLifetimeLocalizations.of(context)!.myDateOfBirth} \u{1F973}\u{1F389}\u{1F389}",
                        textAlign: TextAlign.left,
                        style: LitTextStyles.sansSerif.copyWith(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color:
                              widget.darkMode! ? Colors.white : Colors.black45,
                        ),
                      ),
                    ),
                  )
                : widget.goal!.id ==
                        widget.lifetimeController!.lifeExpectancyInMonths - 1
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          child: Text(
                            "${RemainingLifetimeLocalizations.of(context)!.mightBeYourLastMonth}...",
                            textAlign: TextAlign.left,
                            style: LitTextStyles.sansSerif.copyWith(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                              color: widget.darkMode!
                                  ? Colors.white
                                  : LitColors.mediumGrey,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: widget.darkMode! ? 16.0 : 14.0,
                                color: widget.darkMode!
                                    ? Colors.black45
                                    : Colors.black12,
                                spreadRadius: widget.darkMode! ? 10.0 : 4.0,
                                offset: widget.darkMode!
                                    ? Offset(1, 1)
                                    : Offset(2, 2),
                              )
                            ],
                            color: widget.darkMode!
                                ? LitColors.lightPink
                                    .withOpacity(0.1)
                                    .withOpacity(0.6)
                                : LitColors.mintGreen.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: widget.textEditingController,
                            focusNode: widget.focusNode,
                            maxLines: 4,
                            style: LitTextStyles.sansSerif.copyWith(
                              fontSize: 18.0,
                              color: widget.darkMode!
                                  ? Colors.white
                                  : LitColors.mediumGrey,
                            ),
                            cursorColor: LitColors.mediumGrey,
                            decoration: InputDecoration(
                              hintText: widget
                                      .textEditingController!.text.isEmpty
                                  ? '${RemainingLifetimeLocalizations.of(context)!.addAnAchievement} ...'
                                  : '',
                              hintStyle: LitTextStyles.sansSerif.copyWith(
                                fontSize: 16.0,
                                color: widget.darkMode!
                                    ? Colors.white60
                                    : LitColors.mediumGrey.withOpacity(0.4),
                              ),
                              focusColor: LitColors.mediumGrey,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
          )
        : SizedBox();
  }
}
