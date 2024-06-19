import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../routes/routes.dart';
import '../../../../services/apis/user/user.dart';
import '../../../../theme/color.dart';
import '../../../../widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import '../../../../widgets/input_widget/input_widget.dart';
part 'confirm_password_logic.dart';

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({Key? key}) : super(key: key);

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  late ResetPassWord reset;

  @override
  void initState() {
    super.initState();

    reset = ResetPassWord(context: context);
  }

  @override
  void dispose() {
    reset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List data = ModalRoute.of(context)!.settings.arguments as List;

    return ChangeNotifierProvider.value(
      value: reset,
      child: Consumer<ResetPassWord>(
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
                //
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.resetPasswordTitle.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBlack,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                                height: 3,
                              ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldCustom(
                          controller: reset.password,
                          onChanged: (text) {
                            reset.validatePassWord();
                          },
                          obscureText: true,
                          label: LocaleKeys.generalPasswordLable.tr(),
                          labelText: LocaleKeys.generalPasswordLable.tr(),
                          keyboardType: TextInputType.text,
                          errorText: reset.err,
                          errBorder: reset.err != null,
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
                          controller: reset.confirmPassword,
                          onChanged: (text) {
                            reset.validateConfirmPassWord();
                          },
                          obscureText: true,
                          label: LocaleKeys.rePassLable.tr(),
                          labelText: LocaleKeys.rePassLable.tr(),
                          keyboardType: TextInputType.text,
                          errorText: reset.err1,
                          errBorder: reset.err1 != null,
                          surFixIcon: reset.err1 != null
                              ? const Icon(
                                  Icons.warning_amber,
                                  color: AppColors.red,
                                )
                              : null,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ButtonWidget(
                            onPressed: () {
                              if (reset.enable) {
                                reset.resetPassWord(
                                    data[0], data[1], reset.password.text);
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
                                  ),
                            ),
                            primary: reset.enable
                                ? AppColors.primary
                                : AppColors.textLightGrayDisabled,
                          ),
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
