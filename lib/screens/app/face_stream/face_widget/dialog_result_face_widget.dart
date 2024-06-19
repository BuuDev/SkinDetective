import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/screens/app/face_stream/face_utils/face_utils.dart';
import 'package:skin_detective/screens/app/face_stream/face_widget/transform_widget.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

class DialogResultFaceWidget extends StatefulWidget {
  final XFile? pictureFile;
  final List<Face>? faces;
  final CameraLensDirection cameraLensDirection;

  ///Return: true is accept | false is retake
  const DialogResultFaceWidget({
    Key? key,
    required this.pictureFile,
    this.faces,
    required this.cameraLensDirection,
  }) : super(key: key);

  @override
  _DialogResultFaceWidgetState createState() => _DialogResultFaceWidgetState();
}

class _DialogResultFaceWidgetState extends State<DialogResultFaceWidget> {
  Widget getPictureFile() {
    if (widget.pictureFile != null) {
      return TransformWidget(
        lensDirection: widget.cameraLensDirection,
        child: reviewPicture(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget reviewPicture() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.file(
        File(widget.pictureFile!.path),
        fit: BoxFit.cover,
      ),
    );
  }

  void onAccept() async {
    final cameraProvider = context.read<CameraProvider>();
    // // Save ảnh lại vào list
    // cameraProvider.saveCapture(Picture(
    //     id: cameraProvider.pictures.length + 1,
    //     path: widget.pictureFile!.path));
// Tắt dialog
    Navigator.of(context).pop(true);
    if (cameraProvider.typeFace == ETypeFace.Face) {
      // Bắt đầu stream bên trái trước
      cameraProvider.startStreamLeft();
    } else if (cameraProvider.typeFace == ETypeFace.FaceLeft) {
      // Stream bên phải
      cameraProvider.startStreamRight();
    } else if (cameraProvider.typeFace == ETypeFace.FaceRight) {
      // Đã lấy xong và show kết quả.
      cameraProvider.doneCapture();
    }
    // Navigator.of(context).pop(true);
  }

  void onReTake() {
    // final cameraProvider = context.read<CameraProvider>();
    // cameraProvider.setReTake(true);
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Consumer<CameraProvider>(builder: (_, state, __) {
                return Text(
                  getTitleDialog(state.typeFace),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ).tr();
              }),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: getPictureFile(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: onReTake,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.icons.undo,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: const Text(
                                LocaleKeys.recaptureButton,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                            ),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.textLightBlue),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: onAccept,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Wrap(
                          children: [
                            SvgPicture.asset(
                              Assets.icons.accept,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              LocaleKeys.accept,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF5A85F4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: AppColors.textLightGrayBG,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
