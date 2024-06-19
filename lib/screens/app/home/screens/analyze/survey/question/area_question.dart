import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/models/survey/answers/answers_option.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../models/survey/area/area.dart';
import '../../../../../../../theme/color.dart';

class AreaQuestion extends StatefulWidget {
  final int sTT;
  final AreaModel data;
  final void Function(String? value, List<OptionAnswer> lst, int questionId)
      onCheck;
  final List<OptionAnswer> dataAnswer;

  const AreaQuestion(
      {Key? key,
      required this.sTT,
      required this.data,
      required this.onCheck,
      required this.dataAnswer})
      : super(key: key);

  @override
  _AreaQuestionPageState createState() => _AreaQuestionPageState();
}

class _AreaQuestionPageState extends State<AreaQuestion> {
  List<OptionAnswer> dataArea = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.dataAnswer.isNotEmpty) {
      controller.text = widget.dataAnswer[0].text!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.sTT + 1}. " + widget.data.title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: Assets.googleFonts.montserratBlack,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: AppColors.black,
                ),
            onChanged: (text) {
              dataArea = [];
              dataArea.insert(0,
                  OptionAnswer(id: 1, text: text, level: null, freeText: null));
              widget.onCheck(text, dataArea, widget.data.questionId);
            },
            maxLines: 8,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundColor,
              hintText:
                  LocaleKeys.settingRating.tr(gender: 'comment_placeholder'),
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
        ],
      ),
    );
  }
}
