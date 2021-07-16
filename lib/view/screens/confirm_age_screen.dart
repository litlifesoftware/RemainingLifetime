import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';

/// A screen widget allowing the user to submit his age.
///
/// The age will be used to verify whether the user passes the minimum age
/// requried to use this app and to create the initial user data.
class ConfirmAgeScreen extends StatelessWidget {
  /// A callback excuted once the 'onSubmit' button is pressed.
  final void Function(DateTime age) onSubmit;

  /// Creates a [ConfirmAgeScreen].
  const ConfirmAgeScreen({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitConfirmAgeScreen(
      chooseDateLabel: RemainingLifetimeLocalizations.of(context)!.chooseDate,
      setLabel: RemainingLifetimeLocalizations.of(context)!.set,
      submitLabel: RemainingLifetimeLocalizations.of(context)!.submit,
      title: RemainingLifetimeLocalizations.of(context)!.confirmYourAge,
      subtitle:
          RemainingLifetimeLocalizations.of(context)!.confirmYourAgeSubtitle,
      yourAgeLabel: RemainingLifetimeLocalizations.of(context)!.yourAge,
      onSubmit: onSubmit,
      invalidAgeText: "",
      validLabel: RemainingLifetimeLocalizations.of(context)!.valid,
    );
  }
}
