import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';

class OnBoardScreen extends StatelessWidget {
  final String backgroundScreen;
  final String? imageScreen;
  final Widget? customImage;
  final String caption;

  const OnBoardScreen({
    Key? key,
    required this.backgroundScreen,
    this.imageScreen,
    required this.caption,
    this.customImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*  ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image.asset(
            backgroundScreen, 
            fit: BoxFit.fill,
          ),
        ), */
        Positioned(
          top: Helper.percentHeight(pixel: 110, context: context),
          right: 0,
          left: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  if (customImage != null) customImage!,
                  if (customImage == null)
                    Image.asset(
                      imageScreen ?? '',
                      height:
                          Helper.percentHeight(pixel: 532, context: context),
                    ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            caption,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle2!.merge(
                                  const TextStyle(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                          ).tr(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
