import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/user/user.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/analyze.dart';
import 'package:skin_detective/screens/app/home/screens/categories/categories.dart';
import 'package:skin_detective/screens/app/home/screens/doctor/doctor.dart';
import 'package:skin_detective/screens/app/home/screens/doctor/doctor.logic.dart';
import 'package:skin_detective/screens/app/home/screens/doctor/show_pop_up_filter.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis_logic.dart';
import 'package:skin_detective/screens/app/home/screens/settings/setting.dart';
import 'package:skin_detective/screens/app/home/screens/spa/show_pop_up_filter.dart';
import 'package:skin_detective/screens/app/home/screens/spa/spa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/screens/app/home/screens/spa/spa.logic.dart';
import 'package:skin_detective/services/apis/home/home.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/services/notification/notification.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';
import 'package:skin_detective/widgets/logic_widget/logic_widget.dart';
import 'package:tuple/tuple.dart';

import '../../../providers/app/app.dart';

part 'home.logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with LogicState<HomePage, HomePageLogic> {
  final List<Widget> pageList = <Widget>[
    DoctorPage(key: UniqueKey()),
    SpaPage(key: UniqueKey()),
    AnalyzePage(key: UniqueKey()),
    CategoriesPage(key: UniqueKey()),
    SettingPage(key: UniqueKey()),
  ];

  void checkLogin() {
    if (GetIt.instance<AppVM>().isLogged) {
      Navigator.pushNamed(context, AppRoutes.userProfile);
    } else {
      NavigationService.gotoAuth();
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: AppColors.backgroundColor,
        padding: EdgeInsets.only(
          bottom: BottomNavigationState.heightInsets(context),
        ),
        child: Scaffold(
          appBar: AppBarWidget(
            leadingWidth: 60,
            leading: Selector<HomePageLogic, int>(
                selector: (_, __) => __.bottomIndex,
                builder: (_, bottomIndex, ___) {
                  return Consumer<AcneAnalyzeVM>(builder: (_, state, __) {
                    return ((state.status == HomeStepStatus.confirm ||
                                state.status == HomeStepStatus.analyzing ||
                                state.status == HomeStepStatus.result) &&
                            bottomIndex == 2)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Center(
                              child: InkWell(
                                splashColor: AppColors.white,
                                highlightColor: AppColors.white,
                                onTap: logic.backToHome,
                                child: Container(
                                  padding: const EdgeInsets.all(9),
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: AppColors.textLightGrayBG,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: SvgPicture.asset(
                                    Assets.icons.arrowLeftBack,
                                    color: AppColors.textLightGray,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  });
                }),
            // bottom: PreferredSize(
            //   preferredSize: const Size.fromHeight(6.0),
            //   child:
            //       Selector<AcneAnalyzeVM, Tuple3<HomeStepStatus, bool, bool>>(
            //     selector: (_, state) =>
            //         Tuple3(state.status, state.isShowLiner, state.isAnalyzed),
            //     builder: (_, state, __) {
            //       if (state.item1 != HomeStepStatus.analyzing &&
            //           state.item2 == false) {
            //         return const SizedBox();
            //       }

            //       return LinearProgressIndicator(
            //         backgroundColor: AppColors.textLightPinkBG,
            //         valueColor: AlwaysStoppedAnimation<Color>(
            //           state.item3 ? AppColors.primary : AppColors.textOrangeBG,
            //         ),
            //         value: state.item3 ? 1 : 0.25,
            //       );
            //     },
            //   ),
            // ),
            elevation: 0.5,
            backgroundColor: AppColors.white,
            customTitle: Selector<HomePageLogic,
                Tuple4<String, bool, int, HomeStepStatus>>(
              selector: (_, state) => Tuple4(
                state.title,
                state.acneAnalyzeVM.isAnalyzed,
                state.bottomIndex,
                state.acneAnalyzeVM.status,
              ),
              builder: (_, data, __) {
                if (data.item2 &&
                    data.item3 == 2 &&
                    data.item4 == HomeStepStatus.analyzing) {
                  return Text(
                    data.item1,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBold,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                  );
                }
                return Text(
                  data.item1,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontFamily: Assets.googleFonts.montserratBold,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                ).tr();
              },
            ),
            action: [
              Selector<HomePageLogic, int>(
                selector: (_, __) => __.bottomIndex,
                builder: (_, bottomIndex, ___) => actionWidget(bottomIndex, _),
              ),
            ],
          ),
          body: PageView(
            controller: logic.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: logic.onPageChange,
            children: pageList,
          ),
          extendBody: true,
          bottomNavigationBar: Selector<HomePageLogic, int>(
            selector: (context, state) => state.bottomIndex,
            builder: (context, indexBottom, __) {
              return BottomNavigation(
                pressed: logic.updateBottomTab,
                index: indexBottom,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget actionWidget(int bottomIndex, BuildContext context) {
    if (bottomIndex == 0) {
      return Container(
        padding: const EdgeInsets.only(right: 24, top: 9, bottom: 9),
        child: InkWell(
          splashColor: AppColors.white,
          highlightColor: AppColors.white,
          onTap: () {
            if (bottomIndex == 0) showDoctorFilterPopup(context);
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: AppColors.textLightGrayBG,
            ),
            child: Selector<DoctorLogic, bool>(
                selector: (_, __) => __.isFilter,
                builder: (context, isFilter, snapshot) {
                  return SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.icons.filter,
                        color: isFilter
                            ? AppColors.primary
                            : AppColors.textLightGray,
                        placeholderBuilder: (_) {
                          return Image.asset(
                            Assets.images.avatarNull.path,
                            width: 36,
                            height: 36,
                          );
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      );
    }
    if (bottomIndex == 1) {
      return Container(
        padding: const EdgeInsets.only(right: 24, top: 9, bottom: 9),
        child: InkWell(
          splashColor: AppColors.white,
          highlightColor: AppColors.white,
          onTap: () {
            if (bottomIndex == 1) showSpaFilterPopup(context);
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: AppColors.textLightGrayBG,
            ),
            child: Selector<SpaLogic, bool>(
                selector: (_, __) => __.isFilter,
                builder: (context, isFilter, snapshot) {
                  return SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.icons.filter,
                        color: isFilter
                            ? AppColors.primary
                            : AppColors.textLightGray,
                        placeholderBuilder: (_) {
                          return Image.asset(
                            Assets.images.avatarNull.path,
                            width: 36,
                            height: 36,
                          );
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      );
    }

    return Selector<UserViewModel, User>(
        selector: (_, state) => state.data,
        builder: (_, userInfo, __) {
          return InkWell(
            splashColor: AppColors.white,
            highlightColor: AppColors.white,
            onTap: checkLogin,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(36)),
                  child: ImageCustom(
                    urlImage: userInfo.avatar,
                    fit: BoxFit.cover,
                    width: 36,
                    height: 36,
                    placeHolderType: PlaceHolderType.imageAsset,
                  )),
            ),
          );
        });
  }

  @override
  HomePageLogic initViewModel(BuildContext context) {
    return HomePageLogic(context: context);
  }
}
