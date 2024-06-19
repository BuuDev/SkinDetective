part of 'face_carousel_ance.dart';

class FaceCarouselAnceLogic with ChangeNotifier {
  final BuildContext context;

  FaceCarouselAnceLogic({required this.context});

  void showDialogFace(AnalyzeDetail faceDetail) {
    showDialog(
      useSafeArea: false,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return FaceDialog(faceDetail: faceDetail);
      },
    );
  }
}
