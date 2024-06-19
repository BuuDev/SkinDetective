import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/screens/app/home/screens/settings/setting.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late SettingLogic settingLogic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingLogic = SettingLogic(context: context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    settingLogic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: LocaleKeys.generalBack.tr(),
        centerTitle: false,
        textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: AppColors.textLightGray,
            ),
      ),
      body: ChangeNotifierProvider.value(
        value: settingLogic,
        child: Consumer<SettingLogic>(
          builder: (_, value, __) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          LocaleKeys.settingQuestionTitle.tr(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: AppColors.backgroundColor,
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            settingLogic.updateBtn(4);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(4),
                          title: Text(
                            'What was your worst injury?',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                'A sandwich can be done in billions of tactics, i think it would be worth it.',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: AppColors.textLightGray,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: AppColors.backgroundColor,
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            settingLogic.updateBtn(5);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(5),
                          title: Text(
                            'Have you ever changed a diaper?',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: AppColors.backgroundColor,
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            settingLogic.updateBtn(6);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(6),
                          title: Text(
                            'Which do you like better, calls or texts?',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
