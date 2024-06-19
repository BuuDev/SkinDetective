import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../routes/routes.dart';
import '../../../../services/apis/user/user.dart';
import '../../../../theme/color.dart';
import '../../../../utils/notify_helper/notify_helper.dart';
import '../../../../utils/regex_validate/validate.dart';
import '../../../../widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import '../../../../widgets/input_widget/input_widget.dart';

part 'confirm_email_logic.dart';

class ConFirmEmail extends StatefulWidget {
  const ConFirmEmail({Key? key}) : super(key: key);

  @override
  State<ConFirmEmail> createState() => _ConFirmEmailState();
}

class _ConFirmEmailState extends State<ConFirmEmail> {
  late ConfirmEmailLogic confirmEmail;

  @override
  void initState() {
    super.initState();

    confirmEmail = ConfirmEmailLogic(context: context);
  }

  @override
  void dispose() {
    confirmEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: confirmEmail,
      child: Consumer<ConfirmEmailLogic>(
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
                          LocaleKeys.resetPasswordTitle,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBold,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                                height: 3,
                              ),
                        ).tr(),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              LocaleKeys.resetPasswordMess,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textBlack,
                                  ),
                            ).tr()),
                        const SizedBox(
                          height: 35,
                        ),
                        TextFieldCustom(
                          controller: confirmEmail.emailController,
                          onChanged: (text) {
                            confirmEmail.validateEmail();
                          },
                          label: LocaleKeys.generalEmailLable.tr(),
                          labelText: LocaleKeys.generalEmailLable.tr(),
                          keyboardType: TextInputType.emailAddress,
                          errorText: confirmEmail.err,
                          errBorder: confirmEmail.err != null,
                          surFixIcon: confirmEmail.err != null
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
                              if (confirmEmail.enable) {
                                confirmEmail.confirmEmail(
                                    confirmEmail.emailController.text);
                              }
                            },
                            child: Text(
                              LocaleKeys.signupEmailEnterinforButton,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontFamily:
                                        Assets.googleFonts.montserratBlack,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ).tr(),
                            primary: confirmEmail.enable
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
