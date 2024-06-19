import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_detective/models/acne_box/acne_box.dart';
import 'package:skin_detective/theme/color.dart';

class AcneRowWidget extends StatelessWidget {
  final AcneBox acneBox;
  const AcneRowWidget({Key? key, required this.acneBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 8, bottom: 15),
          child: SvgPicture.asset(acneBox.icon),
        ),
        Text(
          acneBox.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textBlueBlack,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ),
        Expanded(
          child: Text(
            acneBox.count.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textBlueBlack,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
