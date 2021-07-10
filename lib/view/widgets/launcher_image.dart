import 'package:flutter/material.dart';

class LauncherImage extends StatelessWidget {
  final String launcherPath;
  final double size;
  const LauncherImage({
    Key? key,
    this.launcherPath = "assets/images/Launcher_Icon_Static_Rounded_2.png",
    this.size = 128.0,
  }) : super(key: key);

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
