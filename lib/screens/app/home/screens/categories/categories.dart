import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/categories/article/article.dart';
import 'package:skin_detective/screens/app/home/screens/categories/blog/blog.dart';
import 'package:skin_detective/screens/app/home/screens/categories/categories.logic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/cosmetic/cosmetic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/personal.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../models/user/user.dart';
import '../../../../../providers/user/user.dart';
import '../../../../../theme/color.dart';
part 'custom_paint.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    Key? key,
  }) : super(key: key);
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  final List<String> titleCategories = [
    LocaleKeys.gategoriesNavCosmetics,
    LocaleKeys.gategoriesNavBlog,
    LocaleKeys.gategoriesNavPost,
    LocaleKeys.gategoriesNavMyPost
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
          bottom: BottomNavigationState.maxHeight),
      color: AppColors.textLightGrayBG,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        child: Column(
          children: [
            Selector<CategoriesLogic, int>(
                selector: (_, __) => __.tabIndex,
                builder: (_, index, __) {
                  _tabController.animateTo(index);
                  return SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: Helper.mapWidgets<_TabDirection>(
                          data: [
                            _TabDirection.left,
                            _TabDirection.center,
                            _TabDirection.center,
                            _TabDirection.right
                          ],
                          render: (item, indexItem) {
                            if (index == 3 && indexItem == index) {
                              return Expanded(
                                child: _tabBar(
                                  label: titleCategories[index],
                                  isActive: true,
                                  direction: item,
                                  cosmetic: true,
                                  icon: getIconTab(indexItem, true),
                                ),
                              );
                            }
                            if (index == 0 && indexItem == index) {
                              return Expanded(
                                child: _tabBar(
                                  label: titleCategories[index],
                                  isActive: true,
                                  direction: item,
                                  cosmetic: true,
                                  post: true,
                                  icon: getIconTab(indexItem, true),
                                ),
                              );
                            }
                            if (indexItem == index && index != 0) {
                              return Expanded(
                                child: _tabBar(
                                  label: titleCategories[index],
                                  isActive: true,
                                  direction: item,
                                  icon: getIconTab(indexItem, true),
                                ),
                              );
                            }
                            return _tabBar(
                              label: '',
                              isActive: false,
                              direction: item,
                              onPress: () {
                                context
                                    .read<CategoriesLogic>()
                                    .onChangeTab(indexItem);
                              },
                              icon: Center(child: getIconTab(indexItem, false)),
                            );
                          }),
                    ),
                  );
                }),
            Expanded(
              child: Container(
                color: AppColors.backgroundColor,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    Cosmetic(),
                    Blog(),
                    Article(),
                    Personal(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getIconTab(int index, bool isActive) {
    Color color = isActive ? AppColors.textBlack : AppColors.textLightGray;
    double heightIcon = 20;

    switch (index) {
      case 0:
        return SvgPicture.asset(
          Assets.icons.iconCosmetic,
          color: color,
          height: heightIcon,
        );
      case 1:
        return SvgPicture.asset(
          Assets.icons.article,
          color: color,
          height: heightIcon,
        );
      case 2:
        return SvgPicture.asset(
          Assets.icons.blog,
          color: color,
          height: heightIcon,
        );
      default:
        return Selector<UserViewModel, User>(
          selector: (_, state) => state.data,
          builder: (_, userInfo, __) {
            return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: ImageCustom(
                  urlImage: userInfo.avatar,
                  width: GetIt.instance<UserViewModel>().data.avatar == null
                      ? 36
                      : 24,
                  height: GetIt.instance<UserViewModel>().data.avatar == null
                      ? 36
                      : 24,
                  fit: BoxFit.cover,
                  placeHolderType: PlaceHolderType.imageAsset,
                ));
          },
        );
    }
  }

  Widget _tabBar({
    required String label,
    required bool isActive,
    bool cosmetic = false,
    bool post = false,
    required _TabDirection direction,
    void Function()? onPress,
    required Widget icon,
  }) {
    Widget _widget;

    if (!isActive) {
      _widget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: icon,
      );
    } else {
      _widget = CustomPaint(
        painter: TabArtPainter(direction: direction),
        child: cosmetic
            ? Container(
                padding: EdgeInsets.symmetric(
                    vertical: post
                        ? 16
                        : GetIt.instance<UserViewModel>().data.avatar == null
                            ? 0
                            : 13,
                    horizontal: 22),
                alignment: post ? Alignment.centerLeft : Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    const SizedBox(width: 7),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontFamily: Assets.googleFonts.montserratBlack,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                    ).tr(),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    const SizedBox(width: 7),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontFamily: Assets.googleFonts.montserratBlack,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                    ).tr(),
                  ],
                ),
              ),
      );
    }

    return InkWell(
      onTap: onPress,
      child: _widget,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
