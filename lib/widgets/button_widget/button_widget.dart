import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';

///Example: ButtonWidget()

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final Color? primary;
  final Color? color;

  ///Type:
  ///* [EButton.normal]: theo kích thước của widget con
  ///* [EButton.full]: auto full theo kích cỡ widget con
  final EButton? type;

  final String? icon;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final bool? isPaddingRightText;

  const ButtonWidget({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color,
    this.primary,
    this.type,
    this.elevation,
    this.icon,
    this.padding,
    this.isPaddingRightText,
  }) : super(key: key);

  Widget getIcon() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SvgPicture.asset(
            icon ?? Assets.icons.apple,
            color: color,
          ),
        ),
        Expanded(
          child: Center(child: child),
        ),
        isPaddingRightText == true
            ? const Padding(
                padding: EdgeInsets.only(right: 40),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget getPadding() {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: icon != null ? getIcon() : child,
    );
  }

  Widget getButton() {
    return ElevatedButton(
      onPressed: onPressed,
      child: getPadding(),
      style: ElevatedButton.styleFrom(
          primary: primary ?? const Color(0xFF5A85F4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: elevation ?? 0.0,
          padding: EdgeInsets.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == EButton.full) {
      return Row(
        children: [
          Expanded(
            child: getButton(),
          ),
        ],
      );
    }

    return getButton();
  }
}
