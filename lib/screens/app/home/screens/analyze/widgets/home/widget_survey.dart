import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../providers/acne_analyze/acne_analyze.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../theme/color.dart';

Widget surveyWidget(BuildContext context) {
  var popup = context.read<AcneAnalyzeVM>();

  return Container(
    padding: const EdgeInsets.only(bottom: 25),
    width: double.infinity,
    child: InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.survey).then((value) {
          popup.getPopupCheck();
        });
        //popupAnalysisResults(context);
      },
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  AppColors.textBlueBR0,
                  AppColors.textBlueBR1,
                  AppColors.textBlueBR2,
                ],
                stops: [0.0, 0.95, 1],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30),
            child: SvgPicture.asset(
              Assets.icons.backgroundSurvey,
              fit: BoxFit.cover,
              color: AppColors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, bottom: 24),
            width: Helper.percentWidth(pixel: 247, context: context),
            child: Text(
              LocaleKeys.surveysPopup,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: Assets.googleFonts.montserratBlack,
                    color: AppColors.white,
                  ),
            ).tr(gender: 'title'),
          ),
        ],
      ),
    ),
  );
}
