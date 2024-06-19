import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/spa/spa.dart';
import 'package:skin_detective/screens/app/bottom_navigation/bottom_navigation.dart';
import 'package:skin_detective/screens/app/home/screens/spa/spa.logic.dart';

import 'package:skin_detective/screens/app/home/screens/spa_detail/spa_detail.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

class SpaPage extends StatefulWidget {
  const SpaPage({Key? key}) : super(key: key);

  @override
  _SpaPageState createState() => _SpaPageState();
}

class _SpaPageState extends State<SpaPage> with AutomaticKeepAliveClientMixin {
  late SpaLogic spaLogic;

  @override
  void initState() {
    super.initState();
    spaLogic = Provider.of<SpaLogic>(context, listen: false);
  }

  @override
  void dispose() {
    spaLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Selector<SpaLogic, List<Spa>>(
        selector: (_, __) => __.spas,
        shouldRebuild: (pre, next) => true,
        builder: (_, lists, __) {
          return RefreshIndicator(
            onRefresh: () async => spaLogic.onReFresh(),
            backgroundColor: AppColors.white,
            color: AppColors.textBlack,
            child: Container(
              margin: const EdgeInsets.all(24.0)
                  .copyWith(bottom: BottomNavigationState.maxHeight + 24),
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Divider(height: 1, color: AppColors.lightGray),
                  );
                },
                itemCount: lists.length,
                itemBuilder: ((context, index) => SpaItem(spa: lists[index])),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class SpaItem extends StatelessWidget {
  const SpaItem({Key? key, required this.spa}) : super(key: key);
  final Spa spa;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SpaDetailPage(
                  spa: spa,
                )));
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: ImageCustom(
                urlImage: spa.image,
                placeHolderType: PlaceHolderType.imageAsset,
                placeholder: Assets.images.avatarNull.path,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spa.detail!.name.toString(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontFamily: Assets.googleFonts.montserratBold,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlueBlack,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spa.detail!.address.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: AppFonts.font_11,
                          color: AppColors.textBlueBlack,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.spaServiceFee,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontFamily: Assets.googleFonts.montserratSemiBold,
                          fontSize: AppFonts.font10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlue,
                        ),
                  ).tr(args: [spa.serviceFee]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
