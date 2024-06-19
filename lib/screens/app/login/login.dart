import 'dart:async';
import 'dart:io';
// import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/api_client.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/utils/regex_validate/validate.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/buttons_login/buttons_login.dart';
import 'package:skin_detective/widgets/input_widget/input_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skin_detective/widgets/logic_widget/logic_widget.dart';
part 'login.logic.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with LogicState<Login, LoginLogic> {
  final _formKey = GlobalKey<FormState>();
  bool isHide = false;

  @override
  void initState() {
    super.initState();
    isHide = !Navigator.canPop(context);
  }

  Widget getButton({
    required void Function()? onPressed,
    required String label,
    required String icon,
  }) {
    return ButtonWidget(
      icon: icon,
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.caption!.merge(
              const TextStyle(
                fontSize: 12,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
      type: EButton.full,
      primary: AppColors.white,
      elevation: 0,
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: !isHide
          ? AppBarWidget(
              centerTitle: false,
              title: LocaleKeys.generalBack.tr(),
              isHide: isHide,
            )
          : null,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32 - 5,
            ).copyWith(
                top: isHide
                    ? Helper.percentHeight(pixel: 70, context: context)
                    : 0,
                bottom: 50 + insetsBottom(context)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32, top: 12),
                  child: Text(
                    LocaleKeys.generalLoginButton.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                          fontFamily: Assets.googleFonts.montserratBlack,
                        ),
                  ),
                ),
                TextFieldCustom(
                  controller: logic._emailController,
                  onChanged: logic.updateEmail,
                  labelText: LocaleKeys.generalEmailLable.tr(),
                  autoFocus: false,
                  validator: logic.onValidatorEmail,
                  keyboardType: TextInputType.emailAddress,
                  label: LocaleKeys.generalEmailLable.tr(),
                ),
                TextFieldCustom(
                  controller: logic._passwordController,
                  onChanged: logic.updatePassword,
                  obscureText: true,
                  labelText: LocaleKeys.generalPasswordLable.tr(),
                  autoFocus: false,
                  validator: logic.onValidatorPassword,
                  keyboardType: TextInputType.emailAddress,
                  label: LocaleKeys.generalPasswordLable.tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0, bottom: 32.0),
                  child: Selector<LoginLogic, bool>(
                      selector: (_, state) => state.enableBtnLogin,
                      builder: (context, enable, __) {
                        return ButtonWidget(
                          onPressed: () {
                            if (logic.checkLogin() &&
                                enable &&
                                _formKey.currentState!.validate()) {
                              logic._loginUser();
                            }
                          },
                          child: Text(
                            LocaleKeys.generalLoginButton.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        Assets.googleFonts.montserratBlack,
                                    height: 1.66),
                          ),
                          type: EButton.full,
                          primary: enable
                              ? AppColors.primary
                              : AppColors.textLightGrayDisabled,
                          elevation: 0,
                        );
                      }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.confirmEmail),
                      child: Text(
                        LocaleKeys.loginForgotPasssword.tr(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: AppColors.textBlue,
                              fontWeight: FontWeight.w700,
                              fontFamily: Assets.googleFonts.montserratBlack,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.loginQuestion.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        Assets.googleFonts.montserratBlack,
                                  )),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.signUpPage),
                            child: Text(
                              LocaleKeys.loginSingup.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: AppColors.textBlue,
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        Assets.googleFonts.montserratBlack,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Row(children: [
                        const Expanded(
                          child: Divider(color: AppColors.textLightGray),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            LocaleKeys.loginOr.tr(),
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                  const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textLightGray,
                                  ),
                                ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.textLightGray),
                        ),
                      ]),
                    ),
                    if (Platform.isIOS)
                      LoginButton(
                        onPress: logic.loginWithApple,
                        typeButton: ButtonLoginType.apple,
                      ),
                    const SizedBox(height: 12),
                    LoginButton(
                      onPress: logic.loginWithFacebook,
                      typeButton: ButtonLoginType.facebook,
                    ),
                    const SizedBox(height: 12),
                    LoginButton(
                      onPress: logic.loginByGoogle,
                      typeButton: ButtonLoginType.google,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginLogic initViewModel(BuildContext context) {
    return LoginLogic(context: context);
  }
}
