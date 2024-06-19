import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/models/survey/answers/answers_option.dart';

import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../models/survey/radio/radio.dart';
import '../../../../../../../theme/color.dart';
import '../../../../../../../utils/multi_languages/locale_keys.dart';

class RadioQuestion extends StatefulWidget {
  final int sTT;
  final RadioModel data;
  final void Function(List<OptionAnswer> lst, int questionId) onCheck;
  final List<OptionAnswer> dataAnswer;

  const RadioQuestion(
      {Key? key,
      required this.sTT,
      required this.data,
      required this.onCheck,
      required this.dataAnswer})
      : super(key: key);

  @override
  _RadioQuestionPageState createState() => _RadioQuestionPageState();
}

class _RadioQuestionPageState extends State<RadioQuestion> {
  List<OptionAnswer> dataRadio = [];
  TextEditingController controller = TextEditingController();
  int? valueSelected;
  bool checked = false;

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
    // TODO: implement initState
    if (widget.dataAnswer.isNotEmpty) {
      if (widget.dataAnswer[0].freeText == true) {
        checked = true;
        valueSelected = widget.dataAnswer[0].id;
        controller.text = widget.dataAnswer[0].text!;
      } else {
        valueSelected = widget.dataAnswer[0].id;
      }
    }

    super.initState();
  }

  Widget _radioCheckQuestion(
    BuildContext context,
    int value,
    OptionRadio itemData,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Row(
            children: [
              Radio<int>(
                value: itemData.id,
                activeColor: AppColors.textBlue,
                groupValue: valueSelected,
                onChanged: (e) {
                  setState(() {
                    valueSelected = e!;
                    if (itemData.freeText == true &&
                        itemData.id == valueSelected) {
                      dataRadio = [];
                      dataRadio.insert(
                          0,
                          OptionAnswer(
                              id: itemData.id,
                              text: "",
                              level: null,
                              freeText: itemData.freeText));
                      widget.onCheck(dataRadio, widget.data.questionId);
                      checked = true;
                    } else {
                      checked = false;
                      dataRadio = [];
                      dataRadio.insert(
                          0,
                          OptionAnswer(
                              id: itemData.id,
                              text: itemData.text.toString(),
                              level: null,
                              freeText: itemData.freeText));
                      widget.onCheck(dataRadio, widget.data.questionId);
                    }
                  });
                },
              ),
              _lable(context, itemData.text, AppColors.textBlack)
            ],
          ),
          if (itemData.freeText)
            if (checked)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 24),
                child: TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: AppColors.black,
                      ),
                  maxLines: 3,
                  onChanged: (text) {
                    dataRadio = [];
                    dataRadio.insert(
                        0,
                        OptionAnswer(
                            id: itemData.id,
                            text: text,
                            level: null,
                            freeText: itemData.freeText));
                    widget.onCheck(dataRadio, widget.data.questionId);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundColor,
                    hintText: LocaleKeys.settingRating
                        .tr(gender: 'comment_placeholder'),
                    hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textLightGray,
                        ),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.textBlue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "${widget.sTT + 1}. " + widget.data.title,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontFamily: Assets.googleFonts.montserratBlack,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
        ),
        ...List.generate(
          widget.data.options.length,
          (index) => _radioCheckQuestion(
            context,
            index + 1,
            widget.data.options[index],
          ),
        ),
      ]),
    );
  }
}
