import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/spa/spa.dart';
import 'package:skin_detective/models/spa/spa_service.dart';
import 'package:skin_detective/models/spa/spa_service_id_data.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/spa_detail/spa_detail.logic.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/helper/url_helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

class SpaDetailPage extends StatefulWidget {
  final Spa spa;
  const SpaDetailPage({Key? key, required this.spa}) : super(key: key);

  @override
  _SpaDetailState createState() => _SpaDetailState();
}

class _SpaDetailState extends State<SpaDetailPage> {
  late SpaDetailLogic _logic;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _logic = SpaDetailLogic(spa: widget.spa);
    WidgetsBinding.instance?.addPostFrameCallback(_getWidgetShowMoreInfo);
  }

  void _getWidgetShowMoreInfo(_) {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    _key.currentContext?.size;

    final Size size = renderBox.size;
    // 44.0 is height of 2 lines of description
    if (size.height >= 44.0) _logic.onShowButton();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpaDetailLogic>.value(
        value: _logic,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBarWidget(
              centerTitle: false,
              customTitle: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  LocaleKeys.generalBack.tr(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLightGray,
                      ),
                ).tr(),
              ),
            ),
            body: Container(
              margin: EdgeInsets.fromLTRB(
                  24, 0, 24, BottomNavigationState.heightInsets(context)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Spa Detail Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SizedBox(
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(360)),
                                  child: Image.network(
                                    widget.spa.image!,
                                    fit: BoxFit.cover,
                                    width: 72,
                                    height: 72,
                                    errorBuilder: (_, ob, __) {
                                      return Image.asset(
                                        Assets.images.avatarNull.path,
                                        width: 72,
                                        height: 72,
                                      );
                                    },
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.spa.detail!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontFamily:
                                              Assets.googleFonts.montserratBold,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textBlueBlack,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.spa.detail!.address,
                                    overflow: TextOverflow.visible,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontFamily: Assets
                                              .googleFonts.montserratMedium,
                                          fontSize: AppFonts.font_11,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textBlueBlack,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Spa Info Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          SpaInfoButton(
                            onPress: () async {
                              await URLLauncher.openPhone(widget.spa.phone!);
                            },
                            title: LocaleKeys.spaDetailCallLable.tr(),
                            iconColor: AppColors.white,
                            icon: Assets.icons.iconContact,
                            bgColor: AppColors.primary,
                          ),
                          const Spacer(),
                          SpaInfoButton(
                            icon: Assets.icons.iconLocation,
                            title: LocaleKeys.spaDetailLocationLable.tr(),
                            onPress: () async {
                              await URLLauncher.openMap(
                                  widget.spa.location!.latitude!,
                                  widget.spa.location!.longitude!);
                            },
                          ),
                          const Spacer(),
                          SpaInfoButton(
                            onPress: () async {
                              await URLLauncher.openWebsite(
                                  widget.spa.website!);
                            },
                            icon: Assets.icons.iconWebsite,
                            title: LocaleKeys.spaDetailWebLable.tr(),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),

                    // Spa Information Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.white),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.icons.iconInfo,
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                LocaleKeys.spaDetailInformationArcMenu.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratSemiBold,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlueBlack,
                                    ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.spaDetailSpecializeTitle.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBold,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlueBlack,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.spa.detail!.specialize.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratMedium,
                                      //fontWeight: FontWeight.w500,
                                      color: AppColors.textBlueBlack,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                LocaleKeys.spaDetailYearTitle.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBold,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlueBlack,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${widget.spa.detail!.experience.toString()} ${widget.spa.detail!.unitExperience}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratMedium,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textBlueBlack,
                                    ),
                              ),
                              AnimatedSize(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Selector<SpaDetailLogic, bool>(
                                      selector: (_, __) => __.isExpand,
                                      builder: (_, isExpanded, __) {
                                        return Html(
                                          key: _key,
                                          data: widget.spa.detail!.description
                                              .toString(),
                                          style: {
                                            '*': Style(
                                              maxLines: isExpanded ? null : 2,
                                              textOverflow: TextOverflow.fade,
                                              fontFamily: Assets
                                                  .googleFonts.montserratBold,
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.zero,
                                              lineHeight:
                                                  LineHeight.number(1.4),
                                              fontSize:
                                                  FontSize(AppFonts.font_12),
                                              color: AppColors.textBlueBlack,
                                            ),
                                          },
                                        );
                                      }),
                                ),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              ),
                              Selector<SpaDetailLogic, bool>(
                                  selector: (_, __) => __.isShowButton,
                                  builder: (context, isShowButton, snapshot) {
                                    if (!isShowButton) return Container();
                                    return ButtonWidget(
                                      onPressed: () {
                                        _logic.onClickExpanded();
                                      },
                                      primary: AppColors.transparent,
                                      type: EButton.full,
                                      child: Selector<SpaDetailLogic, bool>(
                                          selector: (_, __) => __.isExpand,
                                          builder: (_, isExpanded, __) {
                                            return Text(
                                              isExpanded
                                                  ? LocaleKeys.generalCollapse
                                                      .tr()
                                                  : LocaleKeys.generalShowMore
                                                      .tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratSemiBold,
                                                    color: AppColors.textBlue,
                                                  ),
                                            );
                                          }),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ]),
                    ),

                    // Service packages
                    Selector<SpaDetailLogic, List<ServiceIdDetail>>(
                      selector: (_, __) => __.spaServices,
                      builder: (_, services, __) {
                        if (services.isEmpty) return Container();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: const Divider(
                                color: AppColors.white,
                                thickness: 1,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                LocaleKeys.serviceListTitle,
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          Assets.googleFonts.montserratBold,
                                      color: AppColors.textBlueBlack,
                                    ),
                              ).tr(),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ...services.map(
                              (service) => SpaServiceItem(
                                spaService: service,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class SpaServiceItem extends StatelessWidget {
  final ServiceIdDetail spaService;

  const SpaServiceItem({Key? key, required this.spaService}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.spaServiceDetail,
            arguments: spaService.id);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: AppColors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    spaService.thumbnail.toString(),
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64,
                    errorBuilder: (_, ob, __) {
                      return Image.asset(
                        Assets.images.avatarNull.path,
                        width: 64,
                        height: 64,
                      );
                    },
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 12, right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spaService.detail!.title.toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontFamily: Assets.googleFonts.montserratBold,
                              color: AppColors.textBlueBlack,
                            ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(spaService.detail!.description.toString(),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppFonts.font_11,
                                    color: AppColors.textBlueBlack,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      /* Html(
                        data: '${spaService.detail!.content}',
                        style: {
                          "*": Style(
                              padding: EdgeInsets.zero,
                              fontFamily: Assets.googleFonts.montserratMedium,
                              margin: EdgeInsets.zero,
                              fontSize: FontSize(AppFonts.font_12),
                              color: AppColors.textBlueBlack,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis)
                        },
                      ), */
                      const SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          spaService.serviceFee,
                          textAlign: TextAlign.right,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    fontFamily:
                                        Assets.googleFonts.montserratSemiBold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppFonts.font10,
                                    color: AppColors.primary,
                                  ),
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}

class SpaInfoButton extends StatelessWidget {
  final Function() onPress;
  final Color? bgColor;
  final Color? iconColor;
  final String icon;
  final String title;
  const SpaInfoButton({
    Key? key,
    required this.onPress,
    required this.title,
    this.bgColor,
    this.iconColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor ?? AppColors.textLightBlue,
              borderRadius: BorderRadius.circular(360),
            ),
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              color: iconColor ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: Assets.googleFonts.montserratSemiBold,
                  fontSize: AppFonts.font10,
                  color: AppColors.textBlueBlack,
                ),
          ),
        ],
      ),
    );
  }
}
