import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectUtil {
  late InputImageRotation rotation;
  late FaceDetector faceDetector;
  int width = 0;
  FaceDetectUtil({required this.rotation, required this.faceDetector});

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();

    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }

    width = planes[0].bytesPerRow;
    return allBytes.done().buffer.asUint8List();
  }

  InputImageData buildMetaData(CameraImage image) {
    InputImageFormat inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    //Data of image required when creating image from bytes.
    return InputImageData(
      inputImageFormat: inputImageFormat,
      size: Size(width.toDouble(), image.height.toDouble()),
      imageRotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }

  // Main Detect
  // Send picture get all point in face
  Future<List<Face>> detect(
    CameraImage image,
  ) {
    // Create input image
    final inputImage = InputImage.fromBytes(
      bytes: concatenatePlanes(image.planes),
      inputImageData: buildMetaData(image),
    );
    // detect face
    return faceDetector.processImage(inputImage);
  }
}
