part of 'sign_up_email.dart';

class SignUpEmailLogic extends ChangeNotifier {
  final BuildContext context;
  SignUpEmailLogic({required this.context});
  TextEditingController txtName = TextEditingController();
  TextEditingController txtNamSinh = TextEditingController();
  TextEditingController txtQuocGia = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? images;
  final UserService _userService = UserService.client(isLoading: false);
  DataNational nationSelected =
      DataNational(id: 242, name: 'Viet Nam', code: 'VN');

  List<DataNational> nationals = [];

  void filePicker() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      images = photo;

      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint('Error picker image: $e');
    }
  }

  void validate() {
    txtName.text.trim();
    txtNamSinh.text.trim();
    notifyListeners();
  }

  void checkProfile() async {
    if (txtName.text.trim().isNotEmpty) {
      if (txtName.text.trim().length <= 25) {
        if (txtName.text.trim().isEmpty || txtNamSinh.text.trim().isEmpty) {
          NotifyHelper.showSnackBar(LocaleKeys.enterinforFullInfor.tr());
        } else {
          final now = DateTime.now().year;
          if (int.parse(txtNamSinh.text) > int.parse(now.toString())) {
            NotifyHelper.showSnackBar(LocaleKeys.profileYearErrNow.tr());
          } else {
            int a = int.parse(now.toString()) - int.parse(txtNamSinh.text);

            if (txtNamSinh.text.length == 4 &&
                a > 13 &&
                int.parse(txtNamSinh.text) >= (now - 100)) {
              if (images == null) {
                updateAccount(txtName.text, int.parse(txtNamSinh.text),
                    nationSelected.id);
              } else {
                updateAccount(txtName.text, int.parse(txtNamSinh.text),
                    nationSelected.id, File(images!.path));
              }
            } else if (int.parse(txtNamSinh.text) <= (now - 100)) {
              NotifyHelper.showSnackBar(LocaleKeys.profileErrYear100.tr());
            } else {
              if (txtNamSinh.text.length != 4) {
                NotifyHelper.showSnackBar(LocaleKeys.profileYearErr.tr());
              } else {
                Navigator.pushNamed(context, AppRoutes.errOld,
                    arguments: txtName.text);
              }
            }
          }
        }
      } else {
        NotifyHelper.showSnackBar(LocaleKeys.enterinforNameErr25.tr());
      }
    } else {
      NotifyHelper.showSnackBar(LocaleKeys.enterinforNameErrSpace.tr());
    }
    notifyListeners();
  }

  Future<void> updateAccount(String name, int year, int id,
      [File? image]) async {
    try {
      var a = await _userService.updateAccount(name, year, id, image);

      GetIt.instance<UserViewModel>().updateInfo(a);
      NavigationService.gotoAppStack();
    } catch (err) {
      //NotifyHelper.showSnackBar('Failed');
    }
    notifyListeners();
  }

  void getNational() async {
    try {
      nationals = await _userService.getNational();

      notifyListeners();
    } catch (err) {
      NotifyHelper.showSnackBar('Failed');
    }
    notifyListeners();
  }

  void changeNational(String value) {
    for (var item in nationals) {
      if (item.name == value) {
        nationSelected = item;
        break;
      }
    }
    notifyListeners();
  }

  void changYear(int year) {
    txtNamSinh.text = year.toString();
    notifyListeners();
  }
}
