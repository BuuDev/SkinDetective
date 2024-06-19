import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../../../constants/type_globals.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import '../../bottom_navigation/bottom_navigation.dart';
import '../screens/analyze/survey/survey.dart';

Future showPopupSurvey(BuildContext context, String text) {
  return showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: AppColors.appBg.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    Assets.icons.closeIcon,
                    fit: BoxFit.scaleDown,
                    color: AppColors.textLightGray,
                  ),
                ),
              ),
              SvgPicture.asset(
                Assets.icons.noteIcon,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.popupsurveyText1.tr(),
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBold,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.popupsurveyText2.tr(),
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBold,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                  ),
                ),
              ),
              Flexible(
                child: Html(shrinkWrap: true, data: text),
              ),
              ButtonWidget(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SurveyScreen(),
                    ),
                  );
                  Navigator.of(context, rootNavigator: true).pop();
                },
                type: EButton.normal,
                child: Text(LocaleKeys.popupsurveyButtonText.tr(),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontFamily: Assets.googleFonts.montserratBlack,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white)),
              ),
              SizedBox(
                height: BottomNavigationState.heightInsets(context),
              )
            ],
          ),
        );
      });
}
