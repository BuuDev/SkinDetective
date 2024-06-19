import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final double? elevation;
  final bool? centerTitle;
  final String? title;
  final Widget? customTitle;
  final List<Widget> action;
  final TextStyle? textStyle;
  final Widget? leading;

  ///ẩn icon appbar
  final bool isHide;
  final PreferredSizeWidget? bottom;
  final double? leadingWidth;

  const AppBarWidget({
    Key? key,
    this.backgroundColor,
    this.elevation,
    this.centerTitle,
    this.title,
    this.action = const [],
    this.textStyle,
    this.leading,
    this.isHide = false,
    this.customTitle,
    this.bottom,
    this.leadingWidth,
  }) : super(key: key);

  Widget getLeading(context) {
    if (isHide == false) {
      return leading ??
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              Assets.icons.arrowLeftBack,
              fit: BoxFit.scaleDown,
            ),
          );
    }
    return const SizedBox.shrink();
  }

  TextStyle titleStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1!.merge(
          textStyle ??
              const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLightGray,
                  height: 1.5),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? 0,
      backgroundColor: backgroundColor ?? AppColors.textLightGrayBG,
      centerTitle: centerTitle ?? true,
      bottom: bottom,
      leadingWidth: leadingWidth,
      titleSpacing: (centerTitle ?? true) ? null : 0,

      leading: getLeading(context),
      // automaticallyImplyLeading: false,
      title: customTitle == null
          ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                title ?? '',
                textAlign: TextAlign.left,
                style: titleStyle(context),
              ),
            )
          : customTitle!,
      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
  bool get wantKeepAlive => true;
}
