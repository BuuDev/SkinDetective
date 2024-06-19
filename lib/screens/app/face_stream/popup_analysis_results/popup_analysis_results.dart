import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../theme/color.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import '../../../../widgets/custom_dialog/custom_dialog.dart';

Future<T?> popupAnalysisResults<T>(BuildContext context) {
  return showDialog<T?>(
      barrierDismissible: false,
      barrierColor: AppColors.textLightGrayBG.withOpacity(0.8),
      context: context,
      builder: (_) {
        return CustomDialog(
          alignIcon: Alignment.topCenter,
          icon: SvgPicture.asset(
            Assets.icons.faceDistance,
            color: const Color.fromRGBO(206, 220, 255, 1),
            width: 70,
            height: 70,
          ),
          height: 230,
          titleColor: AppColors.textBlack,
          title: LocaleKeys.popupAnalysisResultTitle.tr(),
          subtitleColor: AppColors.textBlack,
          subtitle: LocaleKeys.popupAnalysisResultSubtitle.tr(),
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ButtonWidget(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            LocaleKeys.buttonResultWatch.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBlack,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          primary: AppColors.primary),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonWidget(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            LocaleKeys.buttonResultStay.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBlack,
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          primary: AppColors.lightGray),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      });
}
