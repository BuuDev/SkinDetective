import 'package:flutter/material.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/fonts.dart';

import '../../theme/color.dart';

class CustomDialog extends StatelessWidget {
  final Widget icon;
  final String title;
  final double? height;
  final double? width;
  final Color? titleColor;
  final Color? subtitleColor;
  final String subtitle;
  final List<Widget>? children;
  final AlignmentGeometry? alignIcon;

  const CustomDialog(
      {Key? key,
      required this.icon,
      required this.title,
      this.titleColor,
      this.subtitleColor,
      this.height,
      this.width,
      required this.subtitle,
      this.children,
      this.alignIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 65),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      elevation: 0.0,
      backgroundColor: AppColors.backgroundColor,
      content: SizedBox(
        height: height ?? 155,
        width: width ?? 236,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: alignIcon ?? Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 31,
                  bottom: 24,
                ),
                child: icon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 17),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? AppColors.red,
                    fontFamily: Assets.googleFonts.montserratBold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 17, right: 16),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: subtitleColor ?? AppColors.black,
                      height: 1.5,
                      fontSize: AppFonts.font_14,
                    ),
              ),
            ),
          ],
        ),
      ),
      actions: children,
    );
  }
}
