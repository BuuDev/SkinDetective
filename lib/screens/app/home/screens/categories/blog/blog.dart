import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/constant.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/cosmetic/cosmetic.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

import '../../../../../../theme/color.dart';
part 'blog_logic.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> with AutomaticKeepAliveClientMixin {
  late BlogLogic blog;

  @override
  void initState() {
    super.initState();
    blog = context.read<BlogLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      blog.refreshBlog();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: blog,
      child: Consumer<BlogLogic>(
        builder: (context, value, child) {
          return Selector<BlogLogic, Pagination<ConsMeticData>>(
            selector: (_, state) => state.blogData,
            builder: (_, value, __) {
              return RefreshIndicator(
                backgroundColor: AppColors.white,
                color: AppColors.textBlack,
                onRefresh: () async {
                  blog.refreshBlog();
                },
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    controller: blog.controller,
                    itemCount: value.data.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == value.data.length) {
                        return FooterLoading(isLoading: value.isLoading);
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 22, right: 24),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.blogDetail,
                                    arguments: value.data[index].id);
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      child: ImageCustom(
                                        urlImage: value.data[index].thumbnail,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          SizedBox(
                                            height: Helper.percentHeight(
                                                pixel: 60, context: context),
                                            child: Text(
                                              value.data[index].detail.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                    height: 1.3333,
                                                    fontFamily: Assets
                                                        .googleFonts
                                                        .montserratSemiBold,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textBlack,
                                                  ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            value.data[index].detail
                                                .getDateCreated(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontSize: AppFonts.font_11,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textTertiary,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                            color: AppColors.textLightGrayBG.withOpacity(0.5),
                          ),
                        ],
                      );
                    }),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
