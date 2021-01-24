import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'remaining_lifetime_localizations.dart';

/// A controller class used as delegate for the [RemainingLifetimeLocalizations] class.
///
/// It will initially load the [String]s contained in the JSON file into the asset bundle
/// on start up.
class RemainingLifetimeLocalizationsDelegate
    extends LocalizationsDelegate<RemainingLifetimeLocalizations> {
  const RemainingLifetimeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'de', 'ru'].contains(locale.languageCode);

  @override
  Future<RemainingLifetimeLocalizations> load(Locale locale) async {
    SynchronousFuture<RemainingLifetimeLocalizations> localizations;

    /// Initialize the [RemainingLifetimeLocalizations].
    localizations = SynchronousFuture<RemainingLifetimeLocalizations>(
        RemainingLifetimeLocalizations(locale));

    /// Load the content of the file.
    await localizations
      ..loadFromAsset();

    /// Return the [RemainingLifetimeLocalizations].
    return localizations;
  }

  @override
  bool shouldReload(RemainingLifetimeLocalizationsDelegate old) => false;
}
