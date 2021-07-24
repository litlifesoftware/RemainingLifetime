import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:remaining_lifetime/controller/localization/remaining_lifetime_localizations.dart';
import 'package:remaining_lifetime/model/user_data.dart';

/// A dialog widget allowing to pick a color.
///
/// The initial color value is derived from the provided [UserData] object.
class ColorPickerDialog extends StatelessWidget {
  /// Creates a [ColorPickerDialog].
  const ColorPickerDialog({
    Key? key,
    required this.userData,
    required this.onApplyColor,
  }) : super(key: key);

  /// The user data storing the user's color.
  final UserData userData;

  /// Returns the edited color back to the parent widget.
  final void Function(Color color) onApplyColor;

  @override
  Widget build(BuildContext context) {
    return LitColorPickerDialog(
      initialColor: Color(userData.color!),
      onApplyColor: onApplyColor,
      applyLabel: RemainingLifetimeLocalizations.of(context)!.apply,
      resetLabel: RemainingLifetimeLocalizations.of(context)!.cancel,
      titleText: RemainingLifetimeLocalizations.of(context)!.chooseColor,
      transparentColorText:
          RemainingLifetimeLocalizations.of(context)!.colorFullyTransparent,
    );
  }
}
