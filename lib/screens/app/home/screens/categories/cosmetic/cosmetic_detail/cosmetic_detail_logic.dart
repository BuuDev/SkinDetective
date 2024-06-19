part of 'cosmetic_detail.dart';

class CosmeticDetailLogic extends ChangeNotifier {
  late BuildContext context;
  int? postId;

  CosmeticDetailLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      postId = ModalRoute.of(context)!.settings.arguments as int;
      getCosmeticDetail(postId!);
      getComment(postId!);
    });
  }

  bool btnSave = false;
  UserService service = UserService.client();
  CosMeticService consMeticService = CosMeticService.client();
  CommentService commentService = CommentService.client();
  CosmeticDetailData? data;
  int cosmeticId = 0;
  List<CommentData> lstComment = [];
  bool activeButtonWriteComment = false;

  void save() {
    btnSave = !btnSave;
    notifyListeners();
  }

  void getCosmeticDetail(int id) async {
    final test = await SharedPreferences.getInstance();
    try {
      data = await UserService.client(isLoading: false).getCosmeticDetail(
        id,
        TypePost.cosmetics.name,
        test.getString('lang') ?? 'vn',
      );
      cosmeticId = id;
      btnSave = data!.saveStatus;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveCosmetic(int id) async {
    try {
      SaveCosmeticResponse data =
          await CosMeticService.client(isLoading: false).saveCosmetic(id);
      //btnSave = true;
      btnSave = data.status == 1 ? true : false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getComment(int id) async {
    try {
      Comment data =
          await CommentService.client(isLoading: false).getComment(id);
      lstComment = data.data.isNotEmpty ? data.data : [];

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deletedComment(int id, int index) async {
    try {
      await commentService.deleteComment(id);
      // getComment(postId as int);
      lstComment.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void createComment(String comment) async {
    try {
      await commentService.createdComment(postId!, comment);
      getComment(postId!);
      NotifyHelper.showSnackBar(LocaleKeys.commentMessageStatus.tr());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
