import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';

class OnBoardScreen extends StatelessWidget {
  final String title;
  final String? image;
  final String description;
  final String content;

  const OnBoardScreen({
    Key? key,
    required this.title,
    required this.image,
    required this.description,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontFamily: Assets.googleFonts.montserratBold,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Image.network(
                  image ?? '',
                  height: 130,
                  errorBuilder: (_, ob, __) {
                    return Image.network(
                      'http://sd-api.pixelcent.com/analysis-images/71/71_31032022100415.jpg',
                      height: 130,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: 14,
                        color: AppColors.textBlack,
                        fontFamily: Assets.googleFonts.montserratBold,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(bottom: 10),
                  child: SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Html(
                          data: content,
                          style: {
                            "body": Style(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              fontSize: FontSize(AppFonts.font_12),
                              color: AppColors.textBlueBlack,
                              fontFamily: Assets.googleFonts.montserratMedium,
                            ),
                            "p": Style(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              fontSize: FontSize(AppFonts.font_12),
                              fontFamily: Assets.googleFonts.montserratMedium,
                              color: AppColors.textBlueBlack,
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
