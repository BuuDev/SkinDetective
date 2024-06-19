import 'package:flutter/material.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

class DoubleButtonCustomWidget extends StatelessWidget {
  final String titleLeft;
  final String titleRight;
  final Color? colorTextLeft;
  final Color? colorTextRight;
  final VoidCallback onPressedLeft;
  final VoidCallback onPressedRight;

  const DoubleButtonCustomWidget({
    Key? key,
    this.titleLeft = '',
    this.titleRight = '',
    this.colorTextLeft,
    this.colorTextRight,
    required this.onPressedLeft,
    required this.onPressedRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            isPaddingRightText: false,
            icon: Assets.icons.spa,
            color: AppColors.white,
            child: Text(
              titleLeft,
              style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorTextLeft ?? AppColors.white,
                    ),
                  ),
            ),
            onPressed: onPressedLeft,
          ),
        ),
        SizedBox(width: Helper.percentWidth(pixel: 12, context: context)),
        Expanded(
          child: ButtonWidget(
            icon: Assets.icons.doctor,
            color: AppColors.textBlack,
            child: Text(
              titleRight,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorTextLeft ?? AppColors.textBlack,
                    ),
                  ),
            ),
            onPressed: onPressedRight,
            primary: AppColors.textLightBlue,
          ),
        ),
      ],
    );
  }
}
