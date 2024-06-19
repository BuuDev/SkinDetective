import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/models/comment/comment.dart';
import 'package:skin_detective/models/comment/comment_data.dart';
import 'package:skin_detective/models/save_cosmetic_response/save_cosmetic_response.dart';
import 'package:skin_detective/screens/app/home/screens/categories/personal/personal.dart';
import 'package:skin_detective/services/apis/comment/comment.dart';
import 'package:skin_detective/services/apis/cosmetic/cosmetic.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/helper/url_helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import 'package:skin_detective/widgets/app_bar_widget/app_bar_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/sliderImage/slider_image.dart';

import '../../../../../../../gen/assets.gen.dart';
import '../../../../../../../models/cosmetic_detail/cosmetic_detail_data.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../widgets/button_widget/button_widget.dart';
import '../../../../../../../widgets/comment_widget/comment_widget.dart';
part 'cosmetic_detail_logic.dart';

class CosmeticDetail extends StatefulWidget {
  const CosmeticDetail({Key? key}) : super(key: key);

  @override
  State<CosmeticDetail> createState() => _CosmeticDetailState();
}

class _CosmeticDetailState extends State<CosmeticDetail> {
  late CosmeticDetailLogic cosmeticDetailLogic;
  late PersonalLogic personal;
  late SharedPreferences getLang;
  @override
  void initState() {
    super.initState();
    cosmeticDetailLogic = CosmeticDetailLogic(context: context);
    personal = context.read<PersonalLogic>();
    initLocalStorage();
  }

  int get id => ModalRoute.of(context)!.settings.arguments as int;

  void writeComment() async {
    Navigator.pushNamed(
      context,
      AppRoutes.createCommentPage,
    ).then((value) {
      String comment = '${(value ?? '')}';
      if ('${(value ?? '')}'.isNotEmpty) {
        cosmeticDetailLogic.createComment(comment);
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
      value: cosmeticDetailLogic,
      child: Consumer<CosmeticDetailLogic>(
        builder: (_, state, child) {
          return Scaffold(
            appBar: AppBarWidget(
              title: LocaleKeys.gategoriesNavCosmetics.tr(),
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
                    onPressed: () async {
                      cosmeticDetailLogic.save();
                      await state.saveCosmetic(id);
                      personal.changeXemThemCosmetic();
                    },
                    icon: !state.btnSave
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
            body: state.data == null
                ? const Center(child: FooterLoading(isLoading: true))
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                      left: 20,
                      right: 20,
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            state.data != null
                                ? state.data!.detail.title
                                : 'loading...',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                  color: AppColors.textBlack,
                                  fontFamily: Assets.googleFonts.montserratBold,
                                  letterSpacing: -1,
                                ),
                          ),
                          subtitle: state.data != null
                              ? state.data!.detail.website != null
                                  ? Html(
                                      data: state.data!.detail.website,
                                      style: {
                                        'a': Style().copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                              Assets.googleFonts.montserratBold,
                                          fontSize: const FontSize(14),
                                        ),
                                      },
                                      onLinkTap: (_, __, ___, ____) async {
                                        await URLLauncher.openWebsite(
                                            _.toString());
                                      },
                                    )
                                  : Text(
                                      state.data!.detail.brand,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: Assets
                                                .googleFonts.montserratBold,
                                            fontSize: 14,
                                            color: AppColors.textLightGray,
                                          ),
                                    )
                              : const SizedBox(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SliderImage(
                            lstImage: List.generate(
                                cosmeticDetailLogic.data!.images!.length,
                                (index) {
                          return cosmeticDetailLogic.data!.images![index].url;
                        })),
                        const SizedBox(
                          height: 24,
                        ),
                        if (state.data != null)
                          Html(
                            data:
                                '''${state.data!.detail.content.replaceAll('<p>&nbsp;</p><p><br></p>', '').replaceAll('<p><br></p><p><br></p><p><br></p>', '').replaceAll('<p><br></p>', '')}"''',
                            style: {
                              'p,span,strong,ul,li': Style().copyWith(
                                fontSize: FontSize(AppFonts.font_11),
                                color: AppColors.acne4,
                                fontWeight: FontWeight.w600,
                                lineHeight: const LineHeight(1.5),
                              ),
                            },
                          ),
                        Text(
                          LocaleKeys.commentListTitle
                              .tr(args: [(state.lstComment.length.toString())]),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: AppColors.textBlueBlack,
                                  ),
                        ),
                        ...List.generate(state.lstComment.length, (index) {
                          return CommentWidget(
                            key: Key(state.lstComment[index].id.toString()),
                            avatar: state.lstComment[index].users.avatar != null
                                ? state.lstComment[index].users.avatar as String
                                : null,
                            content:
                                """<p>${state.lstComment[index].content}</p>""",
                            name: state.lstComment[index].users.name,
                            date: formatDateTime(
                                state.lstComment[index].createdAt),
                            idComment: state.lstComment[index].id,
                            idPost: id,
                            deleteComment: () {
                              state.deletedComment(
                                  state.lstComment[index].id, index);
                            },
                            userId: state.lstComment[index].userId,
                            status: state.lstComment[index].status,
                            lang: getLang.getString('lang'),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: ButtonWidget(
                              type: EButton.full,
                              onPressed: writeComment,
                              child: const Text(LocaleKeys.commentCreateTitle)
                                  .tr()),
                        )
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
