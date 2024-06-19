import 'package:flutter/material.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

// ignore: must_be_immutable
class PostNewWidget extends StatelessWidget {
  //final Post post;
  final ConsMeticData data;
  final String? type;
  final void Function()? onTap;
  final ScrollController? scrollController;
  final int index;
  final int count;
  final double? cardWidth;
  final String? subTitle;

  const PostNewWidget({
    Key? key,
    //required this.post,
    required this.data,
    required this.count,
    this.type,
    this.scrollController,
    this.onTap,
    this.cardWidth = 150,
    required this.index,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shadowColor: AppColors.textBlue.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: AppColors.white,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: cardWidth,
              padding: const EdgeInsets.all(9),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                clipBehavior: Clip.hardEdge,
                child: ImageCustom(
                  urlImage: data.thumbnail,
                  height: Helper.percentHeight(pixel: 90, context: context),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              width: cardWidth,
              child: Text(
                data.detail.title,
                softWrap: true,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: AppColors.textBlueBlack,
                      fontWeight: FontWeight.w600,
                      height: 1.33333,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 6, left: 9),
              child: Text(
                subTitle ?? data.detail.getDateCreated(),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontSize: AppFonts.font10,
                      color: AppColors.textLightGray,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
