import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/models/survey/answers/answers_option.dart';
import 'package:skin_detective/models/survey/levels.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../models/survey/slider/slider.dart';
import '../../../../../../../theme/color.dart';

class SliderQuestion extends StatefulWidget {
  final int sTT;

  final SliderModel data;
  final List<Levels>? levels;
  final void Function(List<OptionAnswer> lst, int soluong, int questionId)
      onCheck;
  final List<OptionAnswer> dataAnswer;

  const SliderQuestion(
      {Key? key,
      required this.sTT,
      required this.data,
      required this.levels,
      required this.onCheck,
      required this.dataAnswer})
      : super(key: key);

  @override
  _SliderQuestionPageState createState() => _SliderQuestionPageState();
}

class _SliderQuestionPageState extends State<SliderQuestion> {
  List<bool> lstCheck = List.generate(5, (index) => false);
  List<double> lstValueSlider = [];
  List<OptionAnswer> dataSlider = [];

  int? doubleToInt(double value) {
    int? valueSlider;
    for (int i = 0; i < 5; i++) {
      if ((value * 10).toStringAsFixed(2) ==
          (((1 / (5 - 1)) * (i)) * 10).toStringAsFixed(2)) {
        valueSlider = i + 1;
      }
    }
    return valueSlider;
  }

  double? intToDouble(int value) {
    double? valueSlider;
    for (int i = 0; i < 5; i++) {
      if (value == i + 1) {
        valueSlider = (1 / (5 - 1)) * (i);
      }
    }
    return valueSlider;
  }

  // String ratingLable(int index) {
  //   String value = "";
  //   for (int i = 0; i < widget.levels!.length; i++) {
  //     if ((lstValueSlider[index] * 10).toStringAsFixed(2) ==
  //         (((1 / (widget.levels!.length - 1)) * (i)) * 10).toStringAsFixed(2)) {
  //       value = "widget.levels![i].text!";
  //     }
  //   }
  //   return value;
  // }

  String ratingLable(int index) {
    switch (index) {
      case 0:
        return LocaleKeys.surveyLevels1.tr();
      case 1:
        return LocaleKeys.surveyLevels2.tr();
      case 2:
        return LocaleKeys.surveyLevels3.tr();
      case 3:
        return LocaleKeys.surveyLevels4.tr();
      case 4:
        return LocaleKeys.surveyLevels5.tr();
      default:
        return "";
    }
  }

  Widget ratting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          LocaleKeys.survey,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontFamily: Assets.googleFonts.montserratBlack,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlue,
              ),
        ).tr(gender: 'slider_ratting'),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              5,
              (index) => _lable(context, "${index + 1}. " + ratingLable(index),
                  AppColors.textBlue),
            ),
          ],
        )
      ]),
    );
  }

  Widget _lable(BuildContext context, String lable, Color colors) {
    return Text(
      lable,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontFamily: Assets.googleFonts.montserratBlack,
            fontWeight: FontWeight.w500,
            color: colors,
          ),
    );
  }

  @override
  void initState() {
    lstValueSlider = List.generate(5, (index) => 0.0);
    // TODO: implement initState
    if (widget.dataAnswer.isNotEmpty) {
      for (int i = 0; i < widget.dataAnswer.length; i++) {
        lstValueSlider[i] = intToDouble(5)!;
        lstCheck[i] = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
          child: Text(
            "${widget.sTT + 1}. " + widget.data.title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: Assets.googleFonts.montserratBlack,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
          ),
        ),
        ratting(context),
        ...List.generate(
          widget.data.options.length,
          (index) => Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: _lable(context, widget.data.options[index].text,
                      AppColors.textBlueBlack),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbColor: lstCheck[index]
                          ? AppColors.textBlue
                          : AppColors.textLightBlue,
                      activeTrackColor: AppColors.textLightBlue,
                      activeTickMarkColor: AppColors.textLightBlue,
                      inactiveTrackColor: AppColors.textLightBlue,
                      inactiveTickMarkColor: AppColors.textLightBlue,
                      valueIndicatorColor: AppColors.textBlue,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6),
                      tickMarkShape:
                          const RoundSliderTickMarkShape(tickMarkRadius: 6),
                      valueIndicatorTextStyle:
                          Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontFamily: Assets.googleFonts.montserratBlack,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                    ),
                    child: Slider(
                      value: lstValueSlider[index],
                      onChangeStart: (newRating) {
                        setState(() {
                          lstCheck[index] = true;
                        });
                        for (int i = 0; i < dataSlider.length; i++) {
                          if (dataSlider[i].id == index + 1) {
                            dataSlider.removeAt(i);
                          }
                        }
                        dataSlider.add(OptionAnswer(
                            id: index + 1,
                            text: null,
                            level: doubleToInt(newRating),
                            freeText: null));
                        widget.onCheck(dataSlider, widget.data.options.length,
                            widget.data.questionId);
                      },
                      label: ratingLable(index),
                      onChanged: (newRating) {
                        setState(() {
                          lstCheck[index] = true;
                          lstValueSlider[index] = newRating;
                        });
                        for (int i = 0; i < dataSlider.length; i++) {
                          if (dataSlider[i].id == index + 1) {
                            dataSlider.removeAt(i);
                          }
                        }
                        dataSlider.add(OptionAnswer(
                            id: index + 1,
                            text: null,
                            level: doubleToInt(newRating),
                            freeText: null));

                        widget.onCheck(dataSlider, widget.data.options.length,
                            widget.data.questionId);
                      },
                      divisions: 5 - 1,
                    ),
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
