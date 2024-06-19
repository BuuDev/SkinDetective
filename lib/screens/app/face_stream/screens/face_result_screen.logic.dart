part of 'face_result_screen.dart';

class FaceResultLogic with ChangeNotifier {
  final BuildContext context;
  FaceResultLogic({required this.context});

  void onRestartFace() {
    Navigator.pushNamed(context, AppRoutes.facePermission);
  }

  void startAnalyze() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FaceAnalysis(),
      ),
    );
  }
}
