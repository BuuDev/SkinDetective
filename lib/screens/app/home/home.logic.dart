part of 'home.dart';

class HomePageLogic with ChangeNotifier {
  final BuildContext context;

  late PageController pageController;
  late String title;
  late int bottomIndex;
  late AcneAnalyzeVM acneAnalyzeVM;

  Pagination<ConsMeticData> homeBlog = Pagination.initial(perPage: 5);
  Pagination<ConsMeticData> homeCosmetic = Pagination.initial(perPage: 5);
  Pagination<ConsMeticData> homePost = Pagination.initial(perPage: 5);

  HomePageLogic({required this.context, int initPage = 2}) {
    pageController = PageController(initialPage: initPage);
    title = LocaleKeys.homeTitle;
    bottomIndex = 2;
    acneAnalyzeVM = context.read<AcneAnalyzeVM>();
    acneAnalyzeVM.addListener(onListenAcneAnalyze);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      NotificationService().initialize();
      GetIt.instance<AppVM>().addListener(onCheckAuthStatus);
    });
  }

  Future<void> loadDataHome() {
    getHomeCosmetic();
    getHomeBlog();
    getHomePost();
    context.read<HistorySkinAnalysisLogic>().getHistorySkinAnalysis();
    context.read<AcneAnalyzeVM>().getPopupCheck();
    if (GetIt.instance<AppVM>().isLogged) {
      GetIt.instance<AppVM>().activePosts();
    }

    return Future.value();
  }

  void onListenAcneAnalyze() {
    if (bottomIndex == 2) {
      title = acneAnalyzeVM.title;
    } else {
      title = BottomNavigation.getDataItems(context)[bottomIndex].title;
    }
    notifyListeners();
  }

  void onPageChange(int index) {
    bottomIndex = index;
    /*  if (BottomNavigation.getDataItems(context)[bottomIndex].id == 3) {
      if (acneAnalyzeVM.status == HomeStepStatus.result ||
          acneAnalyzeVM.status == HomeStepStatus.analyzing ||
          acneAnalyzeVM.status == HomeStepStatus.confirm) {
        title = acneAnalyzeVM.title;
      } else {
        title = 'Trang chủ';
      }
    } else {
      title = BottomNavigation.getDataItems(context)[bottomIndex].title;
    } */
    //onCheckAuthStatus();

    notifyListeners();

    pageController.jumpToPage(index);
  }

  void updateBottomTab(int index, BottomNavModel data) {
    // Check Login mới cho access vào spa, doctor và categories
    if ((index == 0 || index == 1 || index == 3) &&
        !GetIt.instance<AppVM>().isLogged) {
      NotifyHelper.showSnackBar(LocaleKeys.generalMessageRequiredLogin.tr());
    } else {
      title = index == 2 ? acneAnalyzeVM.title : data.title;
      if (index == bottomIndex) {
        return;
      }

      onPageChange(index);
    }
  }

  void backToHome() {
    if (bottomIndex != 2) {
      updateBottomTab(2, BottomNavigation.getDataItems(context)[2]);
    }
    acneAnalyzeVM.backToHome();
    context.read<CameraProvider>().setRestartCamera();
  }

  void getHomeCosmetic() async {
    final lang = await SharedPreferences.getInstance();
    return HomeService.client(isLoading: false)
        .getHomeCosmeTic(
            TypePost.cosmetics.name, lang.getString('lang') ?? 'vn')
        .then((value) {
      homeCosmetic = value;
      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  void getHomeBlog() async {
    final lang = await SharedPreferences.getInstance();
    return HomeService.client(isLoading: false)
        .getHomeBlog(TypePost.blog.name, lang.getString('lang') ?? 'vn')
        .then((value) {
      homeBlog = value;
      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  void getHomePost() async {
    final lang = await SharedPreferences.getInstance();
    return HomeService.client(isLoading: false)
        .getHomePost(TypePost.post.name, lang.getString('lang') ?? 'vn')
        .then((value) {
      homePost = value;
      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  void onCheckAuthStatus() {
    if (!GetIt.instance<AppVM>().isLogged && bottomIndex != 2) {
      updateBottomTab(2, BottomNavigation.getDataItems(context)[2]);
    }
  }

  @override
  void dispose() {
    acneAnalyzeVM.removeListener(onListenAcneAnalyze);
    GetIt.instance<AppVM>().removeListener(onCheckAuthStatus);
    super.dispose();
  }
}
