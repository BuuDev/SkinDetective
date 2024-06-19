import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/models/create_post/create_post_data.dart';
import 'package:skin_detective/models/create_post/image.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/personal.dart';
import 'package:skin_detective/services/apis/blog_detail_personal/blog_detail_personal.dart';
import 'package:skin_detective/services/apis/post/post.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';
import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../utils/notify_helper/notify_helper.dart';
import '../../../../../../../widgets/button_widget/button_widget.dart';
import '../../../../../../../widgets/custom_dialog/custom_dialog.dart';
import '../../../../../../../widgets/input_widget/input_widget.dart';
part 'new_post_logic.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  late NewPostLogic newPostLogic;

  @override
  void initState() {
    super.initState();

    newPostLogic = NewPostLogic(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.textLightGrayBG,
        body: ChangeNotifierProvider.value(
            value: newPostLogic,
            child: Consumer<NewPostLogic>(
              builder: (_, value, __) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            "http://sd-api.pixelcent.com/analysis-images/71/71_03042022074405.png",
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 20),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.icons.arrowLeftBack,
                                        fit: BoxFit.scaleDown,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        LocaleKeys.generalBack,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              fontFamily: Assets
                                                  .googleFonts.montserratBold,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                            ),
                                      ).tr(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.gategoriesNavPost,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontFamily: Assets
                                                    .googleFonts.montserratBold,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textLightBlue,
                                              ),
                                        ).tr(),
                                        Text(
                                          LocaleKeys.createPostTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                                fontFamily: Assets
                                                    .googleFonts.montserratBold,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.white,
                                              ),
                                        ).tr(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 25, top: 20, right: 25),
                        child: TextFieldCustom(
                          controller: newPostLogic.txtTitle,
                          onChanged: (text) {
                            newPostLogic.validate();
                          },
                          labelText: LocaleKeys.createPostTitlePlaceholder.tr(),
                          autoFocus: false,
                          keyboardType: TextInputType.emailAddress,
                          label: LocaleKeys.createPostTitleLable.tr(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(LocaleKeys.createPostContentLable,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textBlack,
                                        fontWeight: FontWeight.w700,
                                      )).tr(),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                newPostLogic.validate();
                              },
                              controller: newPostLogic.txtContent,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: AppColors.black,
                                  ),
                              maxLines: 4,
                              decoration: InputDecoration(
                                fillColor: AppColors.backgroundColor,
                                hintText: LocaleKeys
                                    .createPostContentPlaceholder
                                    .tr(),
                                filled: true,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: AppColors.textLightGray,
                                        fontWeight: FontWeight.w400),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                LocaleKeys.createPostImgLable,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).tr(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    newPostLogic.selectImage();
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
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
                                newPostLogic.file.isNotEmpty
                                    ? newPostLogic.file.length > 2
                                        ? Row(
                                            children: [
                                              ...List.generate(2, (index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .textLightGray,
                                                        )),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.file(
                                                            File(newPostLogic
                                                                .file[index]
                                                                .path),
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
                                                                  newPostLogic
                                                                      .removeImage(
                                                                          index);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .dangerous,
                                                                  size: 20,
                                                                  color:
                                                                      AppColors
                                                                          .gray,
                                                                )))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: AppColors.gray,
                                                        width: 2,
                                                      ),
                                                      image: DecorationImage(
                                                        image: FileImage(
                                                            newPostLogic
                                                                .file[2]),
                                                        fit: BoxFit.fitWidth,
                                                        opacity: 0.2,
                                                      )),
                                                  child: Center(
                                                    child: Text(
                                                      newPostLogic.file.length
                                                              .toString() +
                                                          "+",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .copyWith(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              ...List.generate(
                                                  newPostLogic.file.length,
                                                  (index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: AppColors
                                                              .textLightGray,
                                                          width: 2,
                                                        )),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.file(
                                                            File(newPostLogic
                                                                .file[index]
                                                                .path),
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
                                                                  newPostLogic
                                                                      .removeImage(
                                                                          index);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .dangerous,
                                                                  size: 20,
                                                                  color:
                                                                      AppColors
                                                                          .gray,
                                                                )))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          )
                                    : Selector<NewPostLogic, List<Images>>(
                                        selector: (_, state) =>
                                            state.updateImage!,
                                        builder: ((context, value, child) {
                                          return value.isEmpty
                                              ? Container()
                                              : Row(
                                                  children: [
                                                    ...List.generate(
                                                        value.length, (index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .textLightGray,
                                                                    width: 2,
                                                                  )),
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child:
                                                                      ImageCustom(
                                                                    urlImage:
                                                                        value[index]
                                                                            .url,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: 56,
                                                                    height: 56,
                                                                  )),
                                                              Positioned(
                                                                  top: -15,
                                                                  right: -15,
                                                                  child: IconButton(
                                                                      onPressed: () {
                                                                        newPostLogic
                                                                            .deleteImageUpdate(index);
                                                                      },
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .dangerous,
                                                                        size:
                                                                            20,
                                                                        color: AppColors
                                                                            .gray,
                                                                      )))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                );
                                        }),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: InkWell(
                                    onTap: () {
                                      newPostLogic.activeRadioButton();
                                    },
                                    child: SvgPicture.asset(
                                      newPostLogic.check
                                          ? Assets.icons.radioButtonActive1
                                          : Assets.icons.radioButton1,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    highlightColor: AppColors.textLightGrayBG,
                                    splashColor: AppColors.textLightGrayBG,
                                    onTap: () {
                                      newPostLogic.activeRadioButton();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: LocaleKeys.generalCheckPart1.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: AppColors.textBlack,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: ' ' +
                                                LocaleKeys.generalCheckPart2
                                                    .tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  color: AppColors.textBlueBG,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          TextSpan(
                                              text: ' ' +
                                                  LocaleKeys.generalCheckPart3
                                                      .tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    color: AppColors.textBlack,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                          TextSpan(
                                            text: ' ' +
                                                LocaleKeys.generalCheckPart4
                                                    .tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: AppColors.textBlueBG,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ButtonWidget(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  newPostLogic.createPost();
                                },
                                child: Text(
                                  LocaleKeys.createPostPostButton,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ).tr(),
                                primary: newPostLogic.enable
                                    ? AppColors.textBlue
                                    : AppColors.textLightGrayDisabled,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ButtonWidget(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  newPostLogic.createDraft();
                                },
                                child: Text(
                                  LocaleKeys.createPostDraftButton,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textBlack,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ).tr(),
                                primary: newPostLogic.enable
                                    ? AppColors.textLightBlue
                                    : AppColors.textLightGrayDisabled,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ButtonWidget(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  newPostLogic.delete();
                                },
                                child: Text(
                                  LocaleKeys.createPostDeleteButton,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ).tr(),
                                primary: AppColors.textLightGrayBG,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
