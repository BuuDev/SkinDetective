import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/login/login.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

import '../../../../widgets/buttons_login/buttons_login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool get isHide {
    return !Navigator.canPop(context);
  }

  late LoginLogic loginLogic;
  @override
  void initState() {
    super.initState();
    loginLogic = LoginLogic(context: context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginLogic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !isHide
          ? AppBarWidget(
              centerTitle: false,
              title: LocaleKeys.generalBack.tr(),
              isHide: isHide)
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 40,
          bottom: 50 + insetsBottom(context),
          left: 32,
          right: 32,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.generalSignupButton.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w700,
                        fontFamily: Assets.googleFonts.montserratBlack,
                      ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: AspectRatio(
                aspectRatio: 3 / 1.5,
                child: Assets.images.splash.image(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: ButtonWidget(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.signUpEmailForm);
                },
                child: Text(
                  LocaleKeys.signupOptionEmail.tr(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: Assets.googleFonts.montserratBlack,
                      ),
                ),
                icon: Assets.icons.mail,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.signupHaveAccount.tr(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700,
                          fontFamily: Assets.googleFonts.montserratBlack,
                        )),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.loginPage);
                  },
                  child: Text(
                    LocaleKeys.generalLoginButton.tr(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: Assets.googleFonts.montserratBlack,
                        ),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 129,
              child: Divider(
                height: 2,
                color: AppColors.textLightGray,
              ),
            ),
            const SizedBox(height: 12),
            if (Platform.isIOS)
              LoginButton(
                onPress: loginLogic.loginWithApple,
                typeButton: ButtonLoginType.apple,
              ),
            const SizedBox(height: 12),
            LoginButton(
              onPress: loginLogic.loginWithFacebook,
              typeButton: ButtonLoginType.facebook,
            ),
            const SizedBox(height: 12),
            LoginButton(
              onPress: loginLogic.loginByGoogle,
              typeButton: ButtonLoginType.google,
            ),
          ],
        ),
      ),
    );
  }
}
