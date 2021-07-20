import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:lit_ui_kit/screens.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';

/// A screen widgets implementing the [LitPrivacyDisclaimerScreen] to inform
/// the user about the app's privacy.
///
/// The [onConfirm] defaults to navigate back, once the 'confirm' button is
/// pressed.
class PrivacyScreen extends StatefulWidget {
  /// Creates a [PrivacyScreen].
  const PrivacyScreen({
    Key? key,
    this.onConfirm,
  }) : super(key: key);

  /// Handles the action once the 'confirm' button is pressed.
  /// This will either be used to:
  /// - navigate back (default, if none value was provided)
  /// - call a custom function (e.g. to initialize the database)
  final void Function()? onConfirm;

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  /// Navigates back to the previous screen.
  void _navigateBack() {
    LitRouteController(context).navigateBack();
  }

  @override
  Widget build(BuildContext context) {
    return LitPrivacyDisclaimerScreen(
      nextButtonLabel: RemainingLifetimeLocalizations.of(context)!.next,
      textItems: [
        TextPageContent(
          title: RemainingLifetimeLocalizations.of(context)!.offline!,
          subtitle: RemainingLifetimeLocalizations.of(context)!.yourDataIsSafe!,
          text: RemainingLifetimeLocalizations.of(context)!
              .privacyDescriptionOne!,
        ),
        TextPageContent(
          title: RemainingLifetimeLocalizations.of(context)!.private!,
          subtitle: RemainingLifetimeLocalizations.of(context)!.yourDataIsSafe!,
          text: RemainingLifetimeLocalizations.of(context)!
              .privacyDescriptionTwo!,
        ),
        TextPageContent(
          title: RemainingLifetimeLocalizations.of(context)!.info,
          subtitle: RemainingLifetimeLocalizations.of(context)!.yourDataIsSafe!,
          text: RemainingLifetimeLocalizations.of(context)!
              .privacyDescriptionThree!,
        ),
      ],
      onConfirm: widget.onConfirm ?? _navigateBack,
    );
  }
}
