import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/system_param/system_param.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/home.dart';
import 'package:skin_detective/screens/app/home/screens/analyze/widgets/home/widget_survey.dart';
import 'package:skin_detective/screens/app/home/screens/categories/categories.logic.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis_logic.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/banner_widget/banner_widget.dart';
import 'package:skin_detective/widgets/category_widget/category_widget.dart';
import 'package:skin_detective/widgets/list_view_widget/list_view_widget.dart';
import 'package:skin_detective/widgets/post_new_widget/post_new_widget.dart';
import '../../../../../../../models/history_skin_analysis/history_skin_analysis.dart';
import '../../../../../../../models/popup_servey_check/popup_servey_check.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../theme/color.dart';
import '../../analysis_home_widget/analysis_home_widget.dart';

class HomeAnalyzePage extends StatefulWidget {
  const HomeAnalyzePage({Key? key}) : super(key: key);

  @override
  _AnalyzePageState createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<HomeAnalyzePage> {
  late HomePageLogic logic;
  late AcneAnalyzeVM acneAnalyzeVM;

  @override
  void initState() {
    super.initState();
    logic = context.read<HomePageLogic>();
    acneAnalyzeVM = context.read<AcneAnalyzeVM>();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      logic.loadDataHome();
      acneAnalyzeVM.getPopupCheck();
    });
  }

  double get cardHeight => 205;
  double get cardHeightCosmetic => 199;
  double get cardWidth => 175;
  double get cardWidthCosmetic => 124;

  EdgeInsetsGeometry get paddingHorizontal =>
      const EdgeInsets.symmetric(horizontal: 24);

  void gotoPost([int categoryTab = 1]) {
    context.read<CategoriesLogic>().onChangeTab(categoryTab);
    logic.updateBottomTab(
      3,
      BottomNavigation.getDataItems(context)[3],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AcneAnalyzeVM>(
      builder: (_, analyzeVM, __) => RefreshIndicator(
        onRefresh: logic.loadDataHome,
        backgroundColor: AppColors.white,
        color: AppColors.textBlack,
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: BottomNavigationState.maxHeight + 20),
          child: Column(
            children: [
              if (acneAnalyzeVM.status == HomeStepStatus.result) ...[
                BannerWidget(
                  acne: analyzeVM.analyzeResult.frontal,
                  onDetail: analyzeVM.gotoDetail,
                ),
                CategoryWidget(
                  padding: paddingHorizontal,
                  onTap: () => gotoPost(0),
                  title: LocaleKeys.generalNewCosmetics,
                ),
                Selector<HomePageLogic, List<ConsMeticData>>(
                    builder: ((context, value, child) {
                      return SizedBox(
                        height: cardHeightCosmetic,
                        child: ListViewWidget(
                            list: value,
                            itemBuilder: (context, index) {
                              return PostNewWidget(
                                data: value[index],
                                index: index,
                                count: value.length,
                                cardWidth: cardWidthCosmetic,
                                subTitle: value[index].detail.brand,
                                onTap: () {
                                  if (GetIt.instance<AppVM>().isLogged) {
                                    Navigator.pushNamed(
                                        context, AppRoutes.cosmeticDetail,
                                        arguments: value[index].id);
                                  } else {
                                    NotifyHelper.showSnackBar(LocaleKeys
                                        .generalMessageRequiredLogin
                                        .tr());
                                  }
                                },
                              );
                            }),
                      );
                    }),
                    selector: (_, state) => state.homeCosmetic.data),
                CategoryWidget(
                  padding: paddingHorizontal,
                  onTap: gotoPost,
                  title: LocaleKeys.homeNewBlogTitle,
                ),
                Selector<HomePageLogic, List<ConsMeticData>>(
                    builder: ((context, value, child) {
                      return SizedBox(
                        height: cardHeight,
                        child: ListViewWidget(
                            list: value,
                            itemBuilder: (context, index) {
                              return PostNewWidget(
                                data: value[index],
                                index: index,
                                count: value.length,
                                cardWidth: cardWidth,
                                onTap: () {
                                  if (GetIt.instance<AppVM>().isLogged) {
                                    Navigator.pushNamed(
                                        context, AppRoutes.blogDetail,
                                        arguments: value[index].id);
                                  } else {
                                    NotifyHelper.showSnackBar(LocaleKeys
                                        .generalMessageRequiredLogin
                                        .tr());
                                  }
                                },
                              );
                            }),
                      );
                    }),
                    selector: (_, state) => state.homeBlog.data),
              ],
              if (acneAnalyzeVM.status != HomeStepStatus.result) ...[
                CategoryWidget(
                  padding: paddingHorizontal,
                  title: LocaleKeys.homeHeader,
                  isMore: false,
                  customTitle: GetIt.instance<UserViewModel>().data.name,
                ),
                Selector<AppVM, bool>(
                    selector: (_, state) => state.isLogged,
                    builder: (_, value, __) {
                      return value
                          ? Selector<AcneAnalyzeVM, PopupServeyCheck>(
                              selector: (_, state) => state.popupServeyCheck,
                              builder: ((_, value, __) {
                                return value.showPopup
                                    ? Padding(
                                        padding: paddingHorizontal,
                                        child: surveyWidget(context),
                                      )
                                    : const SizedBox();
                              }),
                            )
                          : const SizedBox();
                    }),
                Selector<HistorySkinAnalysisLogic,
                    List<HistorySkinAnalysisResponse>>(
                  selector: (_, state) => state.data,
                  builder: ((_, data, __) {
                    return Padding(
                      padding: paddingHorizontal,
                      child: AnalysisHomeWidget(
                        data: data,
                      ),
                    );
                  }),
                ),
                CategoryWidget(
                  padding: paddingHorizontal,
                  onTap: gotoPost,
                  title: LocaleKeys.homeNewBlogTitle,
                ),
                Selector<HomePageLogic, List<ConsMeticData>>(
                  selector: (_, state) => state.homeBlog.data,
                  builder: ((context, value, child) {
                    return SizedBox(
                      height: cardHeight,
                      child: ListViewWidget(
                          list: value,
                          itemBuilder: (context, index) {
                            return PostNewWidget(
                              data: value[index],
                              index: index,
                              count: value.length,
                              cardWidth: cardWidth,
                              onTap: () {
                                if (GetIt.instance<AppVM>().isLogged) {
                                  Navigator.pushNamed(
                                      context, AppRoutes.blogDetail,
                                      arguments: value[index].id);
                                } else {
                                  NotifyHelper.showSnackBar(LocaleKeys
                                      .generalMessageRequiredLogin
                                      .tr());
                                }
                              },
                            );
                          }),
                    );
                  }),
                ),
                CategoryWidget(
                  padding: paddingHorizontal,
                  onTap: () => gotoPost(0),
                  title: LocaleKeys.generalNewCosmetics,
                ),
                Selector<HomePageLogic, List<ConsMeticData>>(
                  builder: ((context, value, child) {
                    return SizedBox(
                      height: cardHeightCosmetic,
                      child: ListViewWidget(
                          list: value,
                          itemBuilder: (context, index) {
                            return PostNewWidget(
                              data: value[index],
                              index: index,
                              count: value.length,
                              cardWidth: cardWidthCosmetic,
                              subTitle: value[index].detail.brand,
                              onTap: () {
                                if (GetIt.instance<AppVM>().isLogged) {
                                  Navigator.pushNamed(
                                      context, AppRoutes.cosmeticDetail,
                                      arguments: value[index].id);
                                } else {
                                  NotifyHelper.showSnackBar(LocaleKeys
                                      .generalMessageRequiredLogin
                                      .tr());
                                }
                              },
                            );
                          }),
                    );
                  }),
                  selector: (_, state) => state.homeCosmetic.data,
                ),
              ],
              if (GetIt.instance<AppVM>().dataParams.activePost ==
                  ActivePost.on)
                Selector<HomePageLogic, List<ConsMeticData>>(
                  selector: (_, state) => state.homePost.data,
                  builder: ((context, value, child) {
                    if (value.isEmpty) return const SizedBox();
                    return Column(children: [
                      CategoryWidget(
                        padding: paddingHorizontal,
                        onTap: () => gotoPost(2),
                        title: LocaleKeys.homeNewPostTitle,
                      ),
                      SizedBox(
                        height: cardHeight,
                        child: ListViewWidget(
                            list: value,
                            itemBuilder: (context, index) {
                              return PostNewWidget(
                                data: value[index],
                                index: index,
                                count: value.length,
                                cardWidth: cardWidth,
                                onTap: () {
                                  if (GetIt.instance<AppVM>().isLogged) {
                                    Navigator.pushNamed(
                                        context, AppRoutes.articleDetail,
                                        arguments: value[index].id);
                                  } else {
                                    NotifyHelper.showSnackBar(LocaleKeys
                                        .generalMessageRequiredLogin
                                        .tr());
                                  }
                                },
                              );
                            }),
                      )
                    ]);
                  }),
                )
            ],
          ),
        ),
      ),
    );
  }
}
