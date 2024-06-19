import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/tips/tips.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/screens/app/face_analysis/screens/on_board_screen.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/page_view_widget/page_view_widget.dart';
import 'package:tuple/tuple.dart';

class FaceAnalysis extends StatefulWidget {
  const FaceAnalysis({Key? key}) : super(key: key);

  @override
  _FaceAnalysisState createState() => _FaceAnalysisState();
}

class _FaceAnalysisState extends State<FaceAnalysis>
    with SingleTickerProviderStateMixin {
  List<Tips> tips = [];
  UserService service = UserService.client();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getTips();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getTips() async {
    final lang = await SharedPreferences.getInstance();
    try {
      var data =
          await UserService.client().getTips(lang.getString('lang') ?? 'vn');
      setState(() {
        tips = data;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Column(
          children: [
            Selector<AcneAnalyzeVM, Tuple2<HomeStepStatus, bool>>(
                selector: (_, state) => Tuple2(state.status, state.isAnalyzed),
                builder: (_, state, __) {
                  return state.item2
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SvgPicture.asset(Assets.icons.loadingIcon),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffC5CEE4)),
                          ),
                        );
                }),
            if (tips.isNotEmpty)
              SizedBox(
                height: 440,
                child: PageViewWidget(
                  bottom: 0,
                  pages: List.generate(tips.length, (index) {
                    return OnBoardScreen(
                      title: tips[index].details.title,
                      image: tips[index].image,
                      description: tips[index].details.description,
                      content: tips[index].details.content,
                    );
                  }),
                  colorActive: AppColors.blue,
                  colorInactive: AppColors.textLightGray,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Selector<AcneAnalyzeVM, bool>(
                  selector: (_, state) => state.isAnalyzed,
                  builder: (_, isAnalyzed, __) {
                    return ButtonWidget(
                      onPressed: context.read<AcneAnalyzeVM>().showResult,
                      child: Text(
                        LocaleKeys.viewResultButton,
                        style: Theme.of(context).textTheme.bodyText2!.merge(
                              TextStyle(
                                fontFamily:
                                    Assets.googleFonts.montserratSemiBold,
                                color: isAnalyzed
                                    ? AppColors.white
                                    : AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ).tr(),
                      type: EButton.full,
                      primary: isAnalyzed
                          ? AppColors.primary
                          : AppColors.textLightGrayDisabled,
                      elevation: 0,
                    );
                  }),
            ),
            Selector<AcneAnalyzeVM, bool>(
                selector: (_, state) => state.isAnalyzed,
                builder: (_, isAnalyzed, __) {
                  if (isAnalyzed) {
                    return const SizedBox();
                  }
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20),
                      child: InkWell(
                        onTap: context.read<AcneAnalyzeVM>().cancelAnalysis,
                        child: Text(
                          LocaleKeys.cancelAnalyzeButton,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: AppColors.textRed,
                                  fontFamily: Assets.googleFonts.montserratBold,
                                  fontWeight: FontWeight.bold),
                        ).tr(),
                      ));
                })
          ],
        ),
      ],
    );
  }
}
