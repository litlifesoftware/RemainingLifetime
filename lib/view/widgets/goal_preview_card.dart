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
class GoalPreviewCard extends StatelessWidget implements CollapsibleCard {
  final CollapsibleCardController? collapsibleCardController;
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
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(
      goal!.year!,
      goal!.month!,
    );

    // Ensure the provided Goal is initialized.
    return goal != null
        ? TitledCollapsibleCard(
            collapsibleCardController: collapsibleCardController!,
            closeButtonBorderColor:
                darkMode! ? LitColors.mintGreen : LitColors.lightRed,
            closeButtonColor:
                darkMode! ? Colors.white : LitColors.lightRed.withOpacity(0.8),
            backgroundColor: goal!.id == 0
                ? darkMode!
                    ? LitColors.darkBeige
                    : LitColors.beigeGrey
                : goal!.id == lifetimeController!.lifeExpectancyInMonths - 1
                    ? darkMode!
                        ? LitColors.darkOliveGreen
                        : LitColors.lightPink
                    : darkMode!
                        ? LitColors.darkBlue
                        : Colors.white,
            onCloseCallback: onCloseCallback,
            topBarColor: darkMode!
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
                      "${DateFormat.MMMM('${Localizations.localeOf(context).languageCode}').format(dateTime)} ${goal!.year}",
                      textAlign: TextAlign.center,
                      style: LitTextStyles.sansSerif.copyWith(
                        fontSize: 16.5,
                        color: darkMode! ? Colors.white : Colors.black45,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GoalPreviewCardActionButton(
                      goal: goal,
                      darkMode: darkMode,
                      textEditingController: textEditingController,
                      saveGoalCallback: saveGoalCallback),
                ),
              ],
            ),
            child: goal!.id == 0
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
                          color: darkMode! ? Colors.white : Colors.black45,
                        ),
                      ),
                    ),
                  )
                : goal!.id == lifetimeController!.lifeExpectancyInMonths - 1
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
                              color: darkMode!
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
                                blurRadius: darkMode! ? 16.0 : 14.0,
                                color:
                                    darkMode! ? Colors.black45 : Colors.black12,
                                spreadRadius: darkMode! ? 10.0 : 4.0,
                                offset: darkMode! ? Offset(1, 1) : Offset(2, 2),
                              )
                            ],
                            color: darkMode!
                                ? LitColors.lightPink
                                    .withOpacity(0.1)
                                    .withOpacity(0.6)
                                : LitColors.mintGreen.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            maxLines: 4,
                            style: LitTextStyles.sansSerif.copyWith(
                              fontSize: 18.0,
                              color: darkMode!
                                  ? Colors.white
                                  : LitColors.mediumGrey,
                            ),
                            cursorColor: LitColors.mediumGrey,
                            decoration: InputDecoration(
                              hintText: textEditingController!.text.isEmpty
                                  ? '${RemainingLifetimeLocalizations.of(context)!.addAnAchievement} ...'
                                  : '',
                              hintStyle: LitTextStyles.sansSerif.copyWith(
                                fontSize: 16.0,
                                color: darkMode!
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

  @override
  CollapsibleCardController get controller => this.collapsibleCardController!;
}
