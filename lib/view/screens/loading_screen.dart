import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A screen widgets displayed as long as data is being fetched.
class LoadingScreen extends StatelessWidget {
  /// Creates a [LoadingScreen].
  const LoadingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: const [
              LitColors.mediumGrey,
              LitColors.darkBlue,
            ],
          ),
        ),
        child: Center(
          child: _InfoIcon(),
        ),
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.0,
      width: 64.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(-2, 2),
            blurRadius: 4.0,
            color: Colors.black26,
            spreadRadius: -1.0,
          )
        ],
        color: LitColors.mediumGrey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Icon(
            LitIcons.info,
            size: 24.0,
            color: LitColors.lightGrey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
