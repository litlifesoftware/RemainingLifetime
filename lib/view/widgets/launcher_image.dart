import 'package:flutter/material.dart';

/// A widget displaying the apps launcher image on a simple [Container].

class LauncherImage extends StatelessWidget {
  /// Creates a [LauncherImage].
  const LauncherImage({
    Key? key,
    this.launcherPath = "assets/images/Launcher_Icon_Static_Rounded_25per.png",
    this.size = 128.0,
  }) : super(key: key);

  /// The launcher image's path.
  final String launcherPath;

  /// The size the image should have. This value does account for both
  /// dimensions (width and height).
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Image(
        image: AssetImage(launcherPath),
      ),
    );
  }
}
