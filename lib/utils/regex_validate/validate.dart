class Validate {
  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_EMAIL_FIRST = RegExp(r'^[a-zA-Z0-9]\S+$');
  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_EMAIL =
      RegExp(r'^[^\W][a-zA-Z0-9-_\.]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_EMAIL_STRONG = RegExp(
      r'^(([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_NAME = RegExp(
      r'^[a-z0-9A-Z_\sÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹý]+$');

  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_PHONE = RegExp(r'(0[3|5|7|8|9])+([0-9]{8})\b');

  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_H1 = RegExp(r'<h1(.*?)>(.*?)</h1>');
  // ignore: non_constant_identifier_names
  static final RegExp PATTERN_H2 = RegExp(r'<h2(.*?)>(.*?)</h2>');

  static bool isEmail(String text) {
    if (!PATTERN_EMAIL_FIRST.hasMatch(text)) {
      return false;
    }
    if (!PATTERN_EMAIL.hasMatch(text)) {
      return false;
    }
    if (!PATTERN_EMAIL_STRONG.hasMatch(text)) {
      return false;
    }
    return true;
  }

  static bool isName(String text) {
    return PATTERN_NAME.hasMatch(text);
  }

  static bool isPhone(String text) {
    return PATTERN_PHONE.hasMatch(text);
  }

  static bool isLimit(String text, int maxLength) {
    return text.length < maxLength;
  }

  static bool getListH1(String html) {
    bool m = PATTERN_H1.hasMatch(html);
    return m;
  }

  static bool checkH2(String html) {
    bool m = PATTERN_H2.hasMatch(html);
    return m;
  }

  static Iterable<Match> getListH2(String html) {
    Iterable<Match> matches = PATTERN_H2.allMatches(html);
    return matches;
  }
}
