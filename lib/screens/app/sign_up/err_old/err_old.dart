import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../widgets/button_widget/button_widget.dart';

class ErrOld extends StatefulWidget {
  const ErrOld({Key? key}) : super(key: key);

  @override
  State<ErrOld> createState() => _ErrOldState();
}

class _ErrOldState extends State<ErrOld> {
  @override
  Widget build(BuildContext context) {
    String name = ModalRoute.of(context)!.settings.arguments as String;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.textBlack,
        body: Stack(
          children: [
            /*  Positioned(
                top: -400,
                right: -500,
                child: SvgPicture.asset(
                  Assets.icons.signUpEmailBackground,
                  fit: BoxFit.scaleDown,
                )), */
            Positioned(
                right: 0,
                child: SvgPicture.asset(
                  Assets.icons.backgroundErrOld2,
                  fit: BoxFit.scaleDown,
                  color: AppColors.textLightBlue.withOpacity(0.03),
                )),
            Positioned(
                right: 0,
                child: SvgPicture.asset(
                  Assets.icons.backgroundErrOld1,
                  fit: BoxFit.scaleDown,
                  color: AppColors.textLightGray.withOpacity(0.1),
                )),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          LocaleKeys.enterinfoCompletedName,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBlack,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ).tr(args: [name]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.enterinfoCompletedContentPart1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: AppColors.white, height: 2),
                    ).tr(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.enterinfoCompletedContentPart2,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: AppColors.white,
                          ),
                    ).tr(args: [name]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LocaleKeys.generalBack,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontFamily: Assets.googleFonts.montserratBlack,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                      ).tr(),
                      primary: AppColors.primary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
