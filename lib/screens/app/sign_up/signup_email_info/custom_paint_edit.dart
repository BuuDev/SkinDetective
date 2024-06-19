part of './sign_up_email.dart';

class EditPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(0.4);

    final elip = Path();
    elip.moveTo(size.width * 0.8, size.height * 0.62);
    elip.arcToPoint(
      Offset(size.width * 0.2, size.height * 0.62),
      radius: const Radius.circular(60),
    );
    elip.arcToPoint(
      Offset(size.width * 0.8, size.height * 0.6),
      radius: const Radius.circular(45),
    );
    canvas.drawPath(elip, paint);
  }

  @override
  bool shouldRepaint(EditPainter oldDelegate) => false;
}
