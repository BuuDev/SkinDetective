import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/tut_camera/tut_camera_provider.dart';
import 'package:skin_detective/screens/app/face_stream/screens/on_face_screen.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/page_view_widget/page_view_widget.dart';

class SkinScanGuide extends StatefulWidget {
  const SkinScanGuide({Key? key}) : super(key: key);

  @override
  _FaceTutState createState() => _FaceTutState();
}

class _FaceTutState extends State<SkinScanGuide> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    OnFaceScreen(
      backgroundScreen: Assets.images.guide1.path,
      imageCaption: Assets.icons.faceLight,
      caption: LocaleKeys.tutorial1.tr(gender: 'title'),
      labelButton: LocaleKeys.generalNext.tr(),
      description: LocaleKeys.tutorial1.tr(gender: 'text'),
      nextPage: (context) {
        context.read<TutCameraProvider>().nextPage();
      },
    ),
    OnFaceScreen(
      backgroundScreen: Assets.images.guide2.path,
      imageCaption: Assets.icons.faceDistance,
      caption: LocaleKeys.tutorial2.tr(gender: 'title'),
      labelButton: LocaleKeys.generalNext.tr(),
      description: LocaleKeys.tutorial2.tr(gender: 'text'),
      preBack: true,
      next: true,
      prePage: (context) {
        context.read<TutCameraProvider>().prePage();
      },
      nextPage: (context) {
        context.read<TutCameraProvider>().nextPage();
      },
    ),
    OnFaceScreen(
        backgroundScreen: Assets.images.guide2.path,
        imageCaption: Assets.icons.faceLens,
        caption: LocaleKeys.tutorial3.tr(gender: 'title'),
        labelButton: LocaleKeys.tutorial3.tr(gender: 'start_camera_button'),
        description: LocaleKeys.tutorial3.tr(gender: 'text'),
        preBack: true,
        prePage: (context) {
          context.read<TutCameraProvider>().prePage();
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageViewWidget(
            pages: _pages,
            direction: EDot.vertical,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            right: 10,
            child: ButtonWidget(
              primary: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                child: SvgPicture.asset(Assets.icons.closeIcon),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void notifyListeners() {}
}
