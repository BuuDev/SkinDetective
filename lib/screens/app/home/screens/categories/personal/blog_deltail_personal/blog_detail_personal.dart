import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/blog_deltail_personal/blog_detail_personal_logic.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/custom_dialog/custom_dialog.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';

import 'package:skin_detective/widgets/sliderImage/slider_image.dart';
import '../../../../../../../theme/color.dart';
import '../../../../../../../widgets/app_bar_widget/app_bar_widget.dart';
import '../../../../../../../widgets/comment_widget/comment_widget.dart';

class BlogDetailPersonal extends StatefulWidget {
  const BlogDetailPersonal({Key? key}) : super(key: key);

  @override
  State<BlogDetailPersonal> createState() => _BlogDetailPersonalState();
}

class _BlogDetailPersonalState extends State<BlogDetailPersonal> {
  late BlogDetailPersonalLogic blogDetailPersonalLogic;
  late SharedPreferences getLang;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blogDetailPersonalLogic = BlogDetailPersonalLogic(context: context);
    initLocalStorage();
  }

  int get id => ModalRoute.of(context)!.settings.arguments as int;
  void writeComment() {
    Navigator.pushNamed(context, AppRoutes.createCommentPage).then((value) {
      String comment = '${(value ?? '')}';
      if ('${(value ?? '')}'.isNotEmpty) {
        blogDetailPersonalLogic.createComment(comment);
      }
    });
  }

  void initLocalStorage() async {
    getLang = await SharedPreferences.getInstance();
  }

  String formatDateTime(String date) {
    String value;
    if (getLang.getString('lang') == "vn") {
      value =
          DateFormat(FormatDate.formatDateTime).format(DateTime.parse(date));
    } else {
      value = DateFormat.yMMMMd('en_US').format(DateTime.parse(date));
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: blogDetailPersonalLogic,
      child: Consumer<BlogDetailPersonalLogic>(
        builder: (_, value, child) {
          return Scaffold(
            appBar: AppBarWidget(
              title: LocaleKeys.blogDetailPostBackText.tr(),
              centerTitle: false,
              textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLightGray,
                  ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textLightGray,
                  )),
              action: [
                IconButton(
                    onPressed: () {
                      blogDetailPersonalLogic.save();
                      blogDetailPersonalLogic.saveCosmetic(id);
                    },
                    icon: !blogDetailPersonalLogic.btnSave
                        ? const Icon(
                            Icons.bookmark_border_outlined,
                            color: AppColors.textLightGray,
                          )
                        : const Icon(
                            Icons.bookmark,
                            color: AppColors.acne2,
                          )),
                blogDetailPersonalLogic.status.tr().tr() ==
                            blogDetailPersonalLogic.getStatus(TypeBlog.draft) ||
                        blogDetailPersonalLogic.status.tr() ==
                            blogDetailPersonalLogic
                                .getStatus(TypeBlog.active) ||
                        blogDetailPersonalLogic.status.tr() ==
                            blogDetailPersonalLogic.getStatus(TypeBlog.disabled)
                    ? Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: PopupMenuButton(
                            offset: const Offset(-10.0, kToolbarHeight),
                            child: const Icon(Icons.pending_outlined,
                                color: AppColors.textLightGray),
                            itemBuilder: (_) {
                              return [
                                PopupMenuItem(
                                    value:
                                        blogDetailPersonalLogic.status.tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.draft) ||
                                                blogDetailPersonalLogic.status
                                                        .tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.disabled)
                                            ? 2
                                            : 0,
                                    child: GestureDetector(
                                      child: Text(
                                        blogDetailPersonalLogic.status.tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.draft) ||
                                                blogDetailPersonalLogic.status
                                                        .tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.disabled)
                                            ? LocaleKeys
                                                .postDetailUpdateStatusEdit
                                                .tr()
                                            : LocaleKeys
                                                .postDetailUpdateStatusHide
                                                .tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textBlack,
                                            ),
                                      ),
                                    )),
                                PopupMenuItem(
                                    value:
                                        blogDetailPersonalLogic.status.tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.draft) ||
                                                blogDetailPersonalLogic.status
                                                        .tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.disabled)
                                            ? 3
                                            : 1,
                                    child: GestureDetector(
                                      child: Text(
                                        blogDetailPersonalLogic.status.tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.draft) ||
                                                blogDetailPersonalLogic.status
                                                        .tr() ==
                                                    blogDetailPersonalLogic
                                                        .getStatus(
                                                            TypeBlog.disabled)
                                            ? LocaleKeys
                                                .postDetailUpdateStatusPost
                                                .tr()
                                            : LocaleKeys
                                                .postDetailUpdateStatusDelete
                                                .tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textBlack,
                                            ),
                                      ),
                                    ))
                              ];
                            },
                            onSelected: (value) async {
                              if (value == 0) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) {
                                      return CustomDialog(
                                        icon:
                                            SvgPicture.asset(Assets.icons.eye),
                                        title: LocaleKeys
                                            .postDetailHidePopupTitle
                                            .tr(),
                                        subtitle: LocaleKeys
                                            .postDetailHidePopupContent
                                            .tr(),
                                        height: 197,
                                        titleColor: AppColors.textBlack,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      LocaleKeys
                                                          .commentDeletePopupNoButton
                                                          .tr(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .copyWith(
                                                            color: AppColors
                                                                .textBlack,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    )),
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    blogDetailPersonalLogic
                                                        .changeStatus(
                                                            "disabled");
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: Text(
                                                    LocaleKeys
                                                        .postDetailUpdateStatusHide
                                                        .tr(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) {
                                                      return AppColors.primary;
                                                    }),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              } else if (value == 1) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) {
                                      return CustomDialog(
                                        icon: SvgPicture.asset(
                                          Assets.icons.delete,
                                          color: AppColors.red,
                                        ),
                                        height: 197,
                                        title: LocaleKeys
                                            .postDetailUpdateStatusDelete
                                            .tr(),
                                        subtitle:
                                            'Bài viết không thể khôi phục sau khi xoá.',
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        LocaleKeys
                                                            .commentDeletePopupNoButton
                                                            .tr(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1!
                                                            .copyWith(
                                                              color: AppColors
                                                                  .textBlueBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      )),
                                                ),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      await blogDetailPersonalLogic
                                                          .changeStatus(
                                                              "delete");
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: Text(
                                                      LocaleKeys
                                                          .postDetailUpdateStatusDelete
                                                          .tr(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1!
                                                          .copyWith(
                                                            color:
                                                                AppColors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  (states) {
                                                        return AppColors
                                                            .textRed;
                                                      }),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              } else if (value == 2) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.newPost,
                                  arguments: blogDetailPersonalLogic.postId,
                                ).then((value) {
                                  blogDetailPersonalLogic
                                      .getBlogDetailPersonal(id);
                                });
                              } else if (value == 3) {
                                await blogDetailPersonalLogic
                                    .changeStatus("waiting");
                                Navigator.pop(context, true);
                                blogDetailPersonalLogic.getPostUser(30);
                              }
                            }),
                      )
                    : const SizedBox()
              ],
            ),
            body: value.data == null
                ? const Center(child: FooterLoading(isLoading: true))
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        blogDetailPersonalLogic.data != null &&
                                'post_status_${blogDetailPersonalLogic.data!.getFiledStatus}'
                                        .tr() !=
                                    blogDetailPersonalLogic
                                        .getStatus(TypeBlog.active)
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: 'post_status_${blogDetailPersonalLogic.data!.getFiledStatus}'
                                                  .tr() ==
                                              "Bản nháp"
                                          ? AppColors.textLightBlue
                                          : 'post_status_${blogDetailPersonalLogic.data!.getFiledStatus}'
                                                      .tr() ==
                                                  blogDetailPersonalLogic
                                                      .getStatus(
                                                          TypeBlog.disabled)
                                              ? AppColors.textBlueBlack
                                              : AppColors.textLightBlue,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 235, 228, 228),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ]),
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      blogDetailPersonalLogic.data != null
                                          ? 'post_status_${blogDetailPersonalLogic.data!.getFiledStatus}'
                                              .tr()
                                          : 'loading...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Text(
                            blogDetailPersonalLogic.data != null
                                ? blogDetailPersonalLogic.data!.detail.title
                                : "loading...",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                  color: AppColors.textBlack,
                                  fontFamily: Assets.googleFonts.montserratBold,
                                  letterSpacing: -1,
                                ),
                          ),
                        ),
                        ListTile(
                          leading: blogDetailPersonalLogic.data != null &&
                                  blogDetailPersonalLogic.data!.user.avatar !=
                                      null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      blogDetailPersonalLogic.data!.user.avatar
                                          .toString()))
                              : CircleAvatar(
                                  backgroundImage: AssetImage(
                                      Assets.images.avatarLogout.path),
                                ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                blogDetailPersonalLogic.data != null
                                    ? blogDetailPersonalLogic.data!.user.name
                                    : "loading...",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: AppColors.acne4,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Text(
                                  blogDetailPersonalLogic.data != null
                                      ? formatDateTime(blogDetailPersonalLogic
                                          .data!.createdAt)
                                      : "loading...",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textLightGray,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SliderImage(
                              lstImage: List.generate(
                                  blogDetailPersonalLogic.data!.images!.length,
                                  (index) {
                            return blogDetailPersonalLogic
                                .data!.images![index].url;
                          })),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        blogDetailPersonalLogic.data != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 15),
                                child: Text(
                                  blogDetailPersonalLogic.data!.detail.content,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textBlueBlack,
                                      ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 15),
                                child: Text(
                                  'Loading...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.textBlueBlack,
                                      ),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.0,
                              left: 20,
                              bottom: blogDetailPersonalLogic.data != null &&
                                      'post_status_${blogDetailPersonalLogic.data!.getFiledStatus}'
                                              .tr() ==
                                          blogDetailPersonalLogic
                                              .getStatus(TypeBlog.active)
                                  ? 0
                                  : 30),
                          child: Text(
                            LocaleKeys.commentListTitle.tr(
                                args: [(value.lstComment.length.toString())]),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: AppColors.textBlueBlack,
                                    ),
                          ),
                        ),
                        ...List.generate(value.lstComment.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CommentWidget(
                              key: Key(value.lstComment[index].id.toString()),
                              avatar:
                                  value.lstComment[index].users.avatar != null
                                      ? value.lstComment[index].users.avatar
                                          as String
                                      : null,
                              content: """
<p>${value.lstComment[index].content}</p>
""",
                              name: value.lstComment[index].users.name,
                              date: formatDateTime(
                                  value.lstComment[index].createdAt),
                              userId: value.lstComment[index].userId,
                              deleteComment: () {
                                value.deletedComment(
                                    value.lstComment[index].id, index);
                              },
                              status: value.lstComment[index].status.tr(),
                            ),
                          );
                        }),
                        blogDetailPersonalLogic.data != null &&
                                'post_status_${blogDetailPersonalLogic.data!.getFiledStatus}'
                                        .tr() ==
                                    blogDetailPersonalLogic
                                        .getStatus(TypeBlog.active)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                child: ButtonWidget(
                                  type: EButton.full,
                                  onPressed: writeComment,
                                  child:
                                      Text(LocaleKeys.commentCreateTitle.tr()),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
