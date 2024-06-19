import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../gen/assets.gen.dart';

class CategoryWidget extends StatelessWidget {
  final bool isMore;
  final String? title;
  final String? customTitle;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  const CategoryWidget({
    Key? key,
    required this.title,
    this.isMore = true,
    this.onTap,
    this.customTitle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 12)
          .add(padding ?? EdgeInsets.zero),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "Bài viết mới nhất",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: AppColors.textBlueBlack,
                  fontWeight: FontWeight.w700,
                  fontFamily: Assets.googleFonts.montserratBold,
                  height: 1.3,
                ),
          ).tr(args: [customTitle ?? '']),
          if (isMore)
            InkWell(
              onTap: onTap,
              child: Text(
                LocaleKeys.generalShowMore,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                      fontFamily: Assets.googleFonts.montserratBold,
                    ),
              ).tr(),
            )
        ],
      ),
    );
  }
}
