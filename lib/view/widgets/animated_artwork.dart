import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedArtwork extends StatefulWidget {
  final AnimationController onStartAnimationController;
  const AnimatedArtwork({
    Key? key,
    required this.onStartAnimationController,
  }) : super(key: key);
  @override
  _AnimatedArtworkState createState() => _AnimatedArtworkState();
}

class _AnimatedArtworkState extends State<AnimatedArtwork>
    with TickerProviderStateMixin {
  late AnimationController _appearAnimationController;
  late AnimationController _repeatAnimationController;
  void initAnimation() {
    _appearAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    _repeatAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 2000,
      ),
    );

    _appearAnimationController.forward();
    _repeatAnimationController.repeat(reverse: true);
  }

  void disposeAnimation() {
    _appearAnimationController.dispose();
    _repeatAnimationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appearAnimationController,
      builder: (BuildContext context, Widget? _) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Transform(
                transform: Matrix4.translationValues(
                    200 + (-200 * _appearAnimationController.value), 0, 0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1.3,
                    child: AnimatedBuilder(
                      animation: _repeatAnimationController,
                      builder: (BuildContext context, Widget? _) {
                        return Transform(
                            transform: Matrix4.translationValues(
                              120.0,
                              (_repeatAnimationController.value) * 10.0,
                              0,
                            ),
                            child: AnimatedBuilder(
                              animation: widget.onStartAnimationController,
                              builder: (BuildContext context, Widget? _) {
                                return Transform.scale(
                                  scale: 1.0 +
                                      (widget.onStartAnimationController.value *
                                          1.3),
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/Planet.png",
                                    ),
                                  ),
                                );
                              },
                            ));
                      },
                    )),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Transform(
                transform: Matrix4.translationValues(
                    0, -200 + (200 * _appearAnimationController.value), 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: AnimatedBuilder(
                    animation: _repeatAnimationController,
                    builder: (BuildContext context, Widget? _) {
                      return Transform(
                        transform: Matrix4.translationValues(
                          25.0,
                          50.0 + (1 - (_repeatAnimationController.value) * 5.0),
                          0,
                        ),
                        child: Transform.rotate(
                            angle: -((2 * pi) / 360 * 5) *
                                (1 - _repeatAnimationController.value),
                            child: AnimatedBuilder(
                              animation: widget.onStartAnimationController,
                              builder: (BuildContext context, Widget? _) {
                                return Transform.rotate(
                                  angle: (((2 * pi / 360) * 80) *
                                      widget.onStartAnimationController.value),
                                  child: Transform(
                                    transform: Matrix4.translationValues(
                                        (-MediaQuery.of(context).size.width *
                                            widget.onStartAnimationController
                                                .value),
                                        (150 *
                                            widget.onStartAnimationController
                                                .value),
                                        0),
                                    child: Image(
                                      image: AssetImage(
                                        "assets/images/Meteoroid.png",
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
