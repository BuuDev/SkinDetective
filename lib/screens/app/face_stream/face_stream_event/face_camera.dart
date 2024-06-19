import 'package:google_ml_kit/google_ml_kit.dart';

class FaceCamera {
  late List<Face>? face;
  late String cameraMessage;
  late bool isDetecting;
  late String? takePictureState;

  late bool? cameraBrightNess;
  late bool? cameraDistance;
  late bool? cameraPosition;

  FaceCamera({
    required this.face,
    required this.cameraMessage,
    required this.isDetecting,
    this.takePictureState,
  }) : super() {
    takePictureState = takePictureState ?? "wait";
  }

  @override
  String toString() {
    return "FaceCamera $face $cameraMessage $isDetecting";
  }
}
