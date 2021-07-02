// import 'package:flutter/material.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';
// import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
// import 'package:remaining_lifetime/view/widgets/animated_artwork.dart';
// import 'package:remaining_lifetime/view/widgets/app_title_bar.dart';

// class IntroductionToRemainingLifetimeScreen extends StatefulWidget {
//   final AnimationController onStartAnimationController;
//   final void Function() handleOnStart;

//   const IntroductionToRemainingLifetimeScreen(
//       {Key key, this.onStartAnimationController, this.handleOnStart})
//       : super(key: key);

//   @override
//   _IntroductionToRemainingLifetimeScreenState createState() =>
//       _IntroductionToRemainingLifetimeScreenState();
// }

// class _IntroductionToRemainingLifetimeScreenState
//     extends State<IntroductionToRemainingLifetimeScreen>
//     with TickerProviderStateMixin {
//   AnimationController _onStartAnimationController;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.onStartAnimationController != null) {
//       _onStartAnimationController = widget.onStartAnimationController;
//     } else {
//       _onStartAnimationController = AnimationController(
//         vsync: this,
//         duration: Duration(
//           milliseconds: 450,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//         onStartButtonBorderColor: HexColor('#B3B3B3'),
//         onStartButtonText:
//             "${RemainingLifetimeLocalizations.of(context).getMeStarted}",
//         artwork: AnimatedArtwork(
//             onStartAnimationController: _onStartAnimationController),
//         backgroundColor: HexColor('#0B222F'),
//         appTitle: AppTitleBar(
//           backgroundColor: LitColors.mediumGrey.withOpacity(0.5),
//           appName: "Remaining Lifetime",
//           thisIsLabel: "${RemainingLifetimeLocalizations.of(context).thisIs}",
//         ),
//         instructionCards: [
//           InstructionCard(
//             title: Text(
//               "${RemainingLifetimeLocalizations.of(context).visualize}",
//               style: LitTextStyles.sansSerif.copyWith(
//                 color: Colors.white,
//                 fontSize: 24.0,
//               ),
//             ),
//             description:
//                 "${RemainingLifetimeLocalizations.of(context).visualizeDescription}",
//             descriptionTextStyle:
//                 LitTextStyles.sansSerif.copyWith(color: Colors.white),
//           ),
//           InstructionCard(
//             title: Text(
//               "${RemainingLifetimeLocalizations.of(context).keepTrack}",
//               style: LitTextStyles.sansSerif.copyWith(
//                 color: Colors.white,
//                 fontSize: 24.0,
//               ),
//             ),
//             description:
//                 "${RemainingLifetimeLocalizations.of(context).keepTrackDescription}",
//             descriptionTextStyle:
//                 LitTextStyles.sansSerif.copyWith(color: Colors.white),
//           ),
//           InstructionCard(
//             title: Text(
//               "${RemainingLifetimeLocalizations.of(context).start}",
//               style: LitTextStyles.sansSerif.copyWith(
//                 color: Colors.white,
//                 fontSize: 24.0,
//               ),
//             ),
//             description:
//                 "${RemainingLifetimeLocalizations.of(context).startDescription}",
//             descriptionTextStyle:
//                 LitTextStyles.sansSerif.copyWith(color: Colors.white),
//           ),
//         ],
//         onStartCallback: widget.handleOnStart);
//   }
// }
