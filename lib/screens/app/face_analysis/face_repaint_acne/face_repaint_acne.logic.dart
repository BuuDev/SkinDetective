part of 'face_repaint_acne.dart';

class FaceRepaintAcneLogic with ChangeNotifier {
  final BuildContext context;
  late Completer<ui.Image> completer;
  final GlobalKey _globalKey = GlobalKey();

  bool inside = false;
  Uint8List? imageInMemory;

  FaceRepaintAcneLogic({required this.context}) : super() {
    _getImage();
  }

  Future<ui.Image> _getImage() {
    Image image = Image.network('https://i.stack.imgur.com/lkd0a.png');
    completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    return completer.future;
  }
}
