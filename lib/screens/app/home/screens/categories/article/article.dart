import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/posts/posts.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/home/screens/categories/article/article_logic.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/new_post/new_post.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/helper/helper.dart';

import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

import '../../../../../../constants/type_globals.dart';
import '../../../../../../theme/color.dart';
import '../../../../../../widgets/button_widget/button_widget.dart';

class Article extends StatefulWidget {
  const Article({Key? key}) : super(key: key);

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> with AutomaticKeepAliveClientMixin {
  late ArticleLogic articleLogic;

  @override
  void initState() {
    super.initState();
    articleLogic = ArticleLogic(context: context);

    articleLogic = context.read<ArticleLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      articleLogic.refreshPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: articleLogic,
      child: Consumer<ArticleLogic>(
        builder: (_, value, __) {
          return RefreshIndicator(
            onRefresh: () async => articleLogic.refreshPost(),
            backgroundColor: AppColors.white,
            color: AppColors.textBlack,
            child: articleLogic.post.data.isEmpty
                ? Selector<ArticleLogic, bool>(
                    selector: (_, state) => value.checkEmpty,
                    builder: (context, value, child) {
                      if (!value) {
                        return const Center(
                          child: FooterLoading(isLoading: true),
                        );
                      }
                      return ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(top: 0, left: 45),
                                    child: SvgPicture.asset(
                                      Assets.icons.shareIcon,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 25, right: 25),
                                    child: SvgPicture.asset(
                                      Assets.icons.shareIcon2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Text(
                                LocaleKeys.categoriesMyPostNoPostsYet.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontFamily:
                                          Assets.googleFonts.montserratBlack,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(38, 8, 38, 0),
                                child: Text(
                                  LocaleKeys.myPostListNull,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        height: 1.5,
                                        fontFamily:
                                            Assets.googleFonts.montserratMedium,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textBlack,
                                      ),
                                ).tr(gender: 'content'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 40, bottom: 0, left: 50, right: 50),
                                child: ButtonWidget(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NewPost()),
                                    );
                                  },
                                  type: EButton.full,
                                  child: Text(
                                      LocaleKeys.myPostListNullCreatePostButton
                                          .tr(),
                                      style:
                                          Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBlack,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                : Selector<ArticleLogic, Pagination<Posts>>(
                    builder: ((context, value, child) {
                      return Container(
                        margin: const EdgeInsets.all(24.0),
                        decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Divider(
                                  height: 1, color: AppColors.lightGray),
                            );
                          },
                          itemCount: value.data.length,
                          itemBuilder: ((context, index) {
                            if (index == value.data.length) {
                              return FooterLoading(isLoading: value.isLoading);
                            }
                            return statusItem(context, value.data[index]);
                          }),
                        ),
                      );
                    }),
                    selector: (_, state) => state.post),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

Widget statusItem(BuildContext context, Posts item) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, AppRoutes.articleDetail, arguments: item.id);
    },
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 0, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: ImageCustom(
                  urlImage: item.thumbnail,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                  placeholder: Assets.icons.productPlaceholder,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Helper.percentHeight(pixel: 60, context: context),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          item.detail.title,
                          maxLines: 2,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    height: 1.5,
                                    fontFamily:
                                        Assets.googleFonts.montserratSemiBold,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textBlueBlack,
                                  ),
                        ),
                      ),
                    ),
                    Text(
                      item.user.name,
                      style: Theme.of(context).textTheme.overline!.copyWith(
                            fontFamily: Assets.googleFonts.montserratSemiBold,
                            fontWeight: FontWeight.w600,
                            color: AppColors.silvergrey,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
