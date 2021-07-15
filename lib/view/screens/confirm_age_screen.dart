import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';

class ConfirmAgeScreen extends StatelessWidget {
  final void Function(DateTime age) onSubmit;
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
