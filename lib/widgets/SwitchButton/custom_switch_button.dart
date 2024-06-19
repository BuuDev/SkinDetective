import 'package:flutter/cupertino.dart';
import 'package:skin_detective/theme/color.dart';

class CustomSwitchButton extends StatefulWidget {
  const CustomSwitchButton({Key? key, required this.tick, this.onChanged})
      : super(key: key);

  final bool tick;
  final Function(bool)? onChanged;

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: 37,
      child: CupertinoSwitch(
        value: widget.tick,
        onChanged: widget.onChanged,
        activeColor: AppColors.primary,
        trackColor: AppColors.textLightBlue,
      ),
    );
  }
}
