part of './categories.dart';

class TabArtPainter extends CustomPainter {
  final _TabDirection direction;

  TabArtPainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var paint = Paint();

    switch (direction) {
      case _TabDirection.left:
        drawRight(path, size);
        break;
      case _TabDirection.right:
        drawLeft(path, size);
        break;
      case _TabDirection.center:
        drawCenter(path, size);
        break;
      default:
    }

    path.close();
    paint.color = AppColors.backgroundColor;
    canvas.drawPath(path, paint);
  }

  void drawRight(Path path, Size size) {
    double widthBezier = 60;
    double positionBezier = size.width - widthBezier;

    path.moveTo(0, 0);
    path.lineTo(positionBezier, 0);
    path.quadraticBezierTo(
      positionBezier + widthBezier * 0.5 - 5,
      5,
      positionBezier + widthBezier * 0.5,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      positionBezier + widthBezier * 0.5 + 5, //increase
      size.height - 4, // decrease
      size.width,
      size.height,
    );

    path.lineTo(0, size.height);
  }

  void drawCenter(Path path, Size size) {
    double widthBezier = 50;
    double positionBezier = size.width - widthBezier;

    path.moveTo(0, size.height);

    path.quadraticBezierTo(
      widthBezier * 0.5 - 5,
      size.height - 4,
      widthBezier * 0.5,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      widthBezier * 0.5 + 5,
      5,
      widthBezier,
      0,
    );

    path.lineTo(positionBezier, 0);
    path.quadraticBezierTo(
      positionBezier + widthBezier * 0.5 - 5,
      5,
      positionBezier + widthBezier * 0.5,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      positionBezier + widthBezier * 0.5 + 5, //increase
      size.height - 4, // decrease
      size.width,
      size.height,
    );

    // path.lineTo(0, size.height);
  }

  void drawLeft(Path path, Size size) {
    double widthBezier = 60;

    path.moveTo(0, size.height);

    path.quadraticBezierTo(
      widthBezier * 0.5 - 5,
      size.height - 4,
      widthBezier * 0.5,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      widthBezier * 0.5 + 5,
      5,
      widthBezier,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);
  }

  @override
  bool shouldRepaint(TabArtPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TabArtPainter oldDelegate) => false;
}

enum _TabDirection { left, right, center }
