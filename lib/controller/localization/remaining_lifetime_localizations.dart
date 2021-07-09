import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// A controller class to retrieve all localized [String]s specific to the Remaining Lifetime app from the
/// corresponding JSON file found in the asset bundle.
class RemainingLifetimeLocalizations {
  /// The device's [Locale].
  final Locale locale;

  const RemainingLifetimeLocalizations(this.locale);

  /// Returns the [RemainingLifetimeLocalizations] found in the [BuildContext].
  static RemainingLifetimeLocalizations? of(BuildContext context) {
    return Localizations.of<RemainingLifetimeLocalizations>(
        context, RemainingLifetimeLocalizations);
  }

  /// The localized phrases, names and sentences used in the
  /// app.
  static Map<String, dynamic>? localizedStrings;

  /// Initializes the localizations.
  ///
  /// Loads the JSON file from the "localization" folder and
  /// decodes the [String] into a [Map] to initalize the
  /// [localizedStrings] object.
  Future<bool> loadFromAsset() async {
    String jsonString = await rootBundle
        .loadString('assets/localization/localized_strings.json');
    localizedStrings = jsonDecode(jsonString);
    return true;
  }

  String? get spent {
    return localizedStrings!['spent'][locale.languageCode];
  }

  String? get remaining {
    return localizedStrings!['remaining'][locale.languageCode];
  }

  String? get myDateOfBirth {
    return localizedStrings!['my_date_of_birth'][locale.languageCode];
  }

  String? get addAnAchievement {
    return localizedStrings!['add_an_achievement_on'][locale.languageCode];
  }

  String? get mightBeYourLastMonth {
    return localizedStrings!['might_be_your_last_month'][locale.languageCode];
  }

  String? get settings {
    return localizedStrings!['settings'][locale.languageCode];
  }

  String? get animations {
    return localizedStrings!['animations'][locale.languageCode];
  }

  String? get darkMode {
    return localizedStrings!['dark_mode'][locale.languageCode];
  }

  String? get aboutThisApp {
    return localizedStrings!['about_this_app'][locale.languageCode];
  }

  String? get licenses {
    return localizedStrings!['licenses'][locale.languageCode];
  }

  String? get privacy {
    return localizedStrings!['privacy'][locale.languageCode];
  }

  String? get privacyDescription {
    return localizedStrings!['privacy_description'][locale.languageCode];
  }

  String? get iAgree {
    return localizedStrings!['i_agree'][locale.languageCode];
  }

  String? get turnedOn {
    return localizedStrings!['turned_on'][locale.languageCode];
  }

  String? get turnedOff {
    return localizedStrings!['turned_off'][locale.languageCode];
  }

  String? get achievementSaved {
    return localizedStrings!['achievement_saved'][locale.languageCode];
  }

  String? get setYourDayOfBirth {
    return localizedStrings!['set_your_day_of_birth'][locale.languageCode];
  }

  String? get month {
    return localizedStrings!['month'][locale.languageCode];
  }

  String? get year {
    return localizedStrings!['year'][locale.languageCode];
  }

  String? get continueWithThisDayOfBirth {
    return localizedStrings!['continue_with_this_day_of_birth']
        [locale.languageCode];
  }

  String? get youAreNotOldEnoughToUseThisApp {
    return localizedStrings!['you_are_not_old_enough_to_use_this_app']
        [locale.languageCode];
  }

  String? get changeTheMonthToApplyThisDate {
    return localizedStrings!['change_the_month_to_apply_this_date']
        [locale.languageCode];
  }

  String? get visualize {
    return localizedStrings!['visualize'][locale.languageCode];
  }

  String? get visualizeDescription {
    return localizedStrings!['visualize_description'][locale.languageCode];
  }

  String? get keepTrack {
    return localizedStrings!['keep_track'][locale.languageCode];
  }

  String? get keepTrackDescription {
    return localizedStrings!['keep_track_description'][locale.languageCode];
  }

  String? get start {
    return localizedStrings!['start'][locale.languageCode];
  }

  String? get startDescription {
    return localizedStrings!['start_description'][locale.languageCode];
  }

  String? get getMeStarted {
    return localizedStrings!['get_me_started'][locale.languageCode];
  }

  String? get thisIs {
    return localizedStrings!['this_is'][locale.languageCode];
  }

  String? get private {
    return localizedStrings!['private'][locale.languageCode];
  }

  String? get noSignUp {
    return localizedStrings!['no_sign_up'][locale.languageCode];
  }

  String? get introduction {
    return localizedStrings!['introduction'][locale.languageCode];
  }

  String get yourAge {
    return localizedStrings!['your_age'][locale.languageCode];
  }

  String get yourColor {
    return localizedStrings!['your_color'][locale.languageCode];
  }

  String get change {
    return localizedStrings!['change'][locale.languageCode];
  }

  String get monthsRemaining {
    return localizedStrings!['months_remaining'][locale.languageCode];
  }

  String get monthsSpent {
    return localizedStrings!['months_spent'][locale.languageCode];
  }

  String get tour {
    return localizedStrings!['tour'][locale.languageCode];
  }

  String get advanced {
    return localizedStrings!['advanced'][locale.languageCode];
  }
}
