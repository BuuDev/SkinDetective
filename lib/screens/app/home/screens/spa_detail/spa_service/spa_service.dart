import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/spa_detail/spa_service/spa_service.logic.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';

import '../../../../../../constants/type_globals.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../theme/color.dart';
import '../../../../../../utils/helper/helper.dart';
import '../../../../../../widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../../../widgets/dots_widget/dots_widget.dart';

class ServiceSpa extends StatefulWidget {
  const ServiceSpa({Key? key}) : super(key: key);

  @override
  State<ServiceSpa> createState() => _ServiceSpaState();
}

class _ServiceSpaState extends State<ServiceSpa> {
  late ServiceLogic serviceLogic;

  final List<String> imageList = [
    "http://sd-api.pixelcent.com/analysis-images/121/121_31032022051453.png",
    "http://sd-api.pixelcent.com/analysis-images/121/121_31032022051453.png",
    "http://sd-api.pixelcent.com/analysis-images/121/121_31032022051453.png",
  ];
  late CarouselController controller;
  late PageController _pageController;
  late ValueNotifier<int> indexPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceLogic = ServiceLogic(context: context);
    indexPage = ValueNotifier(1);
    controller = CarouselController();
    _pageController = PageController(initialPage: indexPage.value);
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    serviceLogic.getServiceDetail(id);
    return ChangeNotifierProvider.value(
      value: serviceLogic,
      child: Consumer<ServiceLogic>(builder: (_, value, __) {
        return Scaffold(
          appBar: AppBarWidget(
            centerTitle: false,
            customTitle: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Text(LocaleKeys.generalBack.tr(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: AppColors.textLightGray,
                        )),
              ),
            ),
            backgroundColor: AppColors.white,
          ),
          backgroundColor: AppColors.white,
          body: value.serviceData == null
              ? const Center(child: FooterLoading(isLoading: true))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Column(
                      children: [
                        value.serviceData != null &&
                                value.serviceData!.images!.isNotEmpty
                            ? CarouselSlider(
                                options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    initialPage: 1,
                                    enableInfiniteScroll: false,
                                    height: 149,
                                    onPageChanged: (page, _) {
                                      indexPage.value = page;
                                    }),
                                carouselController: controller,
                                items: List.generate(
                                    value.serviceData!.images!.length,
                                    (index) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Image.network(
                                                value.serviceData!
                                                    .images![index].url,
                                                fit: BoxFit.cover,
                                              )
                                            ],
                                          ),
                                        )),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 30,
                        ),
                        value.serviceData != null &&
                                value.serviceData!.images!.isNotEmpty
                            ? ValueListenableBuilder<int>(
                                valueListenable: indexPage,
                                builder: (_, index, __) {
                                  return DotsWidget(
                                    colorActive: AppColors.textBlack,
                                    colorInactive: AppColors.textLightBlue,
                                    direction: EDot.horizontal,
                                    controller: _pageController,
                                    isUseWeightHorizontal: true,
                                    itemCount:
                                        value.serviceData!.images!.length,
                                    onPageSelected: (int page) {},
                                    indexSelected: index,
                                  );
                                })
                            : const SizedBox.shrink(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.white),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            6, 15, 6, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              LocaleKeys.service
                                                  .tr()
                                                  .toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    color:
                                                        AppColors.textLightGray,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratBold,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            value.serviceData != null
                                                ? Text(
                                                    value.serviceData!.detail
                                                        .title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                          color: AppColors
                                                              .textBlack,
                                                          fontFamily: Assets
                                                              .googleFonts
                                                              .montserratBold,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  )
                                                : const Text("Loading.."),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            value.serviceData != null
                                                ? Text(
                                                    Helper.toMoneyFormat(value
                                                            .serviceData!
                                                            .detail
                                                            .price) +
                                                        LocaleKeys
                                                            .generalCurrencyUnit
                                                            .tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                          color: AppColors
                                                              .textBlue,
                                                          fontFamily: Assets
                                                              .googleFonts
                                                              .montserratBold,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ))
                                                : const Text("Loading.."),
                                            const SizedBox(
                                              width: 32,
                                              child: Divider(
                                                height: 40,
                                                color: AppColors.textLightGray,
                                              ),
                                            ),
                                            Text(
                                              LocaleKeys.consistsOf.tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    color: AppColors.textBlack,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratBold,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              value.serviceData != null
                                  ? Html(
                                      data: value.serviceData!.detail.content)
                                  : const Text("Loading..."),
                              SizedBox(
                                height:
                                    BottomNavigationState.heightInsets(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
