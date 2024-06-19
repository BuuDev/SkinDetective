import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/settings/setting.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/smooth_rating_start/smooth_rating.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({Key? key}) : super(key: key);

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  late SettingLogic settingLogic;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingLogic = SettingLogic(context: context);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      settingLogic.getPointaverage();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    settingLogic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: LocaleKeys.generalBack.tr(),
        centerTitle: false,
        textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: AppColors.textLightGray,
            ),
      ),
      body: ChangeNotifierProvider.value(
        value: settingLogic,
        child: Consumer<SettingLogic>(
          builder: (_, value, __) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            LocaleKeys.settingRating.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AspectRatio(
                        aspectRatio: 2.5,
                        child: Image.asset(
                          Assets.images.splash.path,
                        ),
                      ),
                    ),
                    SmoothStarRating(
                      color: Colors.amber,
                      allowHalfRating: true,
                      borderColor: AppColors.textLightGray,
                      rating: settingLogic.point,
                      size: 40,
                      onRatingChanged: (value) {
                        settingLogic.changeRating(value);
                      },
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 15),
                          child: Text(
                            LocaleKeys.settingRatingNhanxet.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24.0, right: 24, top: 12),
                      child: TextField(
                        controller: settingLogic.commentController,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: AppColors.black,
                            ),
                        maxLines: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundColor,
                          hintText:
                              LocaleKeys.settingRatingCommentPlaceholder.tr(),
                          hintStyle:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textLightGray,
                                    fontWeight: FontWeight.bold,
                                  ),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.textBlue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 24),
                          child: Text(
                            LocaleKeys.settingRatingPicture.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 24),
                          child: GestureDetector(
                            onTap: () {
                              settingLogic.selectImage();
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.textLightGray,
                                    width: 2,
                                  )),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.textLightGray,
                              ),
                            ),
                          ),
                        ),
                        settingLogic.file.isNotEmpty
                            ? settingLogic.file.length > 2
                                ? Row(
                                    children: [
                                      ...List.generate(2, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      AppColors.textLightGray,
                                                  width: 2,
                                                )),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(settingLogic
                                                        .file[index].path),
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                    top: -15,
                                                    right: -15,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          settingLogic
                                                              .removeImage(
                                                                  index);
                                                        },
                                                        icon: const Icon(
                                                          Icons.dangerous,
                                                          size: 20,
                                                          color: AppColors.gray,
                                                        )))
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10),
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.gray,
                                                width: 2,
                                              ),
                                              image: DecorationImage(
                                                image: FileImage(
                                                    settingLogic.file[2]),
                                                fit: BoxFit.fitWidth,
                                                opacity: 0.2,
                                              )),
                                          child: Center(
                                            child: Text(
                                              settingLogic.file.length
                                                      .toString() +
                                                  "+",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      ...List.generate(settingLogic.file.length,
                                          (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      AppColors.textLightGray,
                                                  width: 2,
                                                )),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(settingLogic
                                                        .file[index].path),
                                                    width: 56,
                                                    height: 56,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                    top: -15,
                                                    right: -15,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          settingLogic
                                                              .removeImage(
                                                                  index);
                                                        },
                                                        icon: const Icon(
                                                          Icons.dangerous,
                                                          size: 20,
                                                          color: AppColors.gray,
                                                        )))
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                            : Container()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24,
                        top: 20,
                      ),
                      child: InkWell(
                        onTap: () {
                          settingLogic.activeRadioButton();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                settingLogic.activeRadioButton();
                              },
                              child: SvgPicture.asset(
                                settingLogic.check
                                    ? Assets.icons.radioButtonActive1
                                    : Assets.icons.radioButton1,
                                width: 18,
                                height: 18,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: LocaleKeys.generalCheckPart1.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textBlack,
                                        fontWeight: FontWeight.w700,
                                        fontFamily:
                                            Assets.googleFonts.montserratBlack,
                                      ),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' ${LocaleKeys.generalCheckPart2.tr()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: AppColors.textBlueBG,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: Assets
                                                .googleFonts.montserratBlack,
                                          ),
                                    ),
                                    TextSpan(
                                        text:
                                            ' ${LocaleKeys.generalCheckPart3.tr()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: AppColors.textBlack,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: Assets
                                                  .googleFonts.montserratBlack,
                                            )),
                                    TextSpan(
                                      text:
                                          ' ${LocaleKeys.generalCheckPart4.tr()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: AppColors.textBlueBG,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: Assets
                                                .googleFonts.montserratBlack,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, top: 20, right: 24, bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: ButtonWidget(
                          onPressed: () {
                            settingLogic.rating();
                          },
                          child: Text(
                            LocaleKeys.settingRatingButton.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          primary: settingLogic.check
                              ? AppColors.textBlue
                              : AppColors.textLightGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: BottomNavigationState.heightInsets(context),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
