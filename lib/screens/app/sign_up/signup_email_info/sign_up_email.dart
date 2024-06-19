import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/national/national_data.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/input_widget/input_widget.dart';

part 'sign_up_info_logic.dart';
part 'custom_paint_edit.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({Key? key}) : super(key: key);

  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  late SignUpEmailLogic updateInfo;

  @override
  void initState() {
    updateInfo = SignUpEmailLogic(context: context);
    super.initState();
    updateInfo.getNational();
  }

  @override
  void dispose() {
    updateInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: updateInfo,
      child: Consumer<SignUpEmailLogic>(
        builder: (context, value, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: AppColors.textBlack,
                  body: Center(
                    child: Stack(
                      children: [
                        Positioned(
                          left: 32,
                          child: SvgPicture.asset(
                            Assets.icons.backgroundEmail,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 160,
                              ),
                              updateInfo.images == null
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: SizedBox(
                                          width: 80,
                                          height: 40,
                                          child: InkWell(
                                              onTap: () {
                                                updateInfo.filePicker();
                                              },
                                              child: Text(
                                                LocaleKeys
                                                    .enterinfoAvatarUploadfile,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                      fontFamily: Assets
                                                          .googleFonts
                                                          .montserratBold,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .textTertiary,
                                                      height: 1.5,
                                                    ),
                                              ).tr()),
                                        ),
                                      ))
                                  : InkWell(
                                      highlightColor: AppColors.textBlack,
                                      splashColor: AppColors.textBlack,
                                      onTap: () {
                                        updateInfo.filePicker();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white
                                                .withOpacity(0.4),
                                            width: 4,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                File(updateInfo.images!.path)),
                                          ),
                                        ),
                                        width: 128,
                                        height: 128,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                bottom: -11,
                                                left: 10,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 50,
                                                    child: CustomPaint(
                                                      painter: EditPainter(),
                                                    ),
                                                  ),
                                                )),
                                            Positioned(
                                              bottom: 0,
                                              left: 49,
                                              child: Text(
                                                LocaleKeys
                                                    .enterinfoEditUploadfile,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                      fontFamily: Assets
                                                          .googleFonts
                                                          .montserratBlack,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.textBlue,
                                                    ),
                                              ).tr(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 55,
                              ),
                              TextFieldCustom(
                                controller: updateInfo.txtName,
                                onChanged: (text) {
                                  updateInfo.validate();
                                },
                                labelText:
                                    LocaleKeys.enterinforNamePlaceholder.tr(),
                                label: LocaleKeys.enterinforNameLable.tr(),
                                emailColors: AppColors.white,
                              ),
                              Stack(
                                children: [
                                  TextFieldCustom(
                                    controller: updateInfo.txtNamSinh,
                                    onChanged: (text) {
                                      updateInfo.validate();
                                    },
                                    labelText:
                                        LocaleKeys.enterinforYearLable.tr(),
                                    label: LocaleKeys.enterinforYearPlaceholder
                                        .tr(),
                                    emailColors: AppColors.white,
                                    keyboardType: TextInputType.number,
                                  ),
                                  Positioned(
                                    top: 23,
                                    right: 10,
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    AppColors.white,
                                                //title: Text("Select Year"),
                                                content: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: YearPicker(
                                                    firstDate: DateTime(
                                                        DateTime.now().year -
                                                            100,
                                                        1),
                                                    lastDate: DateTime(
                                                        DateTime.now().year -
                                                            14,
                                                        1),

                                                    //initialDate: DateTime.now(),
                                                    onChanged: (value) {
                                                      updateInfo.changYear(
                                                          value.year);
                                                      Navigator.pop(context);
                                                    },
                                                    selectedDate: DateTime(
                                                        DateTime.now().year -
                                                            105),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.expand_less,
                                          color: AppColors.tertiary,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    LocaleKeys.enterinforNationLable.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontFamily: Assets
                                              .googleFonts.montserratBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.white,
                                        )),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Selector<SignUpEmailLogic, List<DataNational>>(
                                  selector: (_, state) => state.nationals,
                                  builder: (_, data, __) {
                                    if (data.isEmpty) {
                                      return const SizedBox();
                                    }
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 11, vertical: 10),
                                      width: double.infinity,
                                      height: 47,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: AppColors.white),
                                      child: DropdownSearch<String>(
                                        selectedItem: data[241].name,
                                        emptyBuilder: (context, searchEntry) =>
                                            Center(
                                                child: const Text(
                                                        LocaleKeys.nationNoData,
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.red))
                                                    .tr()),
                                        mode: Mode.DIALOG,
                                        showSearchBox: true,
                                        popupBackgroundColor: AppColors.white,
                                        items: data.map((e) => e.name).toList(),
                                        onChanged: (value) {
                                          updateInfo.changeNational(value!);
                                        },
                                        dropdownButtonProps:
                                            const IconButtonProps(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                                icon: Icon(
                                                  Icons.expand_less,
                                                  color: AppColors.tertiary,
                                                  size: 30,
                                                )),
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                hintText: LocaleKeys
                                                    .enterinforNationLable
                                                    .tr(),
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        color: AppColors
                                                            .textLightGray,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: -6),
                                                border: InputBorder.none),
                                      ),
                                    );
                                  }),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ButtonWidget(
                                  onPressed: () {
                                    updateInfo.checkProfile();
                                  },
                                  child: Text(
                                    LocaleKeys.signupEmailEnterinforButton,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontFamily: Assets
                                              .googleFonts.montserratBlack,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                  ).tr(),
                                  primary: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
