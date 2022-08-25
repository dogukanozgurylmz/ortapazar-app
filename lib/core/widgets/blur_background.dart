import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBackgroundWidget extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final double borderRadius;

  const BlurBackgroundWidget(
      {Key? key,
      required this.blur,
      required this.opacity,
      required this.child,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(opacity),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            border: Border.all(
              width: 0,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
