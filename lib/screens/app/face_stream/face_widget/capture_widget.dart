import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';

class CaptureWidget extends StatelessWidget {
  final void Function() onCapture;
  final void Function() onFlash;
  final void Function() reverseCamera;
  final FlashMode flashMode;

  const CaptureWidget({
    Key? key,
    required this.onCapture,
    required this.onFlash,
    required this.reverseCamera,
    required this.flashMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 100),
            child: Builder(builder: (context) {
              return Align(
                child: InkWell(
                  onTap: onFlash,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: SvgPicture.asset(
                      Assets.icons.flash,
                      color:
                          flashMode == FlashMode.off ? null : AppColors.primary,
                    ),
                  ),
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: () => onCapture(),
            child: SvgPicture.asset(
              Assets.icons.capture,
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.black.withOpacity(0),
              elevation: 0,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 100),
            child: ElevatedButton(
              onPressed: () => reverseCamera(),
              child: SvgPicture.asset(
                Assets.icons.lens,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black.withOpacity(0),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
