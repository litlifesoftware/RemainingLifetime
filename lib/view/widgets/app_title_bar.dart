import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class AppTitleBar extends StatelessWidget {
  final String thisIsLabel;
  final String appName;
  final Color backgroundColor;
  const AppTitleBar({
    Key key,
    @required this.thisIsLabel,
    @required this.appName,
    @required this.backgroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BluredBackgroundContainer(
      borderRadius: BorderRadius.circular(
        32.0,
      ),
      blurRadius: 3.0,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            32.0,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: thisIsLabel,
                    style: LitTextStyles.sansSerif.copyWith(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
                TextSpan(
                    text: " $appName",
                    style: LitTextStyles.sansSerif.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                    ))
              ]),
            )),
      ),
    );
  }
}
