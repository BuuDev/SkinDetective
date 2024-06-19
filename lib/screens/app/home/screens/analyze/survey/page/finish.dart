import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../theme/color.dart';
import '../../../../../../../utils/helper/helper.dart';
import '../survey.dart';

class Finish extends StatefulWidget {
  const Finish({
    Key? key,
  }) : super(key: key);

  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<Finish> {
  late SurveyLogic surveyLogic;
  List<String> lstTest3 = ['radio', 'radio', 'free_text'];

  @override
  void initState() {
    super.initState();
    surveyLogic = SurveyLogic(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              Assets.images.onBoardingIconApp.path,
              width: Helper.percentHeight(
                pixel: 160,
                context: context,
              ),
              height: Helper.percentHeight(
                pixel: 157,
                context: context,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 38,
            ),
            child: Text(
              LocaleKeys.surveyComplete,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: Assets.googleFonts.montserratBlack,
                  color: AppColors.textBlueBlack),
            ).tr(gender: 'preface'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
            ),
            child: Text(
              LocaleKeys.surveyComplete,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontFamily: Assets.googleFonts.montserratBlack,
                    color: AppColors.textBlack,
                  ),
            ).tr(gender: 'content_part1'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
            ),
            child: Text(
              LocaleKeys.surveyComplete,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontFamily: Assets.googleFonts.montserratBlack,
                    color: AppColors.textBlack,
                  ),
            ).tr(gender: 'content_part2'),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
            ),
            child: Text(
              LocaleKeys.surveyComplete,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontFamily: Assets.googleFonts.montserratBlack,
                    color: AppColors.textBlack,
                  ),
            ).tr(gender: 'content_part3'),
          ),

          // Html(
          //   data: """
          //         <p>
          //          Đội ngũ SkinDetective xin chân thành cảm ơn sự giúp đỡ của các bạn. Chúng tôi sẽ tiếp thu ý kiến của các bạn và cập nhật ứng dụng này với nhiều dịch vụ tốt hơn nữa.
          //          <br>
          //          <br>
          //         Mọi chia sẻ của các bạn sẽ được bảo mật 100%.
          //         <br>
          //         <br>
          //         Chúc các bạn có một làn da khỏe đẹp!

          //         </p>
          //             """,
          //   style: {
          //     'p': Style().copyWith(
          //       fontSize: const FontSize(13),
          //       lineHeight: const LineHeight(1.35),
          //     ),
          //   },
          // ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
