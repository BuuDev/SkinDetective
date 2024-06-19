//TODO: Utils Handle detect face and check some issues
// Flow:
// 1. Start stream -> filter point get face (50 -> 200) (60 frame/s) -> cập nhật isDetected (Còn lại 1 frame xử lý) -> firebase face detection.
// 2. Check độ sáng(Chuyển ảnh sang grayscale > 80) -> Check distance(kích thước khuôn mặt)
// 3. Check quay trái quay phải (thông qua mắt trái và mắt phải).
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:skin_detective/screens/app/face_stream/face_stream_event/face_camera.dart';
import 'package:skin_detective/screens/app/face_stream/face_utils/face_detect_util.dart';
import 'package:skin_detective/services/api_client.dart';

class FaceStreamEvent {
  late CameraController? cameraController;
  late FaceDetectUtil faceDetectUtil;

  double gs = 0;
  int grayScale = 0;

  late final bool _isDebug = false; // auto stream
  bool get isDebug => _isDebug;

  late Timer? _timer;

  FaceStreamEvent(
      {required this.cameraController, required this.faceDetectUtil})
      : super() {
    // Bắt đầu stream
    _timer = null;
  }

  final FaceCamera _faceCamera =
      FaceCamera(face: null, cameraMessage: "", isDetecting: false);

  FaceCamera get faceCamera => _faceCamera;

  StreamController<FaceCamera> faceStreamController =
      StreamController<FaceCamera>.broadcast();

  Stream<FaceCamera> get faceStream => faceStreamController.stream;

  void setStreamIfMounted(f) {
    // Nếu đang chạy thì clear đi. tránh trường hợp chạy song song.
    // 1 lần chạy chỉ được 1 timer.
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer?.cancel();
      }
    }

    _timer = Timer(
        Duration(
            milliseconds: ClientApi.mode() == EnvironmentMode.dev ? 1000 : 500),
        () {
      if (!_isDebug) {
        _faceCamera.isDetecting = false;
      }
      if (!faceStreamController.isClosed) {
        faceStreamController.sink.add(f);
      }
    });
  }

  Future<void> runStreamCamera() async {
    debugPrint("In File: face_stream_event.dart, Line: 59 START STREAM ");
    cameraController!.startImageStream((image) {
      // call per frame
      _processCameraImage(image);
    });
  }

  void _processCameraImage(CameraImage image) async {
    // Mỗi lần chỉ xử lý 1 frame
    if (_faceCamera.isDetecting) return;
    _faceCamera.isDetecting = true;
    // planes: mô trả bố cục của pixel trong mặt phẳng đó.
    var values = image.planes[0].bytes;
    int count = 0, sum = 0;
    // value.length gần 9k mặt phẳng
    for (int i = 0; i < values.length; i++) {
      // Nếu pixel nằm trong khoảng 50 và 200.
      if (values[i] > 50 && values[i] < 200) {
        sum = sum + values[i];
        count = count + 1;
      }
    }

    gs = sum / count;
    _faceCamera.face = await faceDetectUtil.detect(image);

    // Lấy kích thước của widget camera.
    // Tạo lại 1 Size mới. với width = height camera, height = width camera
    debugPrint(
        "In File: face_stream_event.dart, Line: 100 ${_faceCamera.face!.length} ");
    // try {
    if (cameraController!.value.previewSize != null) {
      Size size = Size(
        cameraController!.value.previewSize!.height,
        cameraController!.value.previewSize!.width,
      );
      // Check nếu như không tìm thấy ai trong camera hoặc nhiều hơn 1 người
      if (_faceCamera.face!.isEmpty || _faceCamera.face!.length > 1) {
        _faceCamera.cameraMessage = 'FaceContour_no_face_detected';

        setStreamIfMounted(_faceCamera);
      } else {
        // Check độ sáng.
        checkBrightNess(_faceCamera.face!, size);
      }
    }
    // } catch (err) {
    //   debugPrint("In File: face_stream.dart, Line: 209 ${err} ");

    //   setStreamIfMounted(_faceCamera);
    // }
  }

  void checkBrightNess(List<Face> faces, Size size) {
    // try {
    if (gs.isInfinite || gs.isNaN) {
      _faceCamera.cameraBrightNess = false;

      setStreamIfMounted(_faceCamera);
    } else {
      grayScale = gs.toInt();
      if (grayScale < 80) {
        _faceCamera.cameraBrightNess = false;
        _faceCamera.cameraMessage = 'FaceContour_camera_brightness';

        setStreamIfMounted(_faceCamera);
      } else {
        _faceCamera.cameraBrightNess = true;
        faceCheck(faces[0], size);
      }
    }
    // } catch (err) {
    //   debugPrint("In File: face_stream_event.dart, Line: 141 ${err} ");

    //   setStreamIfMounted(_faceCamera);
    // }
  }

  void faceCheck(Face face, Size size) async {
    // 36 point
    // try {
    FaceContour? faceContour = face.getContour(FaceContourType.face);
    // debugPrint("In File: face_stream_event.dart, Line: 185 ${faceContour} ");
    if (faceContour != null) {
      List<Offset> facePoints = faceContour.positionsList;
      if (facePoints.isNotEmpty) {
        double faceWidth = 0, faceWidthPercent = 0;
        // double  faceHeight = 0,
        //******STEP 1: Calculate face width, height
        double minDx = size.width, maxDx = 0;
        double minDy = size.height, maxDy = 0;
        for (var i = 0; i < facePoints.length; i++) {
          if (facePoints[i].dx < minDx) minDx = facePoints[i].dx;
          if (facePoints[i].dx > maxDx) maxDx = facePoints[i].dx;

          if (facePoints[i].dy < minDy) minDy = facePoints[i].dy;
          if (facePoints[i].dy > maxDy) maxDy = facePoints[i].dy;
        }
        faceWidth = (maxDx - minDx).abs();
        faceWidthPercent = faceWidth * 100 / size.width;
        // faceHeight = (maxDy - minDy).abs();

        checkDistance(
            face: face,
            faceWidthPercent: faceWidthPercent,
            minDx: minDx,
            minDy: minDy,
            size: size,
            maxDx: maxDx,
            maxDy: maxDy);
      } else {
        setStreamIfMounted(_faceCamera);
      }
    } else {
      setStreamIfMounted(_faceCamera);
    }
    // } catch (err) {
    //   debugPrint("In File: face_stream_event.dart, Line: 182 ${err} ");
    //   setStreamIfMounted(_faceCamera);
    // }
  }

  void checkDistance(
      {face, faceWidthPercent, minDx, minDy, size, maxDx, maxDy}) {
    //******STEP 2: Display face distance message

    double faceWidthMinPercent = 65, faceWidthMaxPercent = 90;
    // Check xa hơn nếu
    if (faceWidthPercent > faceWidthMaxPercent) {
      _faceCamera.cameraMessage = 'FaceContour_camera_farther';
      _faceCamera.cameraDistance = false;
      setStreamIfMounted(_faceCamera);
      // Check gần hơn.
    } else if (faceWidthPercent < faceWidthMinPercent) {
      _faceCamera.cameraMessage = 'FaceContour_camera_closer';
      _faceCamera.cameraDistance = false;
      setStreamIfMounted(_faceCamera);
    } else {
      debugPrint("In File: live_camera.dart, Line: 266 ${"Khoảng cách OK"} ");
      _faceCamera.cameraDistance = true;
      _faceCamera.cameraMessage = 'FaceContour_camera_center';
      setStreamIfMounted(_faceCamera);
      double rightSide = minDx, leftSide = size.width - maxDx;
      // double topSide = minDy, bottomSide = size.height - maxDy;

      //if(rightSide > leftSide*2.5 || leftSide > rightSide*2.5)
      if (rightSide > leftSide * 4 || leftSide > rightSide * 4) {
        _faceCamera.cameraPosition = false;
        _faceCamera.cameraMessage = 'FaceContour_camera_right_left';

        setStreamIfMounted(_faceCamera);
      }
      // call circular
      else {
        debugPrint("In File: face_stream_event.dart, Line: 241 Distance OK ");
        checkFaceCircular(face);
      }
    }
  }

  void checkFaceCircular(face) {
    // Check mắt phải: 16 point và mắt trái 16 point
    try {
      List<Offset> leftEye =
          face.getContour(FaceContourType.rightEye).positionsList;
      List<Offset> rightEye =
          face.getContour(FaceContourType.leftEye).positionsList;

      // Chưa hiểu công thức này
      double leftAvgPointDis = 0;
      for (int i = 1; i < leftEye.length; i++) {
        leftAvgPointDis =
            leftAvgPointDis + (leftEye[i].dx - leftEye[i - 1].dx).abs();
      }

      leftAvgPointDis = leftAvgPointDis / (leftEye.length - 1);

      double rightAvgPointDis = 0;
      for (int i = 1; i < rightEye.length; i++) {
        rightAvgPointDis =
            rightAvgPointDis + (rightEye[i].dx - rightEye[i - 1].dx).abs();
      }

      rightAvgPointDis = rightAvgPointDis / (rightEye.length - 1);

      double lrControlRate = 0.875;

      if (Platform.isIOS) {
        // Đổi giá trị chi ta.
        double temp = leftAvgPointDis;
        leftAvgPointDis = rightAvgPointDis;
        rightAvgPointDis = temp;
      }

      if (_faceCamera.takePictureState == 'RightImage') {
        if (leftAvgPointDis > rightAvgPointDis * lrControlRate) {
          _faceCamera.cameraMessage = 'Hold_phone_still_turn_head_left';

          setStreamIfMounted(_faceCamera);
        }
      } else if (_faceCamera.takePictureState == 'LeftImage') {
        if (rightAvgPointDis > leftAvgPointDis * lrControlRate) {
          _faceCamera.cameraMessage = 'Hold_phone_still_turn_head_right';

          setStreamIfMounted(_faceCamera);
        }
      }

      _faceCamera.cameraPosition = true;
      _faceCamera.cameraDistance = true;
      _faceCamera.cameraMessage = 'FaceContour_camera_stay_still';

      setStreamIfMounted(_faceCamera);
      // set all detected true
    } catch (err) {
      debugPrint("In File: face_stream_event.dart, Line: 305 $err ");

      setStreamIfMounted(_faceCamera);
    }
  }

  Future<void> stopStream() async {
    _faceCamera.isDetecting = true;
    if (cameraController != null) {
      cameraController?.stopImageStream();
      cameraController?.dispose().catchError((err) {
        debugPrint("In File: face_stream_event.dart, Line: 325 $err");
      });
    }
  }

  Future<void> dispose() async {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer?.cancel();
      }
    }

    await faceStreamController.close();
  }
}
