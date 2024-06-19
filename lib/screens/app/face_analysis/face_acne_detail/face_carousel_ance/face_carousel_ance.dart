import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
import 'package:skin_detective/screens/app/face_analysis/face_dialog/face_dialog.dart';
import 'package:skin_detective/widgets/flip_widget/flip_widget.dart';
import 'package:skin_detective/widgets/page_view_custom_widget/page_view_widget.dart';
import 'package:skin_detective/widgets/polyline_acne_image/polyline_acne_image.dart';

part 'face_carousel_ance.logic.dart';

class FaceCarouselAnce extends StatefulWidget {
  final List<AnalyzeDetail> dataAnce;

  const FaceCarouselAnce(
      {Key? key, required this.dataAnce, required this.onChangePage})
      : super(key: key);
  final void Function(int index)? onChangePage;

  @override
  _FaceCarouselAnceState createState() => _FaceCarouselAnceState();
}

class _FaceCarouselAnceState extends State<FaceCarouselAnce> {
  late FaceCarouselAnceLogic _faceCarouselAnceLogic;
  @override
  void initState() {
    super.initState();
    _faceCarouselAnceLogic = FaceCarouselAnceLogic(context: context);
  }

  CarouselOptions getOptionCarousel() {
    return CarouselOptions(
      aspectRatio: 2.0,
      enlargeCenterPage: false,
      scrollDirection: Axis.horizontal,
      autoPlay: true,
      enlargeStrategy: CenterPageEnlargeStrategy.scale,
      viewportFraction: 0.9,
      height: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = widget.dataAnce.map((e) {
      return Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: FlipWidget(
            child: PolylineAcneImage(
              faceDetail: e,
            ),
          ),
        ),
      );
    }).toList();

    return SizedBox(
      width: double.infinity,
      height: 350,
      child: PageViewCustomWidget(
        pages: _pages,
        direction: EDot.horizontal,
        bottom: 10,
        onChangePage: (indexPage) {
          widget.onChangePage?.call(indexPage);
        },
        onPress: (index) {
          _faceCarouselAnceLogic.showDialogFace(widget.dataAnce[index]);
        },
      ),
    );
  }
}
