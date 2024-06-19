import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../theme/color.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import '../../../../widgets/input_widget/input_widget.dart';
part 'reset_password_logic.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  late ResetPassWordLogic reset;

  @override
  void initState() {
    reset = ResetPassWordLogic(context: context);
    super.initState();
  }

  @override
  void dispose() {
    reset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: reset,
      child: Consumer<ResetPassWordLogic>(
        builder: (context, value, child) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBarWidget(
                  title: LocaleKeys.generalBack.tr(),
                  centerTitle: false,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.profileResetPasswordLable,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBold,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                                height: 2,
                              ),
                        ).tr(),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldCustom(
                          controller: reset.txtOldPass,
                          onChanged: (text) {
                            reset.validateOldPassWord();
                          },
                          label: LocaleKeys.profileOldPasswordLable.tr(),
                          labelText:
                              LocaleKeys.profileOldPasswordPlaceholder.tr(),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        TextFieldCustom(
                          obscureText: true,
                          controller: reset.txtNewPass,
                          onChanged: (text) {
                            reset.validatePassWord();
                          },
                          label: LocaleKeys.profileNewPasswordLable.tr(),
                          labelText:
                              LocaleKeys.profileNewPasswordPlaceholder.tr(),
                          keyboardType: TextInputType.text,
                          errBorder: reset.err != null,
                          errorText: reset.err,
                          surFixIcon: reset.err != null
                              ? const Icon(
                                  Icons.warning_amber,
                                  color: AppColors.red,
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldCustom(
                          obscureText: true,
                          controller: reset.txtConfirmPass,
                          onChanged: (text) {
                            reset.validateConfirmPassWord();
                          },
                          label: LocaleKeys.profileEnterNewPasswordLable.tr(),
                          labelText: LocaleKeys
                              .profileEnterNewPasswordPlaceholder
                              .tr(),
                          keyboardType: TextInputType.text,
                          errBorder: reset.err1 != null,
                          errorText: reset.err1,
                          surFixIcon: reset.err1 != null
                              ? const Icon(
                                  Icons.warning_amber,
                                  color: AppColors.red,
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ButtonWidget(
                              onPressed: () {
                                if (reset.enable) {
                                  reset.changePassword();
                                }
                              },
                              child: Text(
                                LocaleKeys.signupEmailEnterinforButton.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        fontFamily:
                                            Assets.googleFonts.montserratBlack,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                        height: 1.66),
                              ),
                              primary: reset.enable
                                  ? AppColors.primary
                                  : AppColors.textLightGrayDisabled),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
