import 'package:flutter/material.dart';
import 'package:lit_ui_kit/dialogs.dart';
import 'package:remaining_lifetime/view/widgets/launcher_image.dart';

class AboutThisAppDialog extends StatelessWidget {
  const AboutThisAppDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutAppDialog(
      appName: "Remaining Lifetime",
      art: LauncherImage(
        size: 64.0,
      ),
      infoDescription: "Make every month count!",
    );
  }
}
