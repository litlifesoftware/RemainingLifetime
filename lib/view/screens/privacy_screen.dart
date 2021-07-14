import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:lit_ui_kit/screens.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({
    Key? key,
    this.onConfirm,
  }) : super(key: key);
  final void Function()? onConfirm;

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  void _navigateBack() {
    LitRouteController(context).navigateBack();
  }

  @override
  Widget build(BuildContext context) {
    return LitPrivacyDisclaimerScreen(
      nextButtonLabel: RemainingLifetimeLocalizations.of(context)!.next,
      textItems: [
        TextPageContent(
          title: RemainingLifetimeLocalizations.of(context)!.privacy!,
          subtitle: RemainingLifetimeLocalizations.of(context)!.yourDataIsSafe!,
          text: RemainingLifetimeLocalizations.of(context)!
              .privacyDescriptionOne!,
        ),
        TextPageContent(
          title: RemainingLifetimeLocalizations.of(context)!.privacy!,
          subtitle: RemainingLifetimeLocalizations.of(context)!.yourDataIsSafe!,
          text: RemainingLifetimeLocalizations.of(context)!
              .privacyDescriptionTwo!,
        ),
        TextPageContent(
          title: RemainingLifetimeLocalizations.of(context)!.privacy!,
          subtitle: RemainingLifetimeLocalizations.of(context)!.yourDataIsSafe!,
          text: RemainingLifetimeLocalizations.of(context)!
              .privacyDescriptionThree!,
        ),
      ],
      onConfirm: widget.onConfirm ?? _navigateBack,
    );
  }
}
