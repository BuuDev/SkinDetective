import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../theme/color.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import 'package:otp_text_field/otp_field.dart';
part 'sign_up_authen_logic.dart';

class LoginConfirm extends StatefulWidget {
  const LoginConfirm({Key? key}) : super(key: key);

  @override
  _LoginConfimState createState() => _LoginConfimState();
}

class _LoginConfimState extends State<LoginConfirm> {
  late LogicAuthen otpAuthen;
  Timer? timer;
  int seconds = 60;

  @override
  void initState() {
    starTimer();
    otpAuthen = LogicAuthen(context: context);
    super.initState();
  }

  @override
  void dispose() {
    otpAuthen.dispose();
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
    List emailController = ModalRoute.of(context)!.settings.arguments as List;

    return ChangeNotifierProvider.value(
      value: otpAuthen,
      child: Consumer<LogicAuthen>(
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
                          LocaleKeys.signupEmailConfirmcodeTitle,
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
                              LocaleKeys.confirmcodeContent,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontFamily:
                                        Assets.googleFonts.montserratRegular,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textBlack,
                                  ),
                            ).tr()),
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
                            controller: otpAuthen.otpController1,
                            onChanged: (pin) {
                              otpAuthen.otp = pin;
                              otpAuthen.validateOtp();
                            },
                            onCompleted: (otpController1) {
                              otpAuthen.otp = otpController1;
                              otpAuthen.validateOtp();
                            }),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ButtonWidget(
                              onPressed: () {
                                if (otpAuthen.enable) {
                                  otpAuthen.authenOtp(emailController[0],
                                      otpAuthen.otp!, emailController[1]);
                                }
                              },
                              child: Text(
                                LocaleKeys.confirm,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBlack,
                                      color: AppColors.white,
                                    ),
                              ).tr(),
                              primary: otpAuthen.enable
                                  ? AppColors.primary
                                  : AppColors.textLightGrayDisabled),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.confirmcodeReSendOtpQuestion,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBlack,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    ),
                              ).tr(),
                              const SizedBox(
                                height: 30,
                              ),
                              seconds == 0
                                  ? InkWell(
                                      onTap: () {
                                        otpAuthen.confirmEmail(
                                            emailController[0],
                                            emailController[1]);
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
