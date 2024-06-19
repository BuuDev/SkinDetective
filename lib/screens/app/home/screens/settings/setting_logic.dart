part of 'setting.dart';

class SettingLogic with ChangeNotifier {
  late BuildContext context;
  SettingLogic({required this.context});
  bool valueNews = false;
  bool valuePost = false;
  bool valueHD = false;

  String valueLanguage = "";

  bool check = false;
  List<bool> lstButton = [for (int i = 0; i < 13; i++) false];
  List<bool> lstBtnToggle = [for (int i = 0; i < 3; i++) false];
  final ImagePicker picker = ImagePicker();
  List<XFile>? image = [];
  List<File> file = [];
  TextEditingController commentController = TextEditingController();
  double point = 5;
  final RatingService service = RatingService.client(isLoading: false);
  String fcmToken = '';
  SettingDevice userSetting = SettingDevice(
      id: 0,
      userId: 0,
      newCategory: false,
      direction: false,
      language: '',
      yourWriting: false);
  UserService ser = UserService.client(isLoading: false);

  void updateBtn(int index) {
    lstButton[index] = !lstButton[index];
    notifyListeners();
  }

  void updateBtnToggle(int index) {
    if (GetIt.instance<AppVM>().isLogged) {
      FirebaseMessaging.instance.getToken().then((value) {
        fcmToken = value!;
      });
      lstBtnToggle[index] = !lstBtnToggle[index];
      notifyListeners();
      registerFcmToken(fcmToken);
    }
  }

  Widget getIcon(index) {
    return lstButton[index]
        ? const Icon(Icons.expand_more)
        : const Icon(Icons.expand_less);
  }

  void getSettingUser() async {
    if (GetIt.instance<AppVM>().isLogged) {
      try {
        userSetting = await ser.getSettingUser();
        lstBtnToggle[0] = userSetting.newCategory;
        lstBtnToggle[1] = userSetting.yourWriting;
        lstBtnToggle[2] = userSetting.direction;
        // valueLanguage = userSetting.language.toUpperCase();
      } catch (e) {
        debugPrint('$e');
      }
    }
  }

  Color getColor(index) {
    return lstButton[index] ? AppColors.textBlue : AppColors.textBlack;
  }

  void selectImage() async {
    image = await picker.pickMultiImage();
    if (image!.isNotEmpty) {
      image?.forEach((item) {
        file.add(File(item.path));
        notifyListeners();
      });
    }
    if (file.length > 20) {
      for (int i = 19; i < file.length; i++) {
        file.removeAt(i);
      }
      notifyListeners();

      NotifyHelper.showSnackBar(
          LocaleKeys.generalMessageErrorSelectMaxImage.tr());
    }
    notifyListeners();
  }

  void removeImage(index) {
    // file = null;
    file.removeAt(index);
    notifyListeners();
  }

  void changeRating(double rating) {
    point = rating;
    notifyListeners();
  }

  void activeRadioButton() {
    check = !check;
    notifyListeners();
  }

  void resetRating() {
    commentController.clear();
    file.clear();
    check = false;
    point = 5;
    notifyListeners();
  }

  void changeLanguage(String langCode) {
    valueLanguage = langCode;
    notifyListeners();
  }

  void rating() async {
    if (!check) {
      NotifyHelper.showSnackBar(
          LocaleKeys.settingRatingMessageConfirmSendRating.tr());
    } else {
      if (image == null) {
        try {
          if (commentController.text.isNotEmpty) {
            await service.rating(
                Helper.ratingRound(point), commentController.text, check);
            NotifyHelper.showSnackBar(
                LocaleKeys.settingRatingMessageSendRatingSuccess.tr());
            resetRating();
          } else {
            await service.rating(Helper.ratingRound(point), "", check);

            NotifyHelper.showSnackBar(
                LocaleKeys.settingRatingMessageSendRatingSuccess.tr());
            resetRating();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        try {
          if (commentController.text.isNotEmpty) {
            await service.rating(
                Helper.ratingRound(point), commentController.text, check, file);
            NotifyHelper.showSnackBar(
                LocaleKeys.settingRatingMessageSendRatingSuccess.tr());
            resetRating();
          } else {
            await service.rating(Helper.ratingRound(point), "", check, file);
            NotifyHelper.showSnackBar(
                LocaleKeys.settingRatingMessageSendRatingSuccess.tr());
            resetRating();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> registerFcmToken(String fcmToken, {String? lang}) async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    late String? uniqueId;
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      uniqueId = build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      uniqueId = data.identifierForVendor;
    }
    UserService service = UserService.client();
    UserSetting data = await service.updateInfoDevice(
      fcmToken: fcmToken,
      deviceId: uniqueId,
      os: Platform.operatingSystem,
      newCategory: lstBtnToggle[0],
      yourWriting: lstBtnToggle[1],
      direction: lstBtnToggle[2],
      language: lang.toString(),
    );
    valueLanguage = data.language;
    notifyListeners();
    final test = await SharedPreferences.getInstance();
    test.setString('lang', valueLanguage);
    notifyListeners();
  }

  void changeLanguageApi(String language) async {
    final test = await SharedPreferences.getInstance();

    String getLang = test.getString('lang') ?? 'vn';
    if (language != getLang) {
      await FirebaseMessaging.instance.getToken().then((value) {
        fcmToken = value!;
        notifyListeners();
      });
      test.setString('data', json.encode([]));
      await registerFcmToken(fcmToken, lang: language);
      NavigationService.gotoAppStack();
    }
  }

  void getPointaverage() async {
    AverageRating data =
        await RatingService.client(isLoading: false).getAverageRating();
    point = data.averageRating;
    notifyListeners();
  }
}

enum lang { vn, en }

String getLang(lang item) {
  switch (item) {
    case lang.vn:
      return 'vn';
    case lang.en:
      return 'en';
    default:
      return '';
  }
}

class CustomExpansionTile extends StatefulWidget {
  final void Function(bool)? onExpansionChanged;
  final String leading;
  final String title;
  final int index;
  final List<Widget> children;
  final Widget? trailing;

  const CustomExpansionTile({
    Key? key,
    this.onExpansionChanged,
    required this.title,
    required this.leading,
    required this.index,
    required this.children,
    this.trailing,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  Widget get icon {
    return widget.trailing ??
        (isExpanded
            ? const Icon(Icons.expand_more)
            : const Icon(Icons.expand_less));
  }

  void onExpand(bool isExpanded) {
    setState(() {
      this.isExpanded = isExpanded;
    });
    widget.onExpansionChanged?.call(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: onExpand,
      iconColor: AppColors.textLightGray,
      collapsedIconColor: AppColors.textLightGray,
      leading: SvgPicture.asset(
        widget.leading,
        color: isExpanded ? AppColors.textBlue : AppColors.textBlack,
      ),
      trailing: icon,
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: isExpanded ? AppColors.textBlue : AppColors.textBlack,
              fontWeight: FontWeight.bold,
            ),
      ),
      children: widget.children,
    );
  }
}
