part of 'personal.dart';

const _minSize = 2;
const _maxSize = 30;

class PersonalLogic extends ChangeNotifier {
  final BuildContext context;

  final PostService _post = PostService.client(isLoading: false);

  bool isCheckBlog = true;
  bool isCheckPost = true;
  bool isCheckCosmetic = true;
  bool checkEmpty = false;

  late Pagination<ConsMeticData> dataPost;
  late Pagination<BlogUserData> dataBlog;
  late Pagination<CosmeticUserData> dataCosmetic;

  PersonalLogic({required this.context}) {
    dataPost = Pagination(total: 0, currentPage: 1, data: [], perPage: 0);
    dataBlog = Pagination(total: 0, currentPage: 1, data: [], perPage: 0);
    dataCosmetic = Pagination(total: 0, currentPage: 1, data: [], perPage: 0);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getPostUser(_minSize);
      getCosmeticUser(_minSize);
      getBlogUser(_minSize);
    });
  }
  void loadData() {
    getPostUser(_minSize);
    getCosmeticUser(_minSize);
    getBlogUser(_minSize);
  }

  void checkPost() {
    isCheckPost = !isCheckPost;
    getPostUser(isCheckPost ? _minSize : _maxSize);

    notifyListeners();
  }

  void checkBlog() {
    isCheckBlog = !isCheckBlog;
    getBlogUser(isCheckBlog ? _minSize : _maxSize);

    notifyListeners();
  }

  void checkCosmetic() {
    isCheckCosmetic = !isCheckCosmetic;
    getCosmeticUser(isCheckCosmetic ? _minSize : _maxSize);
    notifyListeners();
  }

  void getPostUser(int size) async {
    final lang = await SharedPreferences.getInstance();
    return _post
        .getPostUser(size, 1, lang.getString('lang') ?? 'vn')
        .then((value) {
      if (value.data.isEmpty) {
        checkEmpty = true;
        dataPost.data = [];
      } else {
        checkEmpty = false;
        dataPost = value;
      }

      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  void changeXemThemCosmetic() async {
    if (isCheckCosmetic) {
      getCosmeticUser(_minSize);
    } else {
      if (dataCosmetic.total == 2) {
        getCosmeticUser(_minSize);
        isCheckCosmetic = true;
      } else {
        getCosmeticUser(dataCosmetic.total! + 1);
      }
    }
    notifyListeners();
  }

  void getCosmeticUser(int size) async {
    final lang = await SharedPreferences.getInstance();
    return _post
        .getCosmeticUser(size, 1, 'cosmetics', lang.getString('lang') ?? 'vn')
        .then((value) {
      if (value.data.isEmpty) {
        dataCosmetic.data = [];
      } else {
        dataCosmetic = value;
      }

      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  Future<void> reset() {
    isCheckBlog = true;
    isCheckCosmetic = true;
    isCheckPost = true;
    notifyListeners();

    getPostUser(_minSize);
    getCosmeticUser(_minSize);
    getBlogUser(_minSize);

    return Future.value();
  }

  void changeXemThemBlog() async {
    if (isCheckBlog) {
      getBlogUser(_minSize);
    } else {
      if (dataBlog.total == 2) {
        getBlogUser(_minSize);
        isCheckBlog = true;
      } else {
        getBlogUser(dataBlog.total! + 1);
      }
    }
    notifyListeners();
  }

  void changeXemThemPost() async {
    if (isCheckPost) {
      getPostUser(_minSize);
    } else {
      if (dataPost.total == 2) {
        getBlogUser(_minSize);
        isCheckPost = true;
      } else {
        getPostUser(dataPost.total! + 1);
      }
    }
    notifyListeners();
  }

  void getBlogUser(int size) async {
    final lang = await SharedPreferences.getInstance();
    return _post
        .getBlogUser(size, 1, 'blog', lang.getString('lang') ?? 'vn')
        .then((value) {
      if (value.data.isEmpty) {
        dataBlog.data = [];
      } else {
        dataBlog = value;
      }

      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  void reloadPost() {
    getPostUser(_minSize);
    isCheckPost = true;
    notifyListeners();
  }
}
