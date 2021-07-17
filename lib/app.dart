import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:remaining_lifetime/view/widgets/database_state_screen_builder.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'controller/localization/remaining_lifetime_localizations_delegate.dart';

/// Creates an [App].
///
/// It will be the entry point of this application.
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The set of [Image]s used throughout the app.
  late List<String> assetImages;

  @override
  void initState() {
    super.initState();
    assetImages = [
      "assets/images/Remaining_Lifetime_App_Launcher_Icon_Rounded.png",
      "assets/images/Lit_Life_Software_Dark.png",
      "assets/images/Lit_Life_Software_Light.png",
      "assets/images/Lit_Life_Software_Dark_No_Spacing.png",
      "assets/images/Lit_Life_Software_Light_No_Spacing.png",
      "assets/images/Meteoroid.png",
      "assets/images/Planet.png",
      "assets/images/Launcher_Icon_Static_Rounded_2.png"
    ];
    ImageCacheController(
      context: context,
      assetImages: assetImages,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remaining Lifetime',
      color: LitColors.darkBlue,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        RemainingLifetimeLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Supported languages
      supportedLocales: [
        // English (no contry code)
        const Locale('en', ''),
        // German (no contry code)
        const Locale('de', ''),
        // Russian (no contry code)
        const Locale('ru', ''),
      ],
      home: DatabaseStateScreenBuilder(),
      theme: ThemeData(
        accentColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
