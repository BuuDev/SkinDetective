import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:skin_detective/theme/color.dart';

class AppTextTheme {
  final ThemeMode mode;
  AppTextTheme({this.mode = ThemeMode.light});

  TextTheme buildTextTheme() {
    return TextTheme(
      bodyText1: _bodyText1,
      bodyText2: _bodyText2,
      subtitle1: _subTitle1,
      subtitle2: _subTitle2,
      headline6: _headerLine6,
      headline5: _headerLine5,
      caption: _caption,
      overline: _overline,
      headline4: _headerLine4,
    );
  }

  static double scaleFontSize(double size) {
    return size + 1;
  }

  TextStyle get _overline {
    return _colorTextBase.copyWith(
      fontSize: scaleFontSize(10),
    );
  }

  TextStyle get _headerLine6 {
    return _colorTextBase.copyWith(
      fontSize: scaleFontSize(22),
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get _headerLine5 =>
      TextStyle(fontSize: scaleFontSize(34), fontWeight: FontWeight.bold)
          .merge(_colorTextBase);

  TextStyle get _headerLine4 {
    return _colorTextBase.copyWith(
      fontSize: scaleFontSize(22),
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get _caption =>
      TextStyle(fontSize: scaleFontSize(20), fontWeight: FontWeight.bold)
          .merge(_colorTextBase);

  TextStyle get _bodyText1 => TextStyle(
        fontSize: scaleFontSize(16),
      ).merge(_colorTextBase);

  TextStyle get _bodyText2 => TextStyle(
        fontSize: scaleFontSize(14),
      ).merge(_colorTextBase);

  TextStyle get _subTitle1 => TextStyle(
        fontSize: scaleFontSize(12),
      ).merge(_colorTextBase);

  TextStyle get _subTitle2 {
    return TextStyle(
      fontSize: scaleFontSize(18),
      fontWeight: FontWeight.bold,
    ).merge(_colorTextBase);
  }

  TextStyle get _colorTextBase {
    if (mode == ThemeMode.dark) {
      return GoogleFonts.montserrat(color: AppColors.white);
    }

    return GoogleFonts.montserrat(color: AppColors.textBlack);
  }
}
