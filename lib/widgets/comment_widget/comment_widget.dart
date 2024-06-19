import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/theme/format_datetime.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../theme/color.dart';
import '../custom_dialog/custom_dialog.dart';

class CommentWidget extends StatelessWidget {
  final String? avatar;
  final String name;
  final String date;
  final String content;
  final int? idComment;
  final int? idPost;
  final int? userId;
  final void Function()? deleteComment;
  final String? status;
  final String? lang;

  const CommentWidget({
    Key? key,
    required this.avatar,
    required this.content,
    required this.name,
    required this.date,
    this.idComment,
    this.idPost,
    this.userId,
    this.deleteComment,
    this.status,
    this.lang,
  }) : super(key: key);

  confirmDeleteComment(BuildContext context) {
    deleteComment!.call();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: avatar != null
                ? CircleAvatar(backgroundImage: NetworkImage(avatar.toString()))
                : CircleAvatar(
                    backgroundImage:
                        AssetImage(Assets.images.avatarLogout.path),
                  ),
            title: Text(
              name,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              date,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: AppColors.textLightGray,
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: content,
                style: {
                  'p': Style().copyWith(
                      fontSize: FontSize(AppFonts.font_11),
                      color: AppColors.acne4,
                      fontWeight: FontWeight.w500,
                      lineHeight: const LineHeight(1.5)),
                },
              ),
              if (GetIt.instance<UserViewModel>().data.id == userId)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              barrierColor:
                                  AppColors.textLightGrayBG.withOpacity(0.5),
                              context: context,
                              builder: (_) {
                                return CustomDialog(
                                  icon: SvgPicture.asset(
                                    Assets.icons.delete,
                                    color: AppColors.red,
                                    width: 40,
                                    height: 40,
                                  ),
                                  height: 170,
                                  title: LocaleKeys.commentListDelete.tr(),
                                  subtitle:
                                      LocaleKeys.commentDeletePopupContent.tr(),
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
                                                          rootNavigator: true)
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
                                                            FontWeight.bold,
                                                      ),
                                                )),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                confirmDeleteComment(context);
                                              },
                                              child: Text(
                                                LocaleKeys.accept.tr(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1!
                                                    .copyWith(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) {
                                                  return AppColors.textRed;
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
                        },
                        child: Text(
                          LocaleKeys.commentListDelete.tr(),
                          style: Theme.of(context).textTheme.overline!.copyWith(
                              color: AppColors.textBlack,
                              fontFamily: "Montserrat-SemiBold"),
                        ),
                      ),
                      status != null &&
                              "post_status_${status.toString()}".tr() ==
                                  LocaleKeys.postStatusWaiting.tr()
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                ('post_status_${status.toString()}').tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(
                                        color: AppColors.textLightGray,
                                        fontFamily: "Montserrat-SemiBold"),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
