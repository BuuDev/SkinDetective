import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/constants/constant.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/cosmetic/cosmetic.dart';
import 'package:skin_detective/widgets/footer_loading/footer_loading.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';

part 'cosmetic_logic.dart';

class Cosmetic extends StatefulWidget {
  const Cosmetic({Key? key}) : super(key: key);

  @override
  State<Cosmetic> createState() => _CosmeticState();
}

class _CosmeticState extends State<Cosmetic>
    with AutomaticKeepAliveClientMixin {
  late CosMeticLogic cos;

  @override
  void initState() {
    super.initState();
    cos = context.read<CosMeticLogic>();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      cos.refreshCosmetic();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: cos,
      child: Consumer<CosMeticLogic>(
        builder: (context, value, child) {
          return Selector<CosMeticLogic, Pagination<ConsMeticData>>(
            selector: (_, state) => state.cosmeticData,
            builder: (_, value, __) {
              return RefreshIndicator(
                onRefresh: () async {
                  cos.refreshCosmetic();
                },
                backgroundColor: AppColors.white,
                color: AppColors.textBlack,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  controller: cos.controller,
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
                                  context, AppRoutes.cosmeticDetail,
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
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            value.data[index].detail.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: Assets.googleFonts
                                                      .montserratBold,
                                                  color: AppColors.textBlack,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            value.data[index].detail.brand!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontFamily: Assets.googleFonts
                                                      .montserratSemiBold,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textBlack,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            value.data[index].detail
                                                .description!,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontSize: AppFonts.font_11,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.2222,
                                                  color: AppColors.acne4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                          ),
                                        ],
                                      ),
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
                  },
                ),
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
