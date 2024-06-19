import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TransformWidget extends StatelessWidget {
  late CameraLensDirection lensDirection;
  late Widget child;
  // ignore: use_key_in_widget_constructors
  TransformWidget({required this.lensDirection, required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(
          lensDirection == CameraLensDirection.front ? pi : 0,
        ),
        child: child);
  }
}
