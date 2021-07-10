import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:lit_ui_kit/screens.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  void _onAgree() {
    LitRouteController(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return LitPrivacyPolicyScreen(
      privacyText:
          RemainingLifetimeLocalizations.of(context)!.privacyDescription!,
      title: RemainingLifetimeLocalizations.of(context)!.private!,
      onAgreeCallback: _onAgree,
      privacyTags: [
        PrivacyTag(
          text: RemainingLifetimeLocalizations.of(context)!.private!,
          isConform: true,
        ),
        PrivacyTag(
          text: RemainingLifetimeLocalizations.of(context)!.offline!,
          isConform: true,
        ),
      ],
    );
  }
}
