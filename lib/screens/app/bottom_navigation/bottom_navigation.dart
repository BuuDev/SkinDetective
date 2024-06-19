import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

const double sizeIcon = 30;

class BottomNavigation extends StatefulWidget {
  final void Function(int index, BottomNavModel data) pressed;
  final int index;
  const BottomNavigation({
    Key? key,
    required this.pressed,
    required this.index,
  }) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();

  static List<BottomNavModel> getDataItems(BuildContext context) => [
        BottomNavModel(
          id: 1,
          title: LocaleKeys.tabbarDoctor,
          icon: Assets.icons.doctor,
        ),
        BottomNavModel(
          id: 2,
          title: LocaleKeys.tabbarSpa,
          icon: Assets.icons.spa,
        ),
        BottomNavModel(
          id: 3,
          title: LocaleKeys.homeTitle,
          icon: Assets.icons.home,
        ),
        BottomNavModel(
          id: 4,
          title: LocaleKeys.tabbarCategories,
          icon: Assets.icons.article,
        ),
        BottomNavModel(
          id: 5,
          title: LocaleKeys.tabbarSetting,
          icon: Assets.icons.setting,
        ),
      ];
}

class BottomNavigationState extends State<BottomNavigation> {
  static double heightInsets(BuildContext context) {
    double insets = MediaQuery.of(context).viewPadding.bottom;
    // double extraHeight = insets > 0 ? 10 : 0;
    //Platform.isIOS ? extraHeight :
    return insets;
  }

  void onPressItem(int index, BottomNavModel item) {
    widget.pressed(index, item);
  }

  static double get maxHeight {
    return 5 + sizeIcon + 13 + 5 + 15 + 5;
  }

  @override
  Widget build(BuildContext context) {
    var dataItems = BottomNavigation.getDataItems(context);

    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
          border: Border.all(
            color: AppColors.textLightBlue,
            width: 0.5,
          )),
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: Material(
        elevation: 0,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        color: Colors.white,
        child: Inwe(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: dataItems
                .map(
                  (item) => Expanded(
                    child: _ItemBottomNav(
                      index: item.id - 1,
                      length: dataItems.length,
                      model: item,
                      idSelected: dataItems[widget.index].id,
                      pressed: () => onPressItem(item.id - 1, item),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavModel {
  late int id;
  late String title;

  ///This is Svg file
  late IconData? assetIcon;

  late String? icon;

  BottomNavModel({
    required this.id,
    required this.title,
    this.icon,
    this.assetIcon,
  });
}

///Item bottom nav
class _ItemBottomNav extends StatefulWidget {
  final BottomNavModel model;
  final int idSelected;
  final void Function() pressed;
  final int length;
  final int index;

  const _ItemBottomNav({
    Key? key,
    required this.model,
    required this.idSelected,
    required this.pressed,
    required this.length,
    required this.index,
  }) : super(key: key);

  @override
  __ItemBottomNavState createState() => __ItemBottomNavState();
}

class __ItemBottomNavState extends State<_ItemBottomNav>
    with SingleTickerProviderStateMixin {
  bool get isSelected => widget.idSelected == widget.model.id;

  Widget get icon {
    Color colorIcon = isSelected ? AppColors.primary : AppColors.textTertiary;

    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        //color: widget.model.id == 3 ? AppColors.primary : null,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SvgPicture.asset(
        widget.model.icon!,
        color: colorIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width < 390 ? 10 : 11.5;

    EdgeInsetsGeometry padding = EdgeInsets.only(
      top: 13,
      bottom: 5,
      left: widget.index == 0 ? 20 : 0,
      right: widget.index == widget.length - 1 ? 20 : 0,
    );

    return InkWell(
      splashColor: AppColors.white,
      highlightColor: AppColors.white,
      onTap: widget.pressed,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: sizeIcon,
              height: sizeIcon,
              child: icon,
            ),
            const SizedBox(height: 2),
            Text(
              widget.model.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.merge(
                    TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      fontSize: fontSize,
                      height: 1.5,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
            ).tr(),
          ],
        ),
      ),
    );
  }
}
