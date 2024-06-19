import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image.asset(
            Assets.images.onBoardingBg.path,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: Helper.percentHeight(pixel: 235, context: context),
          right: 0,
          left: 0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: Helper.percentHeight(pixel: 90, context: context),
                  ),
                  child: Image.asset(
                    Assets.images.onBoardingIconApp.path,
                    width: Helper.percentWidth(
                      pixel: 147,
                      context: context,
                    ),
                    height: Helper.percentHeight(
                      pixel: 143,
                      context: context,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.onBoardFirst,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2!.merge(
                              TextStyle(
                                color: AppColors.textBlue,
                                height: 1.5,
                                fontFamily: Assets.googleFonts.montserratMedium,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                      ).tr(),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Helper.percentHeight(
                            pixel: 30,
                            context: context,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.onBoardDescriptionFirst,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                  const TextStyle(
                                    color: AppColors.textBlack,
                                    height: 1.4,
                                  ),
                                ),
                          ).tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
