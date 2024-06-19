import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
import 'package:skin_detective/screens/app/face_analysis/face_acne_detail/paint_ance/paint_ance.dart';
part 'face_repaint_acne.logic.dart';

class FaceRepaintAcne extends StatefulWidget {
  final AnalyzeDetail faceDetail;
  const FaceRepaintAcne({Key? key, required this.faceDetail}) : super(key: key);

  @override
  _FaceRepaintAcneState createState() => _FaceRepaintAcneState();
}

class _FaceRepaintAcneState extends State<FaceRepaintAcne> {
  late FaceRepaintAcneLogic _faceRepaintAcneLogic;
  _FaceRepaintAcneState();
  @override
  void initState() {
    super.initState();
    _faceRepaintAcneLogic = FaceRepaintAcneLogic(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: _faceRepaintAcneLogic.completer.future,
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.hasData) {
                return RepaintBoundary(
                  key: _faceRepaintAcneLogic._globalKey,
                  child: CustomPaint(
                    foregroundPainter: PaintAnce(
                      context: context,
                      acneBox: widget.faceDetail.dataAI.resultAi.acneBox,
                      acneBoxClass:
                          widget.faceDetail.dataAI.resultAi.acneBoxClass,
                      imageSize: Size(
                        snapshot.data!.height.toDouble(),
                        snapshot.data!.width.toDouble(),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      // clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width - 10,
                        height: MediaQuery.of(context).size.height / 2 + 50,
                        fit: BoxFit.cover,
                        imageUrl: widget.faceDetail.dataAI.url,
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              } else {
                return const Text('Loading...');
              }
            },
          ),
        ],
      ),
    );
  }
}
