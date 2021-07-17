import 'package:flutter/material.dart';
import 'package:lit_ui_kit/dialogs.dart';
import 'package:remaining_lifetime/view/widgets/launcher_image.dart';

/// A dialog widget displaying informations about the `Remaining Lifetime`
/// app.
///
/// It uses the [LitAboutDialog].
class AboutAppDialog extends StatelessWidget {
  /// Creates a [AboutAppDialog].
  const AboutAppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitAboutDialog(
      appName: "Remaining Lifetime",
      art: LauncherImage(
        size: 64.0,
      ),
      infoDescription: "Make every month count!",
    );
  }
}
