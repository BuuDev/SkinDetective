import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skin_detective/models/analytic/analyze_detail.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/home.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/double_button_custom_widget/double_button_custom_widget.dart';
import 'package:skin_detective/widgets/flip_widget/flip_widget.dart';
import 'package:skin_detective/widgets/polyline_acne_image/polyline_acne_image.dart';

class BannerWidget extends StatelessWidget {
  final AnalyzeDetail acne;
  final String? type;
  final void Function(BuildContext context)? onDetail;
  final ScrollController? scrollController;

  const BannerWidget({
    Key? key,
    required this.acne,
    this.type,
    this.scrollController,
    this.onDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 24)
              .copyWith(top: 24, bottom: 24),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              if (onDetail != null) {
                                onDetail?.call(context);
                              }
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              child: FlipWidget(
                                child: PolylineAcneImage(
                                  faceDetail: acne,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Text(
                                      acne.skinAnalysisDetail.title
                                          .split("|")[1],
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .merge(
                                            const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.textBlueBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    acne.skinAnalysisDetail.description,
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .merge(
                                          TextStyle(
                                            fontSize: AppFonts.font_14,
                                            color: AppColors.textBlueBlack,
                                            fontWeight: FontWeight.normal,
                                            height: 1.5,
                                          ),
                                        ),
                                    /*      maxLines: 7,
                                    overflow: TextOverflow.ellipsis, */
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13, bottom: 13),
                    child: InkWell(
                      onTap: () {
                        if (onDetail != null) {
                          onDetail?.call(context);
                        }
                      },
                      child: Text(
                        LocaleKeys.detail,
                        style: Theme.of(context).textTheme.caption!.merge(
                              TextStyle(
                                fontSize: AppFonts.font_14,
                                color: AppColors.textBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ).tr(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Selector<HomePageLogic, Function>(
            selector: (_, _logic) => _logic.updateBottomTab,
            builder: (context, updateBottomTab, _) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: DoubleButtonCustomWidget(
                  titleLeft: LocaleKeys.showSpaButton.tr(),
                  titleRight: LocaleKeys.showDoctorButton.tr(),
                  onPressedRight: () {
                    updateBottomTab(
                        0, BottomNavigation.getDataItems(context)[0]);
                  },
                  onPressedLeft: () {
                    updateBottomTab(
                        1, BottomNavigation.getDataItems(context)[1]);
                  },
                ),
              );
            }),
      ],
    );
  }
}
