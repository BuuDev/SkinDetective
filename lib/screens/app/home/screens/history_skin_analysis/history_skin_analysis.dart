import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis_logic.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/flip_widget/flip_widget.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

class HistorySkinAnalysis extends StatefulWidget {
  const HistorySkinAnalysis({Key? key}) : super(key: key);

  @override
  State<HistorySkinAnalysis> createState() => _HistorySkinAnalysisState();
}

class _HistorySkinAnalysisState extends State<HistorySkinAnalysis> {
  late HistorySkinAnalysisLogic skinAnalysisLogic;
  @override
  void initState() {
    super.initState();
    skinAnalysisLogic = HistorySkinAnalysisLogic(context: context);
  }

  @override
  void dispose() {
    skinAnalysisLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: skinAnalysisLogic,
      child: Consumer<HistorySkinAnalysisLogic>(
        builder: (_, val, __) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AppBarWidget(
                    title: LocaleKeys.generalBack.tr(),
                    centerTitle: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: skinAnalysisLogic.active2,
                          child: Text(
                            LocaleKeys.homeHistory,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color:
                                      !skinAnalysisLogic.enableBtnSkinAnalysis
                                          ? AppColors.textBlueBlack
                                          : AppColors.textLightGray,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: Assets.googleFonts.montserratBold,
                                ),
                          ).tr(),
                        ),
                        !skinAnalysisLogic.enableBtnEdit
                            ? TextButton(
                                onPressed: skinAnalysisLogic.active,
                                child: Text(
                                  LocaleKeys.historyAnalysis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textLightGray,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ).tr(gender: 'edit'))
                            : TextButton(
                                onPressed: skinAnalysisLogic.selectAll,
                                child: Text(
                                  LocaleKeys.historyAnalysis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ).tr(gender: 'select_all'),
                              )
                      ],
                    ),
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 25)
                        .copyWith(bottom: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 240,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 8,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: skinAnalysisLogic.data.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () => skinAnalysisLogic.changeValue(
                            index, skinAnalysisLogic.data[index].id),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.backgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(9)
                                        .copyWith(bottom: 2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: FlipWidget(
                                        child: ImageCustom(
                                          urlImage: skinAnalysisLogic
                                                  .data.isNotEmpty
                                              ? '${skinAnalysisLogic.data[index].url}'
                                              : "",
                                          width: 150,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: skinAnalysisLogic.enableBtnEdit,
                                      child: Positioned(
                                        right: 0,
                                        child: Radio(
                                            fillColor:
                                                MaterialStateProperty.all(
                                              AppColors.backgroundColor,
                                            ),
                                            value: true,
                                            activeColor: Colors.red,
                                            groupValue:
                                                skinAnalysisLogic.ob[index],
                                            toggleable: true,
                                            onChanged: (value) {
                                              skinAnalysisLogic.changeValue(
                                                  index,
                                                  skinAnalysisLogic
                                                      .data[index].id);
                                            }),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  child: Text(
                                    (skinAnalysisLogic.data[index].title
                                            .split(" | ")[1])
                                        .toUpperCase(),
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: AppColors.textBlueBlack,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: Assets
                                              .googleFonts.montserratSemiBold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.symmetric(horizontal: 5),
                              //     child: Text(
                              //       skinAnalysisLogic.data[index].title
                              //           .split("|")[2]
                              //           .toUpperCase(),
                              //       maxLines: 1,
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .subtitle1!
                              //           .copyWith(
                              //             color: AppColors.textBlueBlack,
                              //             fontWeight: FontWeight.bold,
                              //             fontFamily: Assets
                              //                 .googleFonts.montserratSemiBold,
                              //             overflow: TextOverflow.ellipsis,
                              //           ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 9.0,
                                  top: 5.0,
                                  bottom: 9,
                                ),
                                child: Text(
                                  DateFormat(FormatDate.formatHistorySkin)
                                      .format(DateTime.parse(skinAnalysisLogic
                                          .data[index].createdAt)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textLightGray,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            Assets.googleFonts.montserratBold,
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: BottomNavigationState.heightInsets(context),
                  )
                ],
              ),
            ),
            bottomNavigationBar: skinAnalysisLogic.enableBtnEdit &&
                    skinAnalysisLogic.data.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: BottomNavigationState.heightInsets(context),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 25,
                        ),
                        child: ButtonWidget(
                            onPressed:
                                skinAnalysisLogic.deleteHistorySkinAnalysis,
                            child: const Text(LocaleKeys.historyAnalysis).tr(
                                gender: 'delete_all',
                                args: [skinAnalysisLogic.count.toString()]),
                            primary: AppColors.textRed),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
