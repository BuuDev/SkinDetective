import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/doctor/doctor.logic.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

void showDoctorFilterPopup(BuildContext context) {
  var provider = Provider.of<DoctorLogic>(context, listen: false);
  // to check filter is open or not
  var isFilter = provider.isFilter;
  bool isPriceSelected = provider.isPriceSelected;
  int priceIndex = provider.priceIndex;
  bool isExpSelected = provider.isExpSelected;
  int expIndex = provider.expIndex;
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return ChangeNotifierProvider<DoctorLogic>.value(
        value: provider,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.white,
            ),
            child: Container(
              padding: const EdgeInsets.all(24).copyWith(
                  bottom: BottomNavigationState.heightInsets(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Title Popup
                  Stack(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          LocaleKeys.doctorFilter,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: AppColors.textBlack,
                                  fontFamily: Assets.googleFonts.montserratBold,
                                  fontWeight: FontWeight.w700),
                        ).tr(gender: 'title'),
                      ),
                      Row(
                        children: [
                          Al
                          Container(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                provider.onCancel(isPriceSelected, priceIndex,
                                    isExpSelected, expIndex);
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset(
                                Assets.icons.closeIcon,
                                color: AppColors.grayBackground,
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              provider.resetFilter();
                            },
                            child: Text(
                              LocaleKeys.fiter,
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBold,
                                      color: AppColors.textLightGray,
                                      fontWeight: FontWeight.w700),
                            ).tr(gender: 'cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Body
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      LocaleKeys.doctorFiter,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBold,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700),
                    ).tr(gender: 'service_charge'),
                  ),
                  ...provider.listSortPrice.map(
                    (price) => Selector<DoctorLogic, bool>(
                        selector: (_, __) => __.isPriceSelected,
                        builder: (context, isPriceSelected, __) {
                          return Selector<DoctorLogic, int>(
                              selector: (_, __) => __.priceIndex,
                              builder: (context, priceIndex, _) {
                                return InkWell(
                                  onTap: () {
                                    if (!isFilter) isFilter = true;
                                    provider.onChangePriceValue(
                                        provider.listSortPrice.indexOf(price));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          LocaleKeys.fiter,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBold,
                                                  color: isFilter &&
                                                          isPriceSelected &&
                                                          provider.listSortPrice
                                                                  .indexOf(
                                                                      price) ==
                                                              (priceIndex)
                                                      ? AppColors.textBlue
                                                      : AppColors.textBlueBlack,
                                                  fontWeight: FontWeight.w500),
                                        ).tr(gender: '$price'),
                                        isFilter &&
                                                isPriceSelected &&
                                                provider.listSortPrice
                                                        .indexOf(price) ==
                                                    (priceIndex)
                                            ? SvgPicture.asset(
                                                Assets.icons.accept,
                                                height: 14,
                                                width: 20,
                                                color: AppColors.primary,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      LocaleKeys.doctorFiter,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBold,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w700),
                    ).tr(gender: 'year'),
                  ),
                  SizedBox(
                    height: 120,
                    child: Selector<DoctorLogic, bool>(
                        selector: (_, __) => __.isExpSelected,
                        builder: (context, isExpSelected, __) {
                          return Selector<DoctorLogic, int>(
                              selector: (_, __) => __.expIndex,
                              builder: (context, expIndex, snapshot) {
                                return GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.listSortExperience.length,
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    childAspectRatio: 100 / 44,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        if (!isFilter) isFilter = true;
                                        provider.onChangeExpValue(index);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: isFilter &&
                                                    isExpSelected &&
                                                    index == expIndex
                                                ? AppColors.primary
                                                : AppColors.lightGray),
                                        child: Text(
                                          LocaleKeys.fiter,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBold,
                                                  color: isFilter &&
                                                          isExpSelected &&
                                                          index == expIndex
                                                      ? AppColors.textWhiteGray
                                                      : AppColors.textBlack,
                                                  fontWeight: FontWeight.w700),
                                        ).tr(args: [
                                          provider.listSortExperience[index]
                                              .toString()
                                        ], gender: 'year'),
                                      ),
                                    );
                                  },
                                );
                              });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: ButtonWidget(
                      onPressed: () {
                        provider.onChangeFilter();
                        Navigator.of(context).pop();
                      },
                      type: EButton.full,
                      child: Text(
                        LocaleKeys.generalApply,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontFamily: Assets.googleFonts.montserratSemiBold,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white),
                      ).tr(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
