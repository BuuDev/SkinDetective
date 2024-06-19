import 'package:flutter/material.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/picture/picture.dart';

class CameraProvider with ChangeNotifier {
  late List<Picture> _pictures = [];
  List<Picture> get pictures => _pictures;
  late ETypeFace _typeFace = ETypeFace.Face;
  ETypeFace get typeFace => _typeFace;
  late bool _isReTake = false;
  bool get isReTake => _isReTake;

  // Chụp lại bước hiện tại
  void setReTake(bool isReTake) {
    _isReTake = isReTake;
    if (typeFace == ETypeFace.Face) {
      _typeFace = ETypeFace.Face;
    } else if (typeFace == ETypeFace.FaceLeft) {
      _typeFace = ETypeFace.FaceLeft;
    } else if (typeFace == ETypeFace.FaceRight) {
      _typeFace = ETypeFace.FaceRight;
    }
    notifyListeners();
  }

  void setRestartCamera() {
    _pictures = [];
    _typeFace = ETypeFace.Face;
    _isReTake = false;
    notifyListeners();
  }

  // Lưu lại ảnh vào list.
  void saveCapture(Picture pictureModel) {
    _pictures.add(pictureModel);
    notifyListeners();
  }

  // B1. call face
  void startFace() {
    _typeFace = ETypeFace.Face;
    // notifyListeners();
  }

  // B2: quay qua bên phải chụp bên mặt trái
  void startStreamLeft() {
    _typeFace = ETypeFace.FaceLeft;
    // notifyListeners();
  }

  // B3: quay qua bên trái chụp bên mặt phải
  void startStreamRight() {
    _typeFace = ETypeFace.FaceRight;
    // notifyListeners();
  }

  // B4: Kết thúc
  void doneCapture() {
    _typeFace = ETypeFace.DONE;
    notifyListeners();
    setRestartCamera();
    // notifyListeners();
  }
}

enum ETypeFace {
  // ignore: constant_identifier_names
  Face,
  // ignore: constant_identifier_names
  FaceLeft, // Mặt left
  // ignore: constant_identifier_names
  FaceRight, // Mặt left
  // ignore: constant_identifier_names
  DONE,
}

extension ExTypeFace on ETypeFace {
  String get imageTypeFace {
    switch (this) {
      case ETypeFace.Face:
        return Assets.icons.frontalFacePopyline;
      case ETypeFace.FaceLeft:
        return Assets.icons.leftFacePopyline;
      case ETypeFace.FaceRight:
        return Assets.icons.rightFacePopyline;
      default:
        return '';
    }
  }
}
