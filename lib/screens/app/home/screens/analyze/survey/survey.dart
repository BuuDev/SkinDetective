import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/models/survey/answers/answers.dart';
import 'package:skin_detective/models/survey/answers/survey_answers.dart';
import 'package:skin_detective/models/survey/question_survey.dart';
import 'package:skin_detective/models/survey/survey.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/page/finish.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/page/survey1.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/page/survey2.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/page/survey3.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/question/area_question.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/question/radio_question.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/survey/question/slider_question.dart';
import 'package:skin_detective/services/apis/survey/survey.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../models/survey/answers/answers_option.dart';
import '../../../../../../theme/color.dart';
import '../../../../../../widgets/button_widget/button_widget.dart';
part "survey_logic.dart";

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyScreen> {
  late SurveyLogic surveyLogic;

  @override
  void initState() {
    super.initState();
    surveyLogic = SurveyLogic(
      context: context,
    );
  }

  Widget get surveyItem {
    switch (surveyLogic.check) {
      case 1:
        return const Survey1();
      case 2:
        return const Survey2();
      case 3:
        return const Survey3();
      default:
        return const Finish();
    }
  }

  String? _buttonlable() {
    switch (surveyLogic.check) {
      case 1:
        return LocaleKeys.generalNext;
      case 2:
        return LocaleKeys.generalNext;
      case 3:
        return LocaleKeys.completeButton;
      default:
        return LocaleKeys.backHomeButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: surveyLogic,
      child: Consumer<SurveyLogic>(
        builder: (_, value, __) {
          return GestureDetector(
            onTap: (() => FocusScope.of(context).unfocus()),
            child: Scaffold(
              backgroundColor: AppColors.textLightGrayBG,
              appBar: PreferredSize(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        AppColors.textBlueBR0,
                        AppColors.textBlueBR1,
                        AppColors.textBlueBR2,
                      ], stops: [
                        0.0,
                        0.95,
                        1
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 63,
                        top: 60,
                      ),
                      child: SvgPicture.asset(
                        Assets.icons.backgroundSurvey,
                        fit: BoxFit.scaleDown,
                        color: AppColors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          bottom: 54,
                        ),
                        child: Text(
                          LocaleKeys.survey,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBold,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textLightBlue,
                              ),
                        ).tr(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 24),
                        child: Text(
                          value.check == 4
                              ? LocaleKeys.surveyComplete
                              : LocaleKeys.survey,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBold,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                        ).tr(
                            gender: value.check == 4 ? "title" : "part",
                            args: ['${value.check}/3']),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 35, left: 30, right: 30),
                      child: Row(
                        children: [
                          value.check == 1
                              ? const Expanded(child: SizedBox())
                              : Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          value.check = value.check - 1;
                                          value.questionHienThi = {};
                                          value._scrollController.animateTo(0.0,
                                              duration: const Duration(
                                                  microseconds: 500),
                                              curve: Curves.ease);
                                          value.isChecked = true;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        Assets.icons.arrowLeftBack,
                                        fit: BoxFit.scaleDown,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                  value._writeData(value.lstAnswers);
                                });
                              },
                              child: SvgPicture.asset(
                                Assets.icons.closeIcon,
                                fit: BoxFit.scaleDown,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.textLightPinkBG,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.textOrangeBG,
                        ),
                        value: value.lstAnswers.isEmpty
                            ? 0
                            : value.lstAnswers.length /
                                (value.dataSurvey.partOne.length +
                                    value.dataSurvey.partTwo.length +
                                    value.dataSurvey.partThree.length),
                      ),
                    )
                  ],
                ),
                preferredSize: const Size.fromHeight(155),
              ),
              body: Theme(
                  data: Theme.of(context).copyWith(
                    radioTheme: Theme.of(context).radioTheme.copyWith(
                          fillColor: MaterialStateProperty.all<Color>(
                              AppColors.textLightGray),
                        ),
                  ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    controller: value._scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageTransitionSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (child, animation, secondaryAnimation) =>
                                  FadeThroughTransition(
                            fillColor: AppColors.transparent,
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                          ),
                          child: surveyItem,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30, bottom: 24, left: 30, right: 30),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: value.isChecked
                                        ? [
                                            AppColors.textBlueBR0,
                                            AppColors.textBlueBR1,
                                            AppColors.textBlueBR2,
                                          ]
                                        : [
                                            AppColors.textLightGrayDisabled,
                                            AppColors.textLightGrayDisabled,
                                            AppColors.textLightGrayDisabled
                                          ],
                                    stops: const [0.0, 0.95, 1],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight)),
                            child: ButtonWidget(
                              primary: AppColors.transparent,
                              onPressed: () async {
                                value.checkButton();
                              },
                              type: EButton.full,
                              icon: (value.check <= 2)
                                  ? Assets.icons.next
                                  : ((value.check == 3)
                                      ? null
                                      : Assets.icons.homeSurvey),
                              child: Text(_buttonlable().toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: Assets
                                                  .googleFonts.montserratBlack,
                                              color: AppColors.white))
                                  .tr(),
                            ),
                          ),
                        ),
                        if (value.questionHienThi.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 45),
                            child: Column(
                              children: List.generate(
                                value.questionHienThi.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Text(LocaleKeys.survey,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratBlack,
                                                    color: AppColors.red))
                                        .tr(gender: 'question', args: [
                                      value.questionHienThi.keys
                                          .toList()[index]
                                          .toString()
                                    ]),
                                  );
                                },
                              ),
                            ),
                          ),
                        SizedBox(
                          height: BottomNavigationState.heightInsets(context),
                        )
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}
