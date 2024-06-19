import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
import 'package:skin_detective/screens/app/face_analysis/face_acne_detail/paint_ance/paint_ance.dart';

class PolylineAcneImage extends StatefulWidget {
  final AnalyzeDetail faceDetail;

  const PolylineAcneImage({
    Key? key,
    required this.faceDetail,
  }) : super(key: key);

  @override
  State<PolylineAcneImage> createState() => _PolylineAcneImageState();
}

class _PolylineAcneImageState extends State<PolylineAcneImage> {
  late Completer<ui.Image> completer;

  @override
  void initState() {
    super.initState();
    initImage();
  }

  void initImage() {
    Image image =
        Image.network(widget.faceDetail.dataAI.url, fit: BoxFit.cover);
    completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: completer.future,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.hasData) {
          return RepaintBoundary(
            child: CustomPaint(
              foregroundPainter: PaintAnce(
                context: context,
                acneBox: widget.faceDetail.dataAI.resultAi.acneBox,
                acneBoxClass: widget.faceDetail.dataAI.resultAi.acneBoxClass,
                imageSize: Size(
                  snapshot.data!.width.toDouble(),
                  snapshot.data!.height.toDouble(),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.faceDetail.dataAI.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Stack(
                  children: const [
                    Positioned(
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                          width: 10,
                          height: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
