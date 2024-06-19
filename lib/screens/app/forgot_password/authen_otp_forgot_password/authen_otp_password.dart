import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../services/apis/user/user.dart';
import '../../../../theme/color.dart';
import '../../../../utils/notify_helper/notify_helper.dart';
import '../../../../widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../widgets/button_widget/button_widget.dart';
part 'authen_otp_password_logic.dart';

class AuthenOtpPassword extends StatefulWidget {
  const AuthenOtpPassword({Key? key}) : super(key: key);

  @override
  State<AuthenOtpPassword> createState() => _AuthenPasswordState();
}

class _AuthenPasswordState extends State<AuthenOtpPassword> {
  late LogicAuthenPassword forgot;
  Timer? timer;
  int seconds = 60;

  @override
  void initState() {
    starTimer();
    forgot = LogicAuthenPassword(context: context);
    super.initState();
  }

  @override
  void dispose() {
    forgot.dispose();
    starTimer();
    super.dispose();
  }

  void starTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        // ignore: unnecessary_this
        if (this.mounted) {
          setState(() {
            seconds--;
          });
        }
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String emailController =
        ModalRoute.of(context)!.settings.arguments as String;
    return ChangeNotifierProvider.value(
      value: forgot,
      child: Consumer<LogicAuthenPassword>(
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
                                fontFamily: Assets.googleFonts.montserratBold,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                                height: 3,
                              ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              LocaleKeys.confirmcodeContent.tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: AppColors.textBlack,
                                  ),
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlue,
                                    ),
                            textFieldAlignment: MainAxisAlignment.center,
                            fieldStyle: FieldStyle.box,
                            keyboardType: TextInputType.number,
                            controller: forgot.otpController,
                            onChanged: (pin) {
                              forgot.otp = pin;
                              forgot.validateOtp();
                            },
                            onCompleted: (pin) {
                              forgot.otp = pin;
                              forgot.validateOtp();
                            }),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ButtonWidget(
                            onPressed: () {
                              if (forgot.enable) {
                                forgot.authenOtp(emailController, forgot.otp!);
                              }
                            },
                            child: Text(
                              LocaleKeys.confirm.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontFamily:
                                        Assets.googleFonts.montserratBold,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                            ),
                            primary: forgot.enable
                                ? AppColors.primary
                                : AppColors.textLightGrayDisabled,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.confirmcodeReSendOtpQuestion.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBlack,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    ),
                              ),
                              seconds == 0
                                  ? InkWell(
                                      onTap: () {
                                        forgot.confirmEmail(emailController);
                                        seconds = 60;
                                        starTimer();
                                      },
                                      child: Text(
                                          LocaleKeys
                                              .confirmcodeReSendOtpContent,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontFamily: Assets.googleFonts
                                                    .montserratBlack,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              )).tr())
                                  : InkWell(
                                      onTap: () {},
                                      child: Text(
                                          LocaleKeys.confirmcodeReSendOtpText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontFamily: Assets.googleFonts
                                                    .montserratBlack,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors
                                                    .textLightGrayDisabled,
                                              )).tr(args: ['$seconds']))
                            ],
                          ),
                        ),
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
