part of 'user_profile.dart';

class UserProfileLogic extends ChangeNotifier {
  final BuildContext context;
  UserProfileLogic({required this.context});

  TextEditingController txtName =
      TextEditingController(text: GetIt.instance<UserViewModel>().data.name);

  TextEditingController txtDateTime = TextEditingController(
      text: '${GetIt.instance<UserViewModel>().data.birthday ?? ' '.trim()}');

  final ImagePicker _picker = ImagePicker();

  XFile? images;

  final UserService _userService = UserService.client(isLoading: false);

  List<DataNational> lst = [];

  DataNational nationSelected = DataNational(id: 0, name: '', code: '');

  bool enable = false;

  void filePicker() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    images = photo;
    validate();
    notifyListeners();
  }

  void validate() {
    if (GetIt.instance<AppVM>().isLogged) {
      if (txtName.text.trim().isEmpty || txtDateTime.text.trim().isEmpty) {
        enable = false;
        notifyListeners();
        return;
      }

      User data = GetIt.instance<UserViewModel>().data;

      enable = images != null ||
          data.name.trim() != txtName.text.trim() ||
          '${data.birthday}'.trim() != txtDateTime.text.trim() ||
          data.nationalityId != nationSelected.id;

      notifyListeners();
    } else {
      enable = false;
      notifyListeners();
    }
  }

  void updateUser([File? image]) {
    final now = DateTime.now().year;
    if (txtDateTime.text.length != 4) {
      NotifyHelper.showSnackBar(LocaleKeys.profileYearErr.tr());
    } else {
      if (int.parse(txtDateTime.text) > now) {
        NotifyHelper.showSnackBar(LocaleKeys.profileYearErrNow.tr());
      } else {
        if (now - int.parse(txtDateTime.text) > 13 &&
            int.parse(txtDateTime.text) >= (now - 100)) {
          updateAccount(txtName.text, int.parse(txtDateTime.text),
              nationSelected.id, image);
        } else {
          NotifyHelper.showSnackBar(LocaleKeys.profileErrYear.tr());
        }
      }
    }
  }

  Future<void> updateAccount(String name, int year, int id,
      [File? image]) async {
    try {
      var a = await _userService.updateAccount(name, year, id, image);
      GetIt.instance<UserViewModel>().updateInfo(a);

      NotifyHelper.showSnackBar(LocaleKeys.profileUpdateContent.tr());
      enable = false;
      NavigationService.gotoAppStack();
      /*  Future.delayed(const Duration(seconds: 1), () {
        
      }); */
    } catch (err) {
      //NotifyHelper.showSnackBar('Failed');
    }
    notifyListeners();
  }

  void changeNational(String value) {
    for (var item in lst) {
      if (item.name == value) {
        nationSelected = item;
        break;
      }
    }
    validate();
    notifyListeners();
  }

  void getNational() async {
    try {
      lst = await _userService.getNational();
      var id = GetIt.instance<UserViewModel>().data.nationalityId;
      if (id != null) {
        for (var item in lst) {
          if (item.id == id) {
            nationSelected = item;
            break;
          }
        }
      }

      notifyListeners();
    } catch (err) {
      NotifyHelper.showSnackBar('Failed');
    }
  }

  void getYear(int year) {
    txtDateTime.text = year.toString();
    notifyListeners();
  }
}
