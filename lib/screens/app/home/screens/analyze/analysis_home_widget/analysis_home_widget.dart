import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';

import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis_logic.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';

import '../../../../../../models/history_skin_analysis/history_skin_analysis.dart';
import '../../../../../../models/popup_servey_check/popup_servey_check.dart';

class AnalysisHomeWidget extends StatefulWidget {
  List<HistorySkinAnalysisResponse> data;
  AnalysisHomeWidget({Key? key, required this.data}) : super(key: key);
  @override
  State<AnalysisHomeWidget> createState() => _AnalysisHomeWidgetState();
}

class _AnalysisHomeWidgetState extends State<AnalysisHomeWidget> {
  late HistorySkinAnalysisLogic skinAnalysisLogic;
  late AcneAnalyzeVM acneAnalyzeVM;

  @override
  void initState() {
    super.initState();
    acneAnalyzeVM = context.read<AcneAnalyzeVM>();
    skinAnalysisLogic = context.read<HistorySkinAnalysisLogic>();
    skinAnalysisLogic.getHistorySkinAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            height: 104,
            child: Row(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: AppColors.textBlue,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ChangeNotifierProvider.value(
                      value: acneAnalyzeVM,
                      child: Consumer<AcneAnalyzeVM>(
                          builder: (context, value, child) {
                        return InkWell(
                          onTap: () {
                            if (value.popupServeyCheck.showPopup &&
                                value.popupServeyCheck.type ==
                                    PopupServeyType.popupB) {
                              value.showPopUp();
                            } else {
                              if (value.isCheckAnalyzed) {
                                value.gotoAnalyze(context);
                              } else {
                                NotifyHelper.showSnackBar(
                                    LocaleKeys.analysisMessage.tr());
                              }
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                child: SvgPicture.asset(
                                  Assets.icons.personScan,
                                  width: 45,
                                  height: 45,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                LocaleKeys.homeAnalysis,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          Assets.googleFonts.montserratBold,
                                    ),
                              ).tr(),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                    width: Helper.percentWidth(pixel: 24, context: context)),
                Expanded(
                  child: Card(
                    shadowColor: AppColors.textBlue.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white,
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, AppRoutes.historySkinAnalysis)
                            .then((value) async {
                          await skinAnalysisLogic.getHistorySkinAnalysis();
                        });
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15)
                                      .copyWith(top: 5),
                              child: Text(
                                DateFormat(FormatDate.formatHistorySkin).format(
                                    DateTime.parse(widget.data[0].createdAt)),
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .merge(
                                      const TextStyle(
                                          color: AppColors.textLightGray,
                                          fontWeight: FontWeight.bold),
                                    ),
                              ),
                            ),
                            Consumer<AcneAnalyzeVM>(
                              builder: (context, popup, child) {
                                return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: ButtonWidget(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 0),
                                          child: Text(
                                            widget.data[0].title
                                                .split("|")[1]
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .merge(
                                                  TextStyle(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratSemiBold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                            maxLines: 1,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .historySkinAnalysis)
                                                .then((value) {
                                              skinAnalysisLogic
                                                  .getHistorySkinAnalysis();
                                            });
                                          },
                                        ),
                                      ),
                                    ]);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text(
                                LocaleKeys.homeHistory,
                                softWrap: true,
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .merge(
                                      TextStyle(
                                        color: AppColors.textBlueBlack,
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            Assets.googleFonts.montserratBold,
                                      ),
                                    ),
                                maxLines: 1,
                              ).tr(),
                            ),
                          ]),
                    ),
                  ),
                )
              ],
            ),
          )
        : Consumer<AcneAnalyzeVM>(builder: (context, value, child) {
            return InkWell(
              onTap: () {
                if (value.popupServeyCheck.showPopup &&
                    value.popupServeyCheck.type == PopupServeyType.popupB) {
                  value.showPopUp();
                } else {
                  if (value.isCheckAnalyzed) {
                    value.gotoAnalyze(context);
                  } else {
                    NotifyHelper.showSnackBar(LocaleKeys.analysisMessage.tr());
                  }
                }
              },
              child: Container(
                //width: Helper.percentWidth(pixel: 330, context: context),
                height: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary.withOpacity(0.7),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        Assets.icons.personScanNull,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            child: SvgPicture.asset(
                              Assets.icons.personScan,
                              width: 45,
                              height: 45,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            LocaleKeys.homeAnalysis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: Assets.googleFonts.montserratBold,
                                ),
                          ).tr(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
  }
}
