import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/local_storage.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

class DoubleButtonWidget extends StatelessWidget {
  final String titleLeft;
  final String titleRight;

  const DoubleButtonWidget({
    Key? key,
    this.titleLeft = '',
    this.titleRight = '',
  }) : super(key: key);

  void onLeft(context) {
    LocalStorage.instance.setFirstOpenApp(true);
    NavigationService.gotoAnotherStack(
        stackPage: AppRoutes.auth, initRoute: AppRoutes.signUpPage);
  }

  void onRight(context) async {
    LocalStorage.instance.setFirstOpenApp(true);
    NavigationService.gotoAnotherStack(
        stackPage: AppRoutes.auth, initRoute: AppRoutes.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              child: Text(
                titleLeft,
                style: Theme.of(context).textTheme.subtitle1!.merge(
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
              ).tr(),
              onPressed: () {
                onLeft(context);
              },
            ),
          ),
          SizedBox(width: Helper.percentWidth(pixel: 9, context: context)),
          Expanded(
            child: ButtonWidget(
              child: Text(
                titleRight,
                style: Theme.of(context).textTheme.subtitle1!.merge(
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBlack,
                      ),
                    ),
              ).tr(),
              onPressed: () => onRight(context),
              primary: AppColors.textLightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
