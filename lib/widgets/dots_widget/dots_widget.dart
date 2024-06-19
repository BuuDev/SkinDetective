import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';

///Example: DotsWidget()
/// Tạo ra nhiều đốt ... cho pageView

class DotsWidget extends AnimatedWidget {
  const DotsWidget({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.indexSelected = 0,
    required this.direction,
    this.colorActive = AppColors.textBlue,
    this.colorInactive = AppColors.textLightBlue,
    this.isUseWeightHorizontal = false,
  }) : super(key: key, listenable: controller);

  /// The color of the dots.
  final Color colorActive;
  final Color colorInactive;
  final EDot? direction;

  ///Sư dụng active weight chiều ngang
  final bool isUseWeightHorizontal;

  /// index selected from onChangePage
  final int indexSelected;

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  // The base size of the dots
  static const double _kDotSize = 6.0;

  // The increase in the size of the selected dot

  Widget _buildDot(int index, BuildContext context) {
    if ((index + 1) % 2 == 0) {
      return SizedBox(
        width: Helper.percentWidth(pixel: 6.0),
      );
    }

    var sizeDot = Helper.percentWidth(pixel: _kDotSize, context: context);

    if (indexSelected * 2 == index && isUseWeightHorizontal) {
      return Container(
        height: 8,
        width: 32,
        decoration: BoxDecoration(
          color: colorActive,
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
        ),
      );
    }

    return SizedBox(
      width: sizeDot,
      height: sizeDot,
      child: Container(
        decoration: BoxDecoration(
          color: indexSelected * 2 == index ? colorActive : colorInactive,
          borderRadius: BorderRadius.all(
            Radius.circular(sizeDot),
          ),
        ),
        child: InkWell(
          onTap: () => {onPageSelected(index)},
        ),
      ),
    );
  }

  Widget _buildRectangle(int index, BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: indexSelected == index
              ? Image.asset(
                  Assets.images.recVertical.path,
                  height: 32,
                  width: 5,
                  fit: BoxFit.contain,
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: SvgPicture.asset(
                    Assets.icons.dotBlueGray,
                    width: 6,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (direction == EDot.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          itemCount * 2 - 1,
          (index) => _buildDot(index, context),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
          itemCount, (index) => _buildRectangle(index, context)),
    );
  }
}
