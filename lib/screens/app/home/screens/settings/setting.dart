import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart'
    show
        BuildContextEasyLocalizationExtension,
        StringTranslateExtension,
        TextTranslateExtension;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/rating/average_rating.dart';
import 'package:skin_detective/models/setting_device/setting_device.dart';
import 'package:skin_detective/models/user_setting/user_setting.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/rating_app/rating_app.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/SwitchButton/custom_switch_button.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/logic_widget/logic_widget.dart';

import '../../../../../services/apis/user/user.dart';
import '../../../../../utils/multi_languages/locale_keys.dart';
part 'setting_logic.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin, LogicState<SettingPage, SettingLogic> {
  @override
  void initState() {
    super.initState();
    logic.getSettingUser();
  }

  Widget boxWidget({required Widget child}) {
    return Material(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      shadowColor: AppColors.textLightBlue,
      child: child,
    );
  }

  Widget get spacer => const SizedBox(height: 12);

  @override
  Widget buildWidget(BuildContext context) {
    debugPrint('render: ${context.locale}');
    return SizedBox(
      height: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: AppColors.backgroundColor,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24)
              .copyWith(top: 24, bottom: 100),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              boxWidget(
                child: CustomExpansionTile(
                    onExpansionChanged: (value) {
                      logic.updateBtn(0);
                    },
                    leading: Assets.icons.bellIcon,
                    index: 0,
                    title: LocaleKeys.settingNotification.tr(),
                    children: [
                      ListTile(
                        title: Text(
                          LocaleKeys.settingNotificationNewCategories.tr(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        trailing: Selector<SettingLogic, bool>(
                          selector: (_, state) => state.lstBtnToggle[0],
                          builder: (_, value, __) {
                            return CustomSwitchButton(
                              tick: value,
                              onChanged: (value) {
                                logic.updateBtnToggle(0);
                              },
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(
                          LocaleKeys.settingNotificationPost.tr(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        trailing: Selector<SettingLogic, bool>(
                          selector: (_, state) => state.lstBtnToggle[1],
                          builder: (_, value, __) {
                            return CustomSwitchButton(
                              tick: value,
                              onChanged: (value) {
                                logic.updateBtnToggle(1);
                              },
                            );
                          },
                        ),
                      ),
                    ]),
              ),
              spacer,
              boxWidget(
                child: CustomExpansionTile(
                  title: LocaleKeys.settingTutorial.tr(),
                  onExpansionChanged: (value) {
                    logic.updateBtn(1);
                  },
                  leading: Assets.icons.boards,
                  index: 1,
                  children: [
                    ListTile(
                      title: Text(
                        LocaleKeys.settingTutorialAnalysis.tr(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      subtitle: Text(
                        LocaleKeys.settingTutorialDirection.tr(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: AppColors.gray,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                      trailing: Selector<SettingLogic, bool>(
                        selector: (_, state) => state.lstBtnToggle[2],
                        builder: (_, value, __) {
                          return CustomSwitchButton(
                            tick: value,
                            onChanged: (value) {
                              logic.updateBtnToggle(2);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              spacer,
              boxWidget(
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    Navigator.pushNamed(context, AppRoutes.question);
                  },
                  leading: SvgPicture.asset(
                    Assets.icons.question,
                    color: AppColors.textBlack,
                  ),
                  trailing: SvgPicture.asset(Assets.icons.arrowRight),
                  title: Text(
                    LocaleKeys.settingQuestion.tr(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              spacer,
              boxWidget(
                child: CustomExpansionTile(
                  leading: Assets.icons.translate,
                  index: 2,
                  onExpansionChanged: (value) {
                    logic.updateBtn(2);
                  },
                  title: LocaleKeys.settingLanguage.tr(),
                  children: [
                    ...LocaleKeys.supportedLocales.map((item) {
                      return ListTile(
                        onTap: () {
                          if (GetIt.instance<AppVM>().isLogged) {
                            context.setLocale(item);
                            item == LocaleKeys.supportedLocales[0]
                                ? logic.changeLanguageApi(getLang(lang.vn))
                                : logic.changeLanguageApi(getLang(lang.en));
                          }
                        },
                        title: Text(
                          LocaleKeys.settingLanguage,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ).tr(gender: item.languageCode),
                        trailing: context.locale.countryCode == item.countryCode
                            ? const Icon(
                                Icons.check,
                                color: AppColors.textBlue,
                              )
                            : null,
                      );
                    }).toList(),
                  ],
                ),
              ),
              spacer,
              boxWidget(
                child: CustomExpansionTile(
                    leading: Assets.icons.shieldCheck,
                    index: 3,
                    onExpansionChanged: (value) {
                      logic.updateBtn(3);
                    },
                    title: LocaleKeys.settingJuridical.tr(),
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.term);
                        },
                        title: Text(
                          LocaleKeys.settingJuridicalRules.tr(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        trailing: SvgPicture.asset(Assets.icons.arrowRight),
                      ),
                      ListTile(
                        title: Text(
                          LocaleKeys.settingJuridicalPolicy.tr(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        trailing: SvgPicture.asset(Assets.icons.arrowRight),
                      )
                    ]),
              ),
              const SizedBox(height: 12),
              boxWidget(
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    Navigator.pushNamed(context, AppRoutes.rating);
                  },
                  leading: SvgPicture.asset(Assets.icons.pen),
                  title: Text(
                    LocaleKeys.settingRating.tr(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  trailing: SvgPicture.asset(Assets.icons.arrowRight),
                ),
              ),
              spacer,
              spacer,
              SizedBox(
                width: double.infinity,
                height: 49,
                child: Selector<AppVM, bool>(
                  selector: (_, state) => state.isLogged,
                  builder: (_, value, __) {
                    return ButtonWidget(
                      onPressed: context.read<AppVM>().logoutSetting,
                      child: Text(
                        value
                            ? LocaleKeys.generalLogoutButton.tr()
                            : LocaleKeys.generalLoginButton.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      primary: AppColors.textLightBlue,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  SettingLogic initViewModel(BuildContext context) {
    return SettingLogic(context: context);
  }
}
