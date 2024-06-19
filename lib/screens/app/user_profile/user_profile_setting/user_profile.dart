import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/models/national/national_data.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:skin_detective/screens/app/sign_up/signup_email_info/sign_up_email.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../models/user/user.dart';
import '../../../../providers/app/app.dart';
import '../../../../providers/user/user.dart';
import '../../../../services/apis/user/user.dart';
import '../../../../theme/color.dart';
import '../../../../utils/notify_helper/notify_helper.dart';
import '../../../../widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../widgets/button_widget/button_widget.dart';
import '../../../../widgets/input_widget/input_widget.dart';

part 'user_profile_logic.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin {
  late UserProfileLogic profile;

  @override
  void initState() {
    super.initState();
    profile = context.read<UserProfileLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (profile.lst.isEmpty) {
        profile.getNational();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: profile,
      child: Consumer<UserProfileLogic>(
        builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBarWidget(
                title: LocaleKeys.generalBack.tr(),
                centerTitle: false,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.profileTitle,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontFamily: Assets.googleFonts.montserratBlack,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                              height: 1.5,
                            ),
                      ).tr(),
                      const SizedBox(
                        height: 30,
                      ),
                      Selector<UserViewModel, User>(
                          selector: (_, state) => state.data,
                          builder: (_, userInfo, __) {
                            return Column(
                              children: [
                                Center(
                                  child: userInfo.avatar != null
                                      ? Container(
                                          width: 128,
                                          height: 128,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.white
                                                    .withOpacity(0.4),
                                                width: 4,
                                              ),
                                              image: profile.images == null
                                                  ? userInfo.avatar!.isEmpty
                                                      ? null
                                                      : DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              userInfo.avatar ??
                                                                  "",
                                                              scale: 1.0))
                                                  : DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                          File(profile
                                                              .images!.path),
                                                          scale: 1.0))),
                                          child: InkWell(
                                            highlightColor:
                                                AppColors.textLightGrayBG,
                                            splashColor:
                                                AppColors.textLightGrayBG,
                                            onTap: () {
                                              profile.filePicker();
                                            },
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
                                                          painter:
                                                              EditPainter(),
                                                        ),
                                                      ),
                                                    )),
                                                Positioned(
                                                    bottom: 0,
                                                    left: 50,
                                                    child: Text(
                                                      LocaleKeys
                                                          .enterinfoEditUploadfile,
                                                      textAlign:
                                                          TextAlign.center,
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
                                                                .textBlack,
                                                          ),
                                                    ).tr()),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Stack(
                                            children: [
                                              profile.images == null
                                                  ? Image.asset(
                                                      Assets.images
                                                          .iconAvatarNull.path,
                                                      width: 128,
                                                      height: 128,
                                                      fit: BoxFit.cover)
                                                  : CircleAvatar(
                                                      radius: 64,
                                                      backgroundImage:
                                                          FileImage(File(profile
                                                              .images!.path)),
                                                    ),
                                              Positioned(
                                                bottom: 40,
                                                left: 42,
                                                child: InkWell(
                                                  onTap: () {
                                                    profile.filePicker();
                                                  },
                                                  child: SvgPicture.asset(
                                                    Assets.icons.iconThuvien,
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFieldCustom(
                                  controller: profile.txtName,
                                  onChanged: (text) {
                                    profile.validate();
                                  },
                                  label: LocaleKeys.profileNameLable.tr(),
                                  keyboardType: TextInputType.text,
                                ),
                                Stack(
                                  children: [
                                    TextFieldCustom(
                                      controller: profile.txtDateTime,
                                      onChanged: (text) {
                                        profile.validate();
                                      },
                                      label: LocaleKeys.profileYearLable.tr(),
                                      keyboardType: TextInputType.number,
                                    ),
                                    Positioned(
                                      top: 25,
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
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
                                                      initialDate: DateTime(
                                                          DateTime.now().year -
                                                              10,
                                                          1),
                                                      onChanged: (value) {
                                                        profile.getYear(
                                                            value.year);
                                                        profile.validate();
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
                              ],
                            );
                          }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(LocaleKeys.profileNatioLable.tr(),
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Selector<UserProfileLogic, List<DataNational>>(
                          selector: (_, state) => state.lst,
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
                                  borderRadius: BorderRadius.circular(9),
                                  color: AppColors.white),
                              child: DropdownSearch<String>(
                                emptyBuilder: (context, searchEntry) => Center(
                                    child: const Text(LocaleKeys.nationNoData,
                                            style:
                                                TextStyle(color: AppColors.red))
                                        .tr()),
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                popupBackgroundColor: AppColors.white,
                                items: data.map((e) => e.name).toList(),
                                selectedItem: profile.nationSelected.name,
                                onChanged: (value) {
                                  profile.changeNational(value!);
                                },
                                dropdownButtonProps: const IconButtonProps(
                                    padding: EdgeInsets.only(bottom: 20),
                                    icon: Icon(
                                      Icons.expand_less,
                                      color: AppColors.tertiary,
                                      size: 30,
                                    )),
                                dropdownSearchDecoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(top: -5),
                                    border: InputBorder.none),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Selector<UserProfileLogic, bool>(
                          selector: (_, state) => state.enable,
                          builder: (_, enable, __) {
                            return SizedBox(
                              width: double.infinity,
                              child: ButtonWidget(
                                  onPressed: () {
                                    if (enable) {
                                      if (profile.images != null) {
                                        enable = true;

                                        profile.updateUser(
                                            File(profile.images!.path));
                                      } else {
                                        profile.updateUser();
                                      }
                                    }
                                  },
                                  child: Text(
                                    LocaleKeys.signupEmailEnterinforButton,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontFamily: Assets
                                              .googleFonts.montserratBlack,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ).tr(),
                                  primary: enable
                                      ? AppColors.primary
                                      : AppColors.textLightGrayDisabled),
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (GetIt.instance<AppVM>().isLogged) {
                            Navigator.pushNamed(
                                context, AppRoutes.resetPassWord);
                          }
                        },
                        child: Text(
                          LocaleKeys.profileResetPasswordLable,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                fontFamily: Assets.googleFonts.montserratBlack,
                                fontWeight: FontWeight.w700,
                                color: GetIt.instance<AppVM>().isLogged
                                    ? AppColors.textBlack
                                    : AppColors.textLightGrayDisabled,
                              ),
                        ).tr(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
