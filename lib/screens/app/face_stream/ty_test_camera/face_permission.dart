import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/screens/app/face_stream/face_utils/face_utils.dart';
import 'package:skin_detective/screens/app/face_stream/ty_test_camera/face_stream_screen.dart';
import 'package:skin_detective/theme/color.dart';

class FacePermission extends StatefulWidget {
  const FacePermission({Key? key}) : super(key: key);

  @override
  _FacePermissionState createState() => _FacePermissionState();
}

class _FacePermissionState extends State<FacePermission> {
  late Future<List<CameraDescription>> cameras;
  bool _isPermission = false;
  ValueNotifier<ETypeFace> stepScan = ValueNotifier(ETypeFace.Face);

  @override
  void initState() {
    super.initState();
    checkCameraOS();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<AcneAnalyzeVM>().backToHome();
    });
  }

  Future<void> checkCameraOS() async {
    if (await Permission.camera.request().isGranted) {
      cameras = availableCameras();
      setState(() {
        _isPermission = true;
      });
    }

    var status = await Permission.camera.status;
    if (status.isDenied) {
      debugPrint("In File: main.dart, Line: 38 Từ chối ");
    }
  }

  Widget getIconMove(bool isRecBig) {
    return SvgPicture.asset(
      isRecBig ? Assets.icons.recBig : Assets.icons.dot,
    );
  }

  Widget get loadingWidget {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future onClose() async {
    context.read<CameraProvider>().setRestartCamera();
    return Navigator.of(context).pop;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermission) {
      return Scaffold(
        body: loadingWidget,
      );
    }

    return FutureBuilder<List<CameraDescription>>(
      future: cameras,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.textLightGrayBG,
              centerTitle: true,
              leadingWidth: 80,
              leading: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: ValueListenableBuilder<ETypeFace>(
                  valueListenable: stepScan,
                  builder: (_, typeFace, __) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getIconMove(typeFace == ETypeFace.Face),
                        getIconMove(typeFace == ETypeFace.FaceLeft),
                        getIconMove(typeFace == ETypeFace.FaceRight),
                      ],
                    );
                  },
                ),
              ),
              title: ValueListenableBuilder<ETypeFace>(
                valueListenable: stepScan,
                builder: (_, typeFace, __) {
                  return Text(
                    getTitleDialog(typeFace),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ).tr();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    child: SvgPicture.asset(
                      Assets.icons.closeIcon,
                      color: AppColors.textLightGray,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black.withOpacity(0.0),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            body: FaceStream(
              cameras: snapshot.data!,
              onChangeType: (step) => stepScan.value = step,
            ),
          );
        }
        return loadingWidget;
      },
    );
  }
}
