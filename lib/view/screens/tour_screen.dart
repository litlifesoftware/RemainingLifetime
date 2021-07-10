import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:lit_ui_kit/screens.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/view/widgets/launcher_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _onExit() {
    LitRouteController(context).navigateBack();
  }

  @override
  Widget build(BuildContext context) {
    return LitOnboardingScreen(
      cardPadding: const EdgeInsets.only(top: 192.0),
      art: Padding(
        padding: const EdgeInsets.only(bottom: 64.0),
        child: LauncherImage(size: 180.0),
      ),
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xffD4D7E8),
            Color(0xFF204a62),
          ],
        ),
      ),
      onExit: _onExit,
      title: RemainingLifetimeLocalizations.of(context)!.introduction!,
      nextButtonLabel: RemainingLifetimeLocalizations.of(context)!.next,
      textItems: [
        OnboardingText(
          text:
              RemainingLifetimeLocalizations.of(context)!.visualizeDescription!,
          title: RemainingLifetimeLocalizations.of(context)!.visualize!,
        ),
        OnboardingText(
          text:
              RemainingLifetimeLocalizations.of(context)!.keepTrackDescription!,
          title: RemainingLifetimeLocalizations.of(context)!.keepTrack!,
        ),
        OnboardingText(
          text: RemainingLifetimeLocalizations.of(context)!.startDescription!,
          title: RemainingLifetimeLocalizations.of(context)!.start!,
        ),
      ],
    );
  }
}
