import 'package:flutter/material.dart';
import 'package:skin_detective/theme/color.dart';

class PaintAnce extends CustomPainter {
  final BuildContext context;
  final List<List<int>> acneBox;
  final List<int> acneBoxClass;
  final Size imageSize;

  PaintAnce({
    required this.context,
    required this.acneBox,
    required this.imageSize,
    required this.acneBoxClass,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final acneBoxScale = _scalePoints(
      acnesBox: acneBox,
      imageSize: imageSize,
      widgetSize: size,
    );

    try {
      // length of acneBoxClass & acneBox are same
      for (int i = 0; i <= acneBoxScale.length - 1; i++) {
        var rect = Rect.fromPoints(
            acneBoxScale[i].topLeft, acneBoxScale[i].bottomRight);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
              rect,
              Radius.circular(rect.width * 0.15),
            ),
            _acneBoxPaint(acneBoxClass[i]));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Paint _acneBoxPaint(int type) {
    late Color color;
    switch (type) {
      case 1:
        // mụn đỏ/ mụn mủ
        color = AppColors.acnePink;
        break;
      case 2:
        // sẹo lõm/ lồi
        color = AppColors.acneGreen;
        break;
      case 3:
        //mụn đầu đen/ mụn đầu trắng
        color = AppColors.acneBlue;
        break;
      case 4:
        //mụn nang
        color = AppColors.acneRed;
        break;
      default:
        color = AppColors.acneGreen;
        break;
    }
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
  }

  List<AreaAcne> _scalePoints({
    required List<List<int>> acnesBox,
    required Size imageSize,
    required Size widgetSize,
  }) {
    List<AreaAcne> acneBoxNews = [];

    for (var acneBox in acnesBox) {
      Offset topLeft = Offset(acneBox[0].toDouble(), acneBox[1].toDouble());
      Offset bottomRight = Offset(acneBox[2].toDouble(), acneBox[3].toDouble());

      acneBoxNews.add(
        AreaAcne(
          topLeft: scaleOffset(
            origin: imageSize,
            current: widgetSize,
            offsetOrigin: topLeft,
          ),
          bottomRight: scaleOffset(
            origin: imageSize,
            current: widgetSize,
            offsetOrigin: bottomRight,
          ),
        ),
      );
    }
    return acneBoxNews;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Offset scaleOffset({
  required Size origin,
  required Size current,
  required Offset offsetOrigin,
}) {
  double dx = (offsetOrigin.dx / origin.width) * current.width;

  double dy = (offsetOrigin.dy / origin.height) * current.height;

  return Offset(dx, dy);
}

class AreaAcne {
  final Offset topLeft;
  final Offset bottomRight;

  AreaAcne({required this.topLeft, required this.bottomRight});
}
