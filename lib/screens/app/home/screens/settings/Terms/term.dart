import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/screens/app/home/screens/settings/setting.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';

class TermScreen extends StatefulWidget {
  const TermScreen({Key? key}) : super(key: key);

  @override
  _TermScreenState createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
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
      //chưa đổi
      appBar: AppBarWidget(
        title: 'Quay lại',
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
                        //chưa đổi
                        child: Text(
                          'Điều khoản & Điều kiện',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          '(Last updated on February 2,2020)',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 24, right: 24),
                          child: Text(
                            'These terms and conditions (“Terms”, “Agreement”) are an agreement between Medical AI Company Limited (“Medical AI Company Limited”, “us”, “we” or “our”) and you (“User”, “you” or “your”). This Agreement sets forth the general terms and conditions of your use of the SkinDetective mobile application and any of its products or services (collectively, “Mobile Application” or “Services”).',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      height: 2,
                                    ),
                            softWrap: true,
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
                            settingLogic.updateBtn(7);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(7),
                          title: Text(
                            '1. Accounts and Membership',
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
                            settingLogic.updateBtn(8);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(8),
                          title: Text(
                            '2. User content',
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
                            settingLogic.updateBtn(9);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(9),
                          title: Text(
                            '3. Billing and Payments',
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
                            settingLogic.updateBtn(10);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(10),
                          title: Text(
                            '4. Accuracy of information',
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
                            settingLogic.updateBtn(11);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(11),
                          title: Text(
                            '5. Third-party service',
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
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24, top: 12, bottom: 12),
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
                            settingLogic.updateBtn(12);
                          },
                          iconColor: AppColors.textLightGray,
                          collapsedIconColor: AppColors.textLightGray,
                          trailing: settingLogic.getIcon(12),
                          title: Text(
                            '6. Backups',
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
