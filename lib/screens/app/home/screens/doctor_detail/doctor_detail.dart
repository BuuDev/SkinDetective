import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/doctor/doctor.dart';
import 'package:skin_detective/models/spa/spa_service.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/helper/url_helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'doctor_detail.logic.dart';

class DoctorDetailPage extends StatefulWidget {
  final Doctor doctor;
  const DoctorDetailPage({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorDetailState createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetailPage> {
  late DoctorDetailLogic _logic;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _logic = DoctorDetailLogic(doctor: widget.doctor);
    WidgetsBinding.instance?.addPostFrameCallback(_getWidgetShowMoreInfo);
  }

  void _getWidgetShowMoreInfo(_) {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    _key.currentContext?.size;

    final Size size = renderBox.size;
    // 66.0 is height of 2 lines of description
    if (size.height >= 66.0) _logic.onShowButton();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DoctorDetailLogic>.value(
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
                        color: AppColors.textLightGray,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Spa Detail Card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(360)),
                                        child: Image.network(
                                          widget.doctor.image!,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.doctor.detail!.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBold,
                                                  color:
                                                      AppColors.textBlueBlack),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.doctor.detail!.workPlace
                                              .toString(),
                                          overflow: TextOverflow.visible,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontSize: AppFonts.font_11,
                                                  fontFamily: Assets.googleFonts
                                                      .montserratMedium,
                                                  color:
                                                      AppColors.textBlueBlack,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Text(
                                            LocaleKeys.spaDetailYearTitle.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratBold,
                                                    color: AppColors
                                                        .textBlueBlack),
                                          ),
                                        ),
                                        Text(
                                          '${widget.doctor.detail!.experience} ${widget.doctor.detail!.unitExperience}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: Assets.googleFonts
                                                      .montserratMedium,
                                                  color:
                                                      AppColors.textBlueBlack),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys
                                              .doctorDetailConsultantFeeLable
                                              .tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBold,
                                                  color:
                                                      AppColors.textBlueBlack),
                                        ),
                                        Text(
                                          widget.doctor.detail!.serviceFee,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontFamily: Assets.googleFonts
                                                    .montserratMedium,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textBlue,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Doctor Info Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            SpaInfoButton(
                              onPress: () async {
                                await URLLauncher.openPhone(
                                    widget.doctor.phone!);
                              },
                              title: LocaleKeys.doctorDetailCallLable.tr(),
                              iconColor: AppColors.white,
                              icon: Assets.icons.iconContact,
                              bgColor: AppColors.primary,
                            ),
                            const Spacer(),
                            SpaInfoButton(
                              icon: Assets.icons.iconLocation,
                              title: LocaleKeys.doctorDetailLocationOnMapLable
                                  .tr(),
                              onPress: () async {
                                await URLLauncher.openMap(
                                    widget.doctor.location!.latitude!,
                                    widget.doctor.location!.longitude!);
                              },
                            ),
                            const Spacer(),
                            SpaInfoButton(
                              onPress: () async {
                                await URLLauncher.openWebsite(
                                    widget.doctor.website!);
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
                                  LocaleKeys.doctorDetailDoctorInfo.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontFamily: Assets
                                            .googleFonts.montserratSemiBold,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textBlueBlack,
                                      ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.doctorDetailLocationLable
                                      .tr()
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textBlueBlack,
                                        fontFamily: Assets
                                            .googleFonts.montserratSemiBold,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.doctor.detail!.address.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontFamily:
                                            Assets.googleFonts.montserratBold,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textBlueBlack,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  LocaleKeys.doctorDetailSpecializeTitle.tr(),
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
                                AnimatedSize(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Selector<DoctorDetailLogic, bool>(
                                        selector: (_, __) => __.isExpand,
                                        builder: (_, isExpanded, __) {
                                          return Html(
                                            key: _key,
                                            data: widget
                                                .doctor.detail!.specialize
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
                                Selector<DoctorDetailLogic, bool>(
                                    selector: (_, __) => __.isShowButton,
                                    builder: (context, isShowButton, snapshot) {
                                      if (!isShowButton) return Container();
                                      return ButtonWidget(
                                        onPressed: () {
                                          _logic.onClickExpanded();
                                        },
                                        primary: AppColors.transparent,
                                        type: EButton.full,
                                        child: Selector<DoctorDetailLogic,
                                                bool>(
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
                                                      fontFamily: Assets
                                                          .googleFonts
                                                          .montserratSemiBold,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class SpaServiceItem extends StatelessWidget {
  final SpaServiceResponse spaService;

  const SpaServiceItem({Key? key, required this.spaService}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: AppColors.white),
          child: Row(
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
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spaService.name.toString(),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlueBlack,
                          ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      '${spaService.detail}',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: AppFonts.font10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlueBlack),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '${spaService.price} VND',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: AppFonts.font10,
                            fontFamily: Assets.googleFonts.montserratBlack,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
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
                fontFamily: Assets.googleFonts.montserratSemiBold,
                color: AppColors.textBlueBlack,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
