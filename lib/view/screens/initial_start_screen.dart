import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/model/app_settings.dart';
import 'package:remaining_lifetime/view/screens/introduction_to_remaining_lifetime_screen.dart';

/// A [StatefulWidget] displaying the first screens the user is required to see
/// before using the app.
///
/// Depending on the current database state, the user has to agree the privacy
/// policy first.
class InitialStartInformation extends StatefulWidget {
  final Box<dynamic> appSettingsBox;

  /// Creates an [InitialStartInformation] screen.
  const InitialStartInformation({Key key, @required this.appSettingsBox})
      : super(key: key);
  @override
  _InitialStartInformationState createState() =>
      _InitialStartInformationState();
}

class _InitialStartInformationState extends State<InitialStartInformation>
    with TickerProviderStateMixin {
  final Duration titleScreenDuration = Duration(milliseconds: 3000);
  AnimationController _onStartAnimationController;
  bool skippedInstructions;
  void createAppSettings(Box<dynamic> appSettingsBox) {
    AppSettings appSettings =
        AppSettings(agreedPrivacy: true, animated: true, darkMode: false);
    appSettingsBox.add(appSettings);
  }

  void initAnimation() {
    _onStartAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
  }

  void disposeAnimation() {
    _onStartAnimationController.dispose();
  }

  void handleOnStart() {
    _onStartAnimationController.forward().then(
          (value) => setState(
            () {
              skippedInstructions = true;
            },
          ),
        );
  }

  Future<bool> handleOnPop() async {
    setState(() {
      skippedInstructions = false;
    });
    return false;
  }

  @override
  void initState() {
    super.initState();
    skippedInstructions = false;
    initAnimation();
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return skippedInstructions
        ? WillPopScope(
            onWillPop: handleOnPop,
            child:

                //TODO implement privacy screen
                // PrivacyAgreementScreen(
                //   agreeLabel:
                //       "${RemainingLifetimeLocalizations.of(context).iAgree}",
                //   privacyText:
                //       "${RemainingLifetimeLocalizations.of(context).privacyDescription}",
                //   title: "${RemainingLifetimeLocalizations.of(context).privacy}",
                //   privacyTags: [
                //     PrivacyTag(
                //         text: RemainingLifetimeLocalizations.of(context).private,
                //         isConform: true),
                //     PrivacyTag(
                //         text: RemainingLifetimeLocalizations.of(context).noSignUp,
                //         isConform: true),
                //   ],
                //   launcherIconImageUrl:
                //       "assets/images/Remaining_Lifetime_App_Launcher_Icon_Rounded.png",
                //   onAgreeCallback: () => createAppSettings(widget.appSettingsBox),
                // ),
                Scaffold(
              body: Center(
                child: ElevatedButton(
                  child: Text("Accept privacy"),
                  onPressed: () => createAppSettings(widget.appSettingsBox),
                ),
              ),
            ))
        : FutureBuilder(
            future: Future.delayed(titleScreenDuration),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ?

                  // IntroductionToRemainingLifetimeScreen(
                  //     handleOnStart: handleOnStart,
                  //     onStartAnimationController: _onStartAnimationController,
                  //   )
                  //TODO Make Instruction screen accessible from profile screen
                  Scaffold(
                      body: Center(
                        child: ElevatedButton(
                          onPressed: handleOnStart,
                          child: Text("Continue"),
                        ),
                      ),
                    )
                  : TitleScreen(
                      animationDuration: titleScreenDuration,
                      titleImageName:
                          "assets/images/Lit_Life_Software_Light_No_Spacing.png",
                      credits: "a product of LitLifeSoftware",
                    );
            },
          );
  }
}
