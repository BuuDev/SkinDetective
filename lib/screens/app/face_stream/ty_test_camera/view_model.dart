part of 'face_stream_screen.dart';

class _LogicCode with ChangeNotifier {
  BuildContext context;
  List<CameraDescription> cameraList;

  late CameraController cameraController;
  bool cameraInitialized = false;
  bool isHandlingDetect = false;

  ETypeFace stepScan = ETypeFace.Face;
  Map<ETypeFace, XFile> imagesCaptured = {};

  CameraPosition cameraPosition = CameraPosition.front;

  String messageDetect = '';

  bool isDispose = false;

  FlashMode flashMode = FlashMode.off;

// DatBT
  int greyScale = 0;
//

  _LogicCode({required this.context, required this.cameraList}) {
    initCamera();
  }

  Size get cameraSize => Size(cameraController.value.previewSize!.width,
      cameraController.value.previewSize!.height);

  Future<void> initCamera([CameraDescription? cameraDescription]) async {
    //Case camera đã tạo trước đó
    if (cameraDescription != null) {
      //dispose và khởi tạo lại chính description của camera đó
      cameraController.dispose();
    }

    if (cameraList.isNotEmpty) {
      cameraController = CameraController(
        cameraDescription ?? cameraList[cameraPosition.value],
        Platform.isIOS ? ResolutionPreset.medium : ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS ? ImageFormatGroup.yuv420 : null,
      );
    } else {
      cameraController = CameraController(
        const CameraDescription(
            name: 'emulator',
            lensDirection: CameraLensDirection.front,
            sensorOrientation: 0),
        Platform.isIOS ? ResolutionPreset.medium : ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS ? ImageFormatGroup.yuv420 : null,
      );
    }

    cameraController.setFlashMode(flashMode);

    try {
      stepScan = ETypeFace.Face;

      await cameraController.initialize().then((value) {
        cameraController.startImageStream(onImageStream);
      });

      //Refresh UI to preview
      cameraInitialized = true;
    } on CameraException catch (e) {
      debugPrint('$e');
    }
    notifyListeners();
  }

  void onImageStream(CameraImage image) async {
    ///Deny detector when handling

    if (isHandlingDetect || isDispose) {
      return;
    }

    isHandlingDetect = true;

    var faceDetector = GoogleMlKit.vision.faceDetector(
      const FaceDetectorOptions(
        enableClassification: false,
        enableLandmarks: false,
        enableContours: true,
        enableTracking: false,
        mode: FaceDetectorMode.accurate,
      ),
    );

    // ___CONFIG camera controller

    // Lấy hướng xoay camera
    InputImageRotation rotation = InputImageRotationMethods.fromRawValue(
            cameraController.description.sensorOrientation) ??
        InputImageRotation.Rotation_0deg;

    var faceDetectUtil = FaceDetectUtil(
      rotation: rotation,
      faceDetector: faceDetector,
    );

    List<Face> faces = await faceDetectUtil.detect(image);

    if (faces.isEmpty) {
      messageDetect = 'FaceContour_no_face_detected';
    } else {
      faceCheck(faces[0]);
      if (messageDetect == '') {
        brightnessCheck(image);
      }
    }

    if (isDispose) {
      return;
    }

    notifyListeners();
    isHandlingDetect = false;
  }

  void faceCheck(Face face) {
    try {
      List<Offset> facePoints =
          face.getContour(FaceContourType.face)?.positionsList ?? [];
      if (facePoints.isEmpty) {
        return;
      }

      double faceWidth = 0, faceWidthPercent = 0;

      //******STEP 1: Calculate face width, height
      double minDx = cameraSize.width, maxDx = 0;
      double minDy = cameraSize.height, maxDy = 0;
      for (var i = 0; i < facePoints.length; i++) {
        if (facePoints[i].dx < minDx) minDx = facePoints[i].dx;
        if (facePoints[i].dx > maxDx) maxDx = facePoints[i].dx;

        if (facePoints[i].dy < minDy) minDy = facePoints[i].dy;
        if (facePoints[i].dy > maxDy) maxDy = facePoints[i].dy;
      }
      faceWidth = (maxDx - minDx).abs();
      faceWidthPercent = faceWidth * 100 / cameraSize.width;

      //*****
      //*STEP 2: Display face distance message
      double faceWidthMinPercent = 30, faceWidthMaxPercent = 50;

      if (faceWidthPercent > faceWidthMaxPercent) {
        messageDetect = 'FaceContour_camera_farther';
        return;
      } else if (faceWidthPercent < faceWidthMinPercent) {
        messageDetect = 'FaceContour_camera_closer';
        return;
      }

      //******STEP 3: Check valid input Face Left, Right or Center sides ******
      // double rightSide = minDx, leftSide = cameraSize.width - maxDx;
      // double topSide = minDy, bottomSide = cameraSize.height - maxDy;
      List<Offset> leftEye =
          face.getContour(FaceContourType.rightEye)!.positionsList;
      List<Offset> rightEye =
          face.getContour(FaceContourType.leftEye)!.positionsList;
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
        double temp = leftAvgPointDis;
        leftAvgPointDis = rightAvgPointDis;
        rightAvgPointDis = temp;
      }

      if (stepScan == ETypeFace.Face) {
        // if (rightSide > leftSide * 4 || leftSide > rightSide * 4) {
        //   messageDetect = LocaleKeys.faceContourCameraCenter;
        //   return;
        // }
      } else if (stepScan == ETypeFace.FaceLeft) {
        if (leftAvgPointDis > rightAvgPointDis * lrControlRate) {
          messageDetect = 'Hold_phone_still_turn_head_left';
          return;
        }
      } else if (stepScan == ETypeFace.FaceRight) {
        if (rightAvgPointDis > leftAvgPointDis * lrControlRate) {
          messageDetect = 'Hold_phone_still_turn_head_right';
          return;
        }
      }
      messageDetect = '';
    } catch (error) {
      debugPrint('check-face: $error');
    }
  }

  /// DatBT - 2 Mar 2022
  // Convert image to grayScale and check brightness (grayScale>80)/darkness(grayScale<80).
  void brightnessCheck(CameraImage image) {
    // Convert image pixel to byte
    var values = image.planes[0].bytes;
    int count = 0;
    int sum = 0;
    for (int i = 0; i < values.length; i++) {
      // Skip values too dark or too bright (like: hair,...)
      if (values[i] > 50 && values[i] < 200) {
        sum = sum + values[i];
        count = count + 1;
      }
    }
    greyScale = sum ~/ count;
    if (greyScale < 80) {
      messageDetect = 'FaceContour_camera_brightness';
      return;
    }
    messageDetect = '';
  }

  void captureImage() async {
    if (!cameraInitialized) {
      return;
    }

    if (messageDetect != '') {
      return;
    }
    Loading.show();
    XFile? pictureFile;

    try {
      await cameraController.stopImageStream();
    } catch (_) {}

    try {
      pictureFile = await cameraController.takePicture();
    } on CameraException catch (e) {
      debugPrint('error capture: $e');
    }
    Loading.hide();

    if (pictureFile != null) {
      await cameraController.pausePreview();

      bool isAccept = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return DialogResultFaceWidget(
                pictureFile: pictureFile,
                cameraLensDirection: cameraController.description.lensDirection,
              );
            },
          ) ??
          false;

      if (isAccept) {
        saveStepCapture(pictureFile);
      }

      await cameraController.resumePreview();
    }

    cameraController.startImageStream(onImageStream);
  }

  void saveStepCapture(XFile pathImage) {
    // Save ảnh lại vào từng step
    imagesCaptured[stepScan] = pathImage;

    if (stepScan == ETypeFace.Face) {
      stepScan = ETypeFace.FaceLeft;

      // Bắt đầu stream bên trái
    } else if (stepScan == ETypeFace.FaceLeft) {
      stepScan = ETypeFace.FaceRight;

      // Stream bên phải
    } else if (stepScan == ETypeFace.FaceRight) {
      stepScan = ETypeFace.DONE;

      context.read<AcneAnalyzeVM>().confirmAnalyze(imagesCaptured);
      Navigator.of(context).pop();
    }

    notifyListeners();
  }

  void reverseCamera() {
    if (cameraPosition == CameraPosition.front) {
      cameraPosition = CameraPosition.back;
    } else {
      cameraPosition = CameraPosition.front;
    }

    cameraInitialized = false;
    notifyListeners();
    initCamera();
  }

  void disposeCamera() {
    isDispose = true;
    cameraController.dispose();
  }

  void resumeCamera() {
    isDispose = false;
    initCamera(cameraController.description);
  }

  void onPressFlash() {
    if (flashMode == FlashMode.auto) {
      cameraController.setFlashMode(FlashMode.off);
      flashMode = FlashMode.off;
    } else {
      if (flashMode == FlashMode.off) {
        cameraController.setFlashMode(FlashMode.auto);
        flashMode = FlashMode.auto;
      }
    }
    notifyListeners();
  }

  void updateDispose(bool isDispose) {
    this.isDispose = isDispose;
  }

  //TODO: Dispose camera streaming
  @override
  void dispose() {
    try {
      isDispose = true;
      disposeCamera();
    } catch (e) {
      debugPrint('$e');
    }
    super.dispose();
  }
}

///TODO: Enum position camera
enum CameraPosition { front, back }

extension on CameraPosition {
  ///* Front camera: 1
  ///
  ///* Back camera: 0
  int get value {
    if (this == CameraPosition.back) {
      return 0;
    }

    return 1;
  }
}
