import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/home/screens/categories/blog/blog_detail/blog_detail_logic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/personal.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/helper/url_helper.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/sliderImage/slider_image.dart';
import '../../../../../../../widgets/comment_widget/comment_widget.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key}) : super(key: key);

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  late BlogDetailLogic blogDetailLogic;
  late PersonalLogic personal;
  late SharedPreferences getLang;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blogDetailLogic = BlogDetailLogic(context: context);
    personal = context.read<PersonalLogic>();
    initLocalStorage();
  }

  int get id => ModalRoute.of(context)!.settings.arguments as int;

  void writeComment() {
    Navigator.pushNamed(context, AppRoutes.createCommentPage).then((value) {
      String comment = '${(value ?? '')}';
      if ('${(value ?? '')}'.isNotEmpty) {
        blogDetailLogic.createComment(comment);
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
      value: blogDetailLogic,
      child: Consumer<BlogDetailLogic>(
        builder: (_, value, child) {
          return Scaffold(
            appBar: AppBarWidget(
              title: LocaleKeys.blogDetailBlogBackText.tr(),
              centerTitle: false,
              textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLightGray.withOpacity(0.5),
                  ),
              action: [
                IconButton(
                    onPressed: () async {
                      blogDetailLogic.save();
                      await blogDetailLogic.saveBlog(id);
                      personal.changeXemThemBlog();
                    },
                    icon: !blogDetailLogic.btnSave
                        ? const Icon(
                            Icons.bookmark_border_outlined,
                            color: AppColors.textLightGray,
                          )
                        : const Icon(
                            Icons.bookmark,
                            color: AppColors.acne2,
                          ))
              ],
            ),
            body: value.data == null
                ? const Center(child: FooterLoading(isLoading: true))
                : SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 24,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogDetailLogic.data == null
                              ? "loading..."
                              : blogDetailLogic.data!.detail.title,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                color: AppColors.textBlueBlack,
                                fontFamily: Assets.googleFonts.montserratBold,
                                letterSpacing: -1,
                              ),
                        ),
                        Text(
                          blogDetailLogic.data == null
                              ? 'loading'
                              : formatDateTime(blogDetailLogic.data!.createdAt),
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: AppColors.textLightGray,
                                  ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SliderImage(
                            lstImage: List.generate(
                                blogDetailLogic.data!.images!.length, (index) {
                          return blogDetailLogic.data!.images![index].url;
                        })),
                        const SizedBox(
                          height: 24,
                        ),
                        blogDetailLogic.data == null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'loading...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.acne4,
                                      ),
                                ),
                              )
                            : Html(
                                onLinkTap: (_, __, ___, ____) async {
                                  await URLLauncher.openWebsite(_.toString());
                                },
                                data:
                                    """${blogDetailLogic.data!.detail.content.replaceAll('<p><br></p><p><br></p>', '')}
                            ${blogDetailLogic.data!.detail.description.replaceAll("<p><br></p>", '')}""",
                                style: {
                                  'p,span,strong': Style().copyWith(
                                      fontSize: FontSize(AppFonts.font_12),
                                      color: AppColors.acne4,
                                      fontWeight: FontWeight.w600,
                                      lineHeight: const LineHeight(1.5)),
                                },
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.blogDetailUserCreateLable
                                    .tr()
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textLightGray,
                                    ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: blogDetailLogic.data != null &&
                                        blogDetailLogic.data!.user.avatar !=
                                            null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          blogDetailLogic.data!.user.avatar
                                              as String,
                                        ),
                                        // foregroundImage: AssetImage(
                                        //     Assets.images.avatarLogout.path),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: AssetImage(
                                            Assets.images.avatarLogout.path),
                                      ),
                                title: Text(
                                  blogDetailLogic.data != null
                                      ? blogDetailLogic.data!.user.name
                                      : 'loading...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.acne4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                subtitle: Text(
                                  blogDetailLogic.data != null
                                      ? blogDetailLogic.data!.user.email
                                      : 'loading...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        color: AppColors.acne4,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
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
                          return CommentWidget(
                            key: Key(value.lstComment[index].id.toString()),
                            avatar: value.lstComment[index].users.avatar != null
                                ? value.lstComment[index].users.avatar as String
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
                            status: value.lstComment[index].status,
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: ButtonWidget(
                              type: EButton.full,
                              onPressed: writeComment,
                              child: const Text(LocaleKeys.commentCreateTitle)
                                  .tr()),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
