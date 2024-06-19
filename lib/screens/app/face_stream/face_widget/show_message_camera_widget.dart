import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/screens/app/face_stream/face_utils/face_utils.dart';
import 'package:skin_detective/theme/color.dart';

class ShowMessageCameraWidget extends StatelessWidget {
  final String cameraMessage;
  const ShowMessageCameraWidget({Key? key, required this.cameraMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cameraMessage.isEmpty) {
      return const SizedBox.shrink();
    }
    //Camera AI check message
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(
            getFaceTransMes(cameraMessage.toString()),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.textBlack,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ).tr(),
          decoration: BoxDecoration(
            color: AppColors.textLightGrayBG,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
