import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/blog_save_user/blog_user_data.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/cosmetic_user/cosmetic_user_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/services/apis/post/post.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';
import 'package:tuple/tuple.dart';
import '../../../../../../constants/type_globals.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../widgets/button_widget/button_widget.dart';
part 'personal_logic.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal>
    with AutomaticKeepAliveClientMixin {
  late PersonalLogic personal;
  @override
  void initState() {
    super.initState();
    personal = context.read<PersonalLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      personal.reloadPost();
    });
  }

  Widget xemThem(bool isSeeMore, String icon) {
    bool hasSeeMore = false;
    if (icon == Assets.icons.blog && personal.dataPost.total! > 2) {
      hasSeeMore = true;
    } else if (icon == Assets.icons.iconCosmetic &&
        personal.dataCosmetic.total! > 2) {
      hasSeeMore = true;
    } else if (icon == Assets.icons.article && personal.dataBlog.total! > 2) {
      hasSeeMore = true;
    }

    if (!hasSeeMore) {
      return const SizedBox();
    }

    return InkWell(
      onTap: () {
        if (icon == Assets.icons.blog) {
          personal.checkPost();
        } else if (icon == Assets.icons.iconCosmetic) {
          personal.checkCosmetic();
        } else {
          personal.checkBlog();
        }
      },
      child: Text(
        isSeeMore ? LocaleKeys.generalShowMore : LocaleKeys.generalCollapse,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: Assets.googleFonts.montserratBlack,
            color: AppColors.textTertiary),
      ).tr(),
    );
  }

  Widget personalWidget(bool isSeeMore, String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(right: 25, left: 10, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    color: AppColors.textBlack,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBlack,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                  ).tr(),
                ],
              )),
          xemThem(isSeeMore, icon),
        ],
      ),
    );
  }

  Widget writeShareNow(String nameButton, String icons) {
    return SizedBox(
      width: Helper.percentWidth(pixel: 187, context: context),
      height: Helper.percentHeight(pixel: 51, context: context),
      child: ButtonWidget(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.newPost),
        type: EButton.full,
        icon: icons,
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          nameButton,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: Assets.googleFonts.montserratSemiBold,
                color: AppColors.white,
              ),
        ).tr(),
      ),
    );
  }

  void gotoPostDetail(int id) {
    Navigator.pushNamed(context, AppRoutes.blogDetailPersonal, arguments: id)
        .then((value) {
      if (value == true) {
        personal.reloadPost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: personal,
      child: Consumer<PersonalLogic>(
        builder: ((context, value, child) {
          return RefreshIndicator(
            backgroundColor: AppColors.white,
            color: AppColors.textBlack,
            onRefresh: personal.reset,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  personalWidget(
                    personal.isCheckPost,
                    Assets.icons.blog,
                    LocaleKeys.myPostListTitle,
                  ),
                  const SizedBox(height: 24),
                  if (personal.dataPost.data.isNotEmpty) ...[
                    writeShareNow(LocaleKeys.myPostListCreatePostButton,
                        Assets.icons.iconAdd),
                    const SizedBox(height: 24),
                  ],
                  Selector<PersonalLogic, Tuple2<List<ConsMeticData>, bool>>(
                    selector: (_, state) =>
                        Tuple2(state.dataPost.data, state.checkEmpty),
                    builder: (_, value, __) {
                      if (value.item1.isEmpty) {
                        if (!value.item2) {
                          return const Center(
                              child: FooterLoading(isLoading: true));
                        }
                        return Column(
                          children: [
                            Text(
                              LocaleKeys.myPostListNullTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontFamily:
                                        Assets.googleFonts.montserratBlack,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textBlueBlack,
                                  ),
                            ).tr(),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                LocaleKeys.myPostListNullContent,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                              ).tr(),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            if (personal.dataPost.data.isEmpty)
                              writeShareNow(
                                  LocaleKeys.myPostListNowCreatePostButton,
                                  Assets.icons.pen),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 15,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                              color: AppColors.textLightGrayBG.withOpacity(0.5),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: List.generate(
                          value.item1.length,
                          (index) => Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  gotoPostDetail(value.item1[index].id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 21, right: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          child: ImageCustom(
                                            urlImage:
                                                value.item1[index].thumbnail!,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          )),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: Helper.percentHeight(
                                                  pixel: 60, context: context),
                                              child: Text(
                                                value.item1[index].detail.title,
                                                maxLines: 3,
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.22,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          AppColors.textBlack,
                                                    ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                'post_status_${value.item1[index].fieldStatus}' !=
                                                        'post_status_active'
                                                    ? Text(
                                                        'post_status_${value.item1[index].fieldStatus}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1!
                                                            .copyWith(
                                                              fontFamily: Assets
                                                                  .googleFonts
                                                                  .montserratSemiBold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: value
                                                                  .item1[index]
                                                                  .status!
                                                                  .color,
                                                            ),
                                                      ).tr()
                                                    : Expanded(
                                                        child: Text(
                                                          GetIt.instance<
                                                                  UserViewModel>()
                                                              .data
                                                              .name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle1!
                                                                  .copyWith(
                                                                    fontFamily: Assets
                                                                        .googleFonts
                                                                        .montserratSemiBold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: AppColors
                                                                        .textTertiary,
                                                                  ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Divider(
                                height: 15,
                                thickness: 2,
                                indent: 10,
                                endIndent: 10,
                                color:
                                    AppColors.textLightGrayBG.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  if (personal.dataBlog.data.isNotEmpty) ...[
                    Divider(
                      height: 15,
                      thickness: 4,
                      indent: 10,
                      endIndent: 10,
                      color: AppColors.textLightGrayBG.withOpacity(0.5),
                    ),
                    const SizedBox(height: 10),
                    personalWidget(
                      personal.isCheckBlog,
                      Assets.icons.article,
                      LocaleKeys.saveBlogListTitle,
                    )
                  ],
                  Selector<PersonalLogic, List<BlogUserData>>(
                    selector: (_, state) => state.dataBlog.data,
                    builder: (_, value, __) {
                      if (value.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: List.generate(
                          value.length,
                          (index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 22, right: 24),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.blogDetail,
                                        arguments: value[index].postId);
                                  },
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            child: ImageCustom(
                                              urlImage:
                                                  value[index].posts.thumbnail,
                                              fit: BoxFit.cover,
                                              width: 80,
                                              height: 80,
                                            )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: Helper.percentHeight(
                                                    pixel: 60,
                                                    context: context),
                                                child: Text(
                                                  value[index]
                                                      .posts
                                                      .detail
                                                      .title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                          fontFamily: Assets
                                                              .googleFonts
                                                              .montserratSemiBold,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .textBlack,
                                                          height: 1.3333),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                value[index]
                                                    .posts
                                                    .detail
                                                    .getDateCreated(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                      fontSize:
                                                          AppFonts.font_11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .textTertiary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 5,
                                thickness: 2,
                                indent: 20,
                                endIndent: 20,
                                color:
                                    AppColors.textLightGrayBG.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (personal.dataCosmetic.data.isNotEmpty) ...[
                    Divider(
                      height: 15,
                      thickness: 4,
                      indent: 10,
                      endIndent: 10,
                      color: AppColors.textLightGrayBG.withOpacity(0.5),
                    ),
                    const SizedBox(height: 10),
                    personalWidget(
                        personal.isCheckCosmetic,
                        Assets.icons.iconCosmetic,
                        LocaleKeys.saveCosmeticsListTitle),
                  ],
                  Selector<PersonalLogic, List<CosmeticUserData>>(
                    selector: (_, state) => state.dataCosmetic.data,
                    builder: (_, value, __) {
                      if (value.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: List.generate(
                          value.length,
                          (index) => Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 24),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.cosmeticDetail,
                                            arguments: value[index].postId);
                                      },
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: ImageCustom(
                                                urlImage: value[index]
                                                    .posts
                                                    .thumbnail,
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    value[index]
                                                        .posts
                                                        .detail
                                                        .title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: Assets
                                                              .googleFonts
                                                              .montserratBold,
                                                          color: AppColors
                                                              .textBlack,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    value[index]
                                                        .posts
                                                        .detail
                                                        .brand!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                          fontFamily: Assets
                                                              .googleFonts
                                                              .montserratSemiBold,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .textBlack,
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    value[index]
                                                        .posts
                                                        .detail
                                                        .description!,
                                                    maxLines: 2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                          fontSize:
                                                              AppFonts.font_11,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.5,
                                                          color: AppColors
                                                              .textTertiary,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    height: 5,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 20,
                                    color: AppColors.textLightGrayBG
                                        .withOpacity(0.5),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
