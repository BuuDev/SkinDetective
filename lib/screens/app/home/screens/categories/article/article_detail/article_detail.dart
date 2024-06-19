import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/home/screens/categories/article/article_detail/article_detail_logic.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/sliderImage/slider_image.dart';
import '../../../../../../../widgets/comment_widget/comment_widget.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({Key? key}) : super(key: key);

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  late ArticleDetailLogic articleDetailLogic;
  late SharedPreferences getLang;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    articleDetailLogic = ArticleDetailLogic(context: context);
    initLocalStorage();
  }

  @override
  void dispose() {
    articleDetailLogic.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  int get id => ModalRoute.of(context)!.settings.arguments as int;
  void writeComment() {
    Navigator.pushNamed(context, AppRoutes.createCommentPage).then((value) {
      String comment = '${(value ?? '')}';
      if ('${(value ?? '')}'.isNotEmpty) {
        articleDetailLogic.createComment(comment);
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
      value: articleDetailLogic,
      child: Consumer<ArticleDetailLogic>(
        builder: (_, value, child) {
          return Scaffold(
            appBar: AppBarWidget(
              title: LocaleKeys.blogDetailPostBackText.tr(),
              centerTitle: false,
              textStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLightGray.withOpacity(0.5),
                  ),
              action: [
                IconButton(
                    onPressed: () {
                      articleDetailLogic.save();
                      articleDetailLogic.savePost(id);
                    },
                    icon: !articleDetailLogic.btnSave
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
                          articleDetailLogic.data == null
                              ? "loading..."
                              : articleDetailLogic.data!.detail.title,
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
                          articleDetailLogic.data == null
                              ? 'loading'
                              : formatDateTime(
                                  articleDetailLogic.data!.createdAt),
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
                                articleDetailLogic.data!.images!.length,
                                (index) {
                          return articleDetailLogic.data!.images![index].url;
                        })),
                        const SizedBox(
                          height: 24,
                        ),
                        articleDetailLogic.data == null
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
                            : Text(
                                articleDetailLogic.data!.detail.content,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: AppColors.acne4,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
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
                              articleDetailLogic.data != null
                                  ? ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      leading: articleDetailLogic.data !=
                                                  null &&
                                              articleDetailLogic
                                                      .data!.user.avatar !=
                                                  null
                                          ? CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  articleDetailLogic
                                                      .data!.user.avatar
                                                      .toString()))
                                          : CircleAvatar(
                                              backgroundImage: AssetImage(Assets
                                                  .images.avatarLogout.path)),
                                      title: Text(
                                        articleDetailLogic.data!.user.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: AppColors.acne4,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      subtitle: Text(
                                        articleDetailLogic.data!.user.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: AppColors.acne4,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Loading...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: AppColors.acne4,
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
