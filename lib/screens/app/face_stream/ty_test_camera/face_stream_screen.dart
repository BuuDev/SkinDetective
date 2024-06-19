import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io' show Platform;

import 'package:provider/provider.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/utils/helper/helper.dart';

import 'package:skin_detective/widgets/loading/loading.dart';
import 'package:tuple/tuple.dart';

import '../face_utils/face_detect_util.dart';
import '../face_widget/capture_widget.dart';
import '../face_widget/dialog_result_face_widget.dart';
import '../face_widget/show_message_camera_widget.dart';

part 'view_model.dart';

class FaceStream extends StatefulWidget {
  final List<CameraDescription> cameras;
  final void Function(ETypeFace type) onChangeType;

  const FaceStream({
    Key? key,
    required this.cameras,
    required this.onChangeType,
  }) : super(key: key);

  @override
  _FaceStreamState createState() => _FaceStreamState();
}

class _FaceStreamState extends State<FaceStream> with WidgetsBindingObserver {
  late _LogicCode logicCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    logicCode = _LogicCode(context: context, cameraList: widget.cameras);
    logicCode.addListener(onListenLogic);
  }

  void onListenLogic() {
    widget.onChangeType(logicCode.stepScan);
  }

  @override
  void dispose() {
    logicCode.removeListener(onListenLogic);
    WidgetsBinding.instance?.removeObserver(this);
    logicCode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      logicCode.disposeCamera();
    } else if (state == AppLifecycleState.resumed && logicCode.isDispose) {
      logicCode.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: logicCode,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,

        ///TODO: Rerender when camera initialized
        child: Selector<_LogicCode, Tuple2<CameraController, bool>>(
          selector: (_, state) => Tuple2(
            state.cameraController,
            state.cameraInitialized,
          ),
          shouldRebuild: (pre, next) =>
              pre.item1 != next.item1 || pre.item2 != next.item2,
          builder: (_, data, ___) {
            if (!data.item2) {
              return const SizedBox();
            }

            return Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      child: Container(
                        height: data.item1.value.previewSize?.height,
                        width: data.item1.value.previewSize?.width,
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            CameraPreview(
                              data.item1,
                              child: Selector<_LogicCode, ETypeFace>(
                                  selector: (_, state) => state.stepScan,
                                  builder: (_, step, ___) {
                                    if (step.imageTypeFace.isEmpty) {
                                      return const SizedBox();
                                    }

                                    return SvgPicture.asset(
                                      step.imageTypeFace,
                                      fit: BoxFit.scaleDown,
                                    );
                                  }),
                            ),
                            Positioned(
                              bottom: 24,
                              left: 0,
                              right: 0,
                              child: Selector<_LogicCode, String>(
                                selector: (_, state) => state.messageDetect,
                                builder: (_, message, ___) {
                                  return AnimatedOpacity(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    opacity: message.isEmpty ? 0 : 1,
                                    child: ShowMessageCameraWidget(
                                      cameraMessage: message,
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: insetsBottom(context) + 15),
                    child:
                        Selector<_LogicCode, Tuple2<FlashMode, CameraPosition>>(
                      selector: (_, state) =>
                          Tuple2(state.flashMode, state.cameraPosition),
                      builder: (_, state, ___) {
                        return CaptureWidget(
                          onCapture: logicCode.captureImage,
                          onFlash: logicCode.onPressFlash,
                          reverseCamera: logicCode.reverseCamera,
                          flashMode: state.item1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
