import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

part './apple.dart';
part 'google.dart';
part 'facebook.dart';

class LoginButton extends StatelessWidget {
  final void Function() onPress;
  final ButtonLoginType typeButton;
  const LoginButton({Key? key, required this.onPress, required this.typeButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      icon: typeButton.icon,
      onPressed: onPress,
      child: Text(
        typeButton.text,
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
}

enum ButtonLoginType { facebook, google, apple }

extension on ButtonLoginType {
  String get text {
    switch (this) {
      case ButtonLoginType.apple:
        return LocaleKeys.signupOptionApple.tr();
      case ButtonLoginType.facebook:
        return LocaleKeys.signupOptionFacebook.tr();
      default:
        return LocaleKeys.signupOptionGoogle.tr();
    }
  }

  String get icon {
    switch (this) {
      case ButtonLoginType.apple:
        return Assets.icons.apple;
      case ButtonLoginType.facebook:
        return Assets.icons.fb;
      default:
        return Assets.icons.google;
    }
  }
}
