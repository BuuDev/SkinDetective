import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/input_widget/input_widget.dart';
import 'package:skin_detective/utils/regex_validate/validate.dart';
import '../../../routes/routes.dart';
import 'signup_email_logic.dart';
part '../sign_up/sign_Up/signup_logic.dart';

class SignUpEmailTestError extends StatefulWidget {
  const SignUpEmailTestError({Key? key}) : super(key: key);

  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmailTestError> {
  late SignUpLogic signUpLogic;
  late SignUp otpAuthen;
  final _formKey = GlobalKey<FormState>();
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    signUpLogic = SignUpLogic(context: context);
    otpAuthen = SignUp(context: context);
    controller = ScrollController();
  }

  @override
  void dispose() {
    signUpLogic.dispose();
    super.dispose();
  }

  scrollToBottom() {
    if (controller.hasClients) {
      final position = controller.position.maxScrollExtent;
      controller.animateTo(position,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        centerTitle: false,
        title: LocaleKeys.generalBack.tr(),
        textStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: AppColors.textLightGray),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ChangeNotifierProvider.value(
              value: signUpLogic,
              child: Consumer<SignUpLogic>(
                builder: (_, value, child) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.generalSignupButton.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color: AppColors.textBlack,
                                fontWeight: FontWeight.w700,
                                fontFamily: Assets.googleFonts.montserratBlack,
                              ),
                        ),
                        const SizedBox(height: 35),
                        AspectRatio(
                          aspectRatio: 3 / 1.5,
                          child: Image.asset(
                            Assets.images.splash.path,
                          ),
                        ),
                        TextFieldCustom(
                          onTap: scrollToBottom,
                          controller: signUpLogic.emailController,
                          onChanged: (text) {
                            signUpLogic.validateEmail();
                            signUpLogic.enableBtnRegister();
                          },
                          label: LocaleKeys.generalEmailLable.tr(),
                          labelText: LocaleKeys.generalEmailLable.tr(),
                          errorText: signUpLogic.errorEmail,
                          errBorder: signUpLogic.errorEmail != null,
                        ),
                        const SizedBox(height: 8),
                        TextFieldCustom(
                          onTap: scrollToBottom,
                          controller: signUpLogic.passwordController,
                          onChanged: (value) {
                            signUpLogic.validatePass();
                            signUpLogic.validateConfirmPass();
                            signUpLogic.enableBtnRegister();
                          },
                          label: LocaleKeys.generalPasswordLable.tr(),
                          labelText: LocaleKeys.generalPasswordLable.tr(),
                          errorText: signUpLogic.errorPassword,
                          errBorder: signUpLogic.errorPassword != null,
                          obscureText: true,
                          surFixIcon: signUpLogic.errorPassword != null
                              ? const Icon(
                                  Icons.warning_amber,
                                  color: AppColors.red,
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        TextFieldCustom(
                          onTap: scrollToBottom,
                          controller: signUpLogic.confirmPasswordController,
                          onChanged: (value) {
                            signUpLogic.validateConfirmPass();
                            signUpLogic.enableBtnRegister();
                          },
                          label: LocaleKeys.rePassLable.tr(),
                          labelText: LocaleKeys.rePassLable.tr(),
                          errorText: signUpLogic.errorConfirmPassword,
                          errBorder: signUpLogic.errorConfirmPassword != null,
                          obscureText: true,
                          surFixIcon: signUpLogic.errorConfirmPassword != null
                              ? const Icon(
                                  Icons.warning_amber,
                                  color: AppColors.red,
                                )
                              : null,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<bool>(
                                valueListenable: signUpLogic.check,
                                builder: (_, state, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      signUpLogic.check.value =
                                          !signUpLogic.check.value;
                                      signUpLogic.enableBtnRegister();
                                    },
                                    child: SvgPicture.asset(
                                      signUpLogic.check.value
                                          ? Assets.icons.radioButtonActive1
                                          : Assets.icons.radioButton1,
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: LocaleKeys.generalCheckPart1.tr() + ' ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textBlack,
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            Assets.googleFonts.montserratBlack,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: LocaleKeys.generalCheckPart2.tr() +
                                          ' ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: AppColors.textBlueBG,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: Assets
                                                .googleFonts.montserratBlack,
                                          ),
                                    ),
                                    TextSpan(
                                        text:
                                            LocaleKeys.generalCheckPart3.tr() +
                                                ' ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: AppColors.textBlack,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: Assets
                                                  .googleFonts.montserratBlack,
                                            )),
                                    TextSpan(
                                      text: LocaleKeys.generalCheckPart4.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: AppColors.textBlueBG,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: Assets
                                                .googleFonts.montserratBlack,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 32, bottom: 5),
                          width: double.infinity,
                          child: ButtonWidget(
                            onPressed: () {
                              signUpLogic.validateSignUp();
                              signUpLogic.checkedSuccessSignUp();
                            },
                            child: Text(
                              LocaleKeys.generalSignupButton.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        Assets.googleFonts.montserratBlack,
                                  ),
                            ),
                            primary: !signUpLogic.enable
                                ? AppColors.textLightGray
                                : AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        )
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
