import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/acne_box/acne_box.dart';
import 'package:skin_detective/models/analytic/analytic.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
import 'package:skin_detective/screens/app/face_analysis/face_acne_detail/face_carousel_ance/face_carousel_ance.dart';
import 'package:skin_detective/services/apis/ance/ance.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/acne_row_widget/acne_row_widget.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';

import '../../../../models/analytic/analyze_result.dart';

part 'face_acne_detail.logic.dart';

class FaceAcneDetail extends StatefulWidget {
  const FaceAcneDetail({Key? key}) : super(key: key);

  @override
  _FaceAcneDetailState createState() => _FaceAcneDetailState();
}

class _FaceAcneDetailState extends State<FaceAcneDetail> {
  late FaceAcneDetailLogic _faceAcneDetailLogic;

  @override
  void initState() {
    super.initState();
    _faceAcneDetailLogic = FaceAcneDetailLogic(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    _faceAcneDetailLogic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        centerTitle: false,
        title: LocaleKeys.generalBack.tr(),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ChangeNotifierProvider<FaceAcneDetailLogic>.value(
              value: _faceAcneDetailLogic,
              builder: (context, snapshot) {
                return Container(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: Column(
                    children: [
                      Selector<FaceAcneDetailLogic, List<AnalyzeDetail>>(
                          selector: (_, __) => __.acneData,
                          builder: (context, snapshot, __) {
                            if (snapshot.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return FaceCarouselAnce(
                              dataAnce: snapshot,
                              onChangePage: (index) {
                                _faceAcneDetailLogic.onChangePageIndex(index);
                              },
                            );
                          }),
                      Selector<FaceAcneDetailLogic, AnalyzeDetail?>(
                          selector: (_, __) => __.acneDetail,
                          builder: (context, acneDetail, __) {
                            if (acneDetail == null) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    acneDetail.skinAnalysisDetail.title
                                            .split(" |")[0] +
                                        acneDetail.skinAnalysisDetail.title
                                            .split(" |")[1]
                                            .toLowerCase(),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .merge(
                                          TextStyle(
                                            fontSize: 22,
                                            color: AppColors.textBlack,
                                            fontFamily: Assets
                                                .googleFonts.montserratBold,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ),
                                  Text(
                                    acneDetail.skinAnalysisDetail.title
                                        .split(" | ")[2],
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .merge(
                                          TextStyle(
                                            fontSize: 22,
                                            color: AppColors.textBlack,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: Assets
                                                .googleFonts.montserratBold,
                                          ),
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Text(
                                          LocaleKeys.analyzeResult,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .merge(
                                                TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textBlueBlack,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBold,
                                                ),
                                              ),
                                        ).tr(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 16,
                                        right: 16,
                                        left: 16,
                                        bottom: 28),
                                    margin: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      children: [
                                        ...getAcneBox(acneDetail.result)
                                            .map(
                                              (acneBox) => AcneRowWidget(
                                                  acneBox: acneBox),
                                            )
                                            .toList(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  LocaleKeys.analyzeConclude,
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .merge(
                                                        const TextStyle(
                                                            fontSize: 12,
                                                            height: 1.5,
                                                            color: AppColors
                                                                .textBlueBlack,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                ).tr(args: [
                                                  acneDetail.skinAnalysisDetail
                                                      .shortTitle!
                                                ]),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: Html(
                                              data: acneDetail
                                                  .skinAnalysisDetail.content,
                                              style: {
                                                "body": Style(
                                                  margin: EdgeInsets.zero,
                                                  padding: EdgeInsets.zero,
                                                  lineHeight:
                                                      const LineHeight(1.5),
                                                  fontSize: const FontSize(13),
                                                  color:
                                                      AppColors.textBlueBlack,
                                                ),
                                                "p": Style(
                                                  padding: EdgeInsets.zero,
                                                  margin: EdgeInsets.zero,
                                                  fontSize: const FontSize(13),
                                                  color:
                                                      AppColors.textBlueBlack,
                                                ),
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: insetsBottom(),
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }

  // 1 -> mụn đỏ/ mụn mủ -> red acne / pustules
  // 2 -> sẹo lõm/ lồi -> Atrophic scars / Keloid scar
  // 3 -> mụn đầu đen/ mụn đầu trắng -> blackhead / whiteheads
  // 4 -> mụn nang -> cystic acne
  List<AcneBox> getAcneBox(AnalyzeResult result) {
    List<AcneBox> _acnes = [
      AcneBox(
        icon: Assets.icons.acneGreen,
        name: LocaleKeys.acne2.tr(),
        count: result.atrophicScars ?? 0,
      ),
      AcneBox(
        icon: Assets.icons.acneBlue,
        name: LocaleKeys.acne3.tr(),
        count: result.blackhead ?? 0,
      ),
      AcneBox(
        icon: Assets.icons.acnePink,
        name: LocaleKeys.acne1.tr(),
        count: result.redAcne ?? 0,
      ),
      AcneBox(
        icon: Assets.icons.acneRed,
        name: LocaleKeys.acne4.tr(),
        count: result.cysticAcne ?? 0,
      )
    ];
    return _acnes;
  }
}
