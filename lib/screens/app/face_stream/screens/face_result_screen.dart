import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/providers/acne_analyze/acne_analyze.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/face_analysis/face_analysis.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/image_item_widget/image_item_widget.dart';
part 'face_result_screen.logic.dart';

class FaceResultScreen extends StatefulWidget {
  const FaceResultScreen({Key? key}) : super(key: key);

  @override
  _FaceResultScreenState createState() => _FaceResultScreenState();
}

class _FaceResultScreenState extends State<FaceResultScreen> {
  late FaceResultLogic _faceResultLogic;

  @override
  void initState() {
    super.initState();
    _faceResultLogic = FaceResultLogic(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 10),
                    child: const Text(
                      LocaleKeys.checkPicture,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      LocaleKeys.contentTest,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 12,
                        height: 1.7,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.normal,
                      ),
                    ).tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AcneAnalyzeVM, Map<ETypeFace, XFile>>(
                        selector: (_, state) => state.images,
                        builder: (_, images, __) {
                          var _images = images.values.toList();
                          return Row(
                            children: [
                              ImageItemWidget(path: _images[1].path),
                              const SizedBox(width: 10),
                              ImageItemWidget(path: _images[0].path),
                              const SizedBox(width: 10),
                              ImageItemWidget(path: _images[2].path),
                            ],
                          );
                        }),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox.shrink(),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ButtonWidget(
                onPressed: () =>
                    context.read<AcneAnalyzeVM>().startAnalyze(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    LocaleKeys.buttonStartAnalyze,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption!.merge(
                          const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ).tr(),
                ),
                type: EButton.full,
                primary: AppColors.textBlueBG,
                elevation: 0,
                icon: Assets.icons.arrowRight,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ButtonWidget(
                onPressed: _faceResultLogic.onRestartFace,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    LocaleKeys.cancelAnalyzeButton,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption!.merge(
                          const TextStyle(
                            fontSize: 14,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ).tr(),
                ),
                type: EButton.normal,
                primary: AppColors.textLightBlue,
                elevation: 0,
                icon: Assets.icons.undo,
              ),
            )
          ],
        ),
        decoration: const BoxDecoration(color: AppColors.textLightGrayBG),
      ),
    );
  }
}
