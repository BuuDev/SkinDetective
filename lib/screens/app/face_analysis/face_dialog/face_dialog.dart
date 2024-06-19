import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/button_widget/button_widget.dart';
import 'package:skin_detective/widgets/flip_widget/flip_widget.dart';
import 'package:skin_detective/widgets/polyline_acne_image/polyline_acne_image.dart';

class FaceDialog extends StatefulWidget {
  final AnalyzeDetail faceDetail;
  const FaceDialog({Key? key, required this.faceDetail}) : super(key: key);

  @override
  _FaceDialogState createState() => _FaceDialogState();
}

class _FaceDialogState extends State<FaceDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: insetsTop(context)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonWidget(
                primary: AppColors.transparent,
                onPressed: Navigator.of(context).pop,
                child: SvgPicture.asset(Assets.icons.closeIcon),
              )
            ],
          ),
          Expanded(
            child: InteractiveViewer(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: FlipWidget(
                    child: PolylineAcneImage(
                      faceDetail: widget.faceDetail,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      decoration: const BoxDecoration(color: AppColors.textGrayBG),
    );
  }
}
