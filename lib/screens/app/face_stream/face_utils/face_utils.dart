import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

String getTitleDialog(ETypeFace typeFace) {
  if (typeFace == ETypeFace.FaceLeft) {
    return LocaleKeys.faceLeft;
  } else if (typeFace == ETypeFace.FaceRight) {
    return LocaleKeys.faceRight;
  } else {
    return LocaleKeys.faceCenter;
  }
}

final Map<String, String> directionTranslate = {
  'FaceContour_no_face_detected': LocaleKeys.faceContourNoFaceDetected,
  'FaceContour_camera_brightness': LocaleKeys.faceContourCameraBrightness,
  'FaceContour_camera_farther': LocaleKeys.faceContourCameraFarther,
  'FaceContour_camera_closer': LocaleKeys.faceContourCameraCloser,
  'FaceContour_camera_right_left': LocaleKeys.faceContourCameraRightLeft,
  'FaceContour_camera_stay_still': LocaleKeys.faceContourCameraStayStill,
  'FaceContour_camera_center': LocaleKeys.faceContourCameraCenter,
  'Hold_phone_still_turn_head_left': LocaleKeys.holdPhoneStillTurnHeadLeft,
  'Hold_phone_still_turn_head_right': LocaleKeys.holdPhoneStillTurnHeadRight,
  'Face_not_found': LocaleKeys.faceNotFound
};

String getFaceTransMes(String key) {
  return directionTranslate[key] ?? '';
}

Offset getPointCenter(
    {required Offset p1, required Offset p2, Offset? padding}) {
  padding = padding ?? const Offset(0.0, 0.0);
  double dx = (padding.dx + p1.dx + p2.dx) / 2;
  double dy = (padding.dy + p1.dy + p2.dy) / 2;
  return Offset(dx, dy);
}

double getLengthPoint({required Offset p1, required Offset p2}) {
  double d = sqrt(pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2));
  return d;
}

Offset getPlusPoint({required Offset p1, required Offset p2}) {
  return Offset(p1.dx + p2.dx, p1.dy + p2.dy);
}

Offset getMinusPoint(Offset point1, Offset point2) {
  return Offset(point1.dx - point2.dx, point1.dy - point2.dy);
}

num degToRad(num deg) => deg * (pi / 180.0);
