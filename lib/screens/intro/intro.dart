import 'package:flutter/material.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/screens/intro/screens/first_screen.dart';
import 'package:skin_detective/screens/intro/screens/on_board_screen.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/double_button_widget/double_button_widget.dart';
import 'package:skin_detective/widgets/page_view_widget/page_view_widget.dart';

class IntroApp extends StatefulWidget {
  const IntroApp({Key? key}) : super(key: key);

  @override
  _IntroAppState createState() => _IntroAppState();
}

class _IntroAppState extends State<IntroApp> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const FirstScreen(),
    OnBoardScreen(
      backgroundScreen: Assets.images.onBoardingFirstBg.path,
      imageScreen: Assets.images.dashboard1.path,
      caption: LocaleKeys.onBoardSeconds,
    ),
    OnBoardScreen(
      backgroundScreen: Assets.images.onBoardingTwoBg.path,
      imageScreen: Assets.images.dashboard2.path,
      caption: LocaleKeys.onBoardThird,
    ),
    OnBoardScreen(
      backgroundScreen: Assets.images.onBoardingThreeBg.path,
      imageScreen: Assets.images.dashboard3.path,
      caption: LocaleKeys.onBoardFourth,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageViewWidget(pages: _pages),
          Positioned(
            right: 0,
            left: 0,
            bottom: insetsBottom(context) + 10,
            child: const DoubleButtonWidget(
              titleLeft: LocaleKeys.generalSignupButton,
              titleRight: LocaleKeys.generalLoginButton,
            ),
          ),
        ],
      ),
    );
  }
}
