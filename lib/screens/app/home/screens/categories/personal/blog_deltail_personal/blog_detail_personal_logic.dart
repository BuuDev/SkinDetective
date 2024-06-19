import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/article_detail/article_detail_data.dart';
import 'package:skin_detective/models/comment/comment.dart';
import 'package:skin_detective/models/comment/comment_data.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/save_cosmetic_response/save_cosmetic_response.dart';
import 'package:skin_detective/services/apis/blog_detail_personal/blog_detail_personal.dart';
import 'package:skin_detective/services/apis/comment/comment.dart';
import 'package:skin_detective/services/apis/cosmetic/cosmetic.dart';
import 'package:skin_detective/services/apis/post/post.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';

class BlogDetailPersonalLogic with ChangeNotifier {
  late BuildContext context;
  int? postId;
  BlogDetailPersonalLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      postId = ModalRoute.of(context)!.settings.arguments as int;
      getComment(postId!);
      getBlogDetailPersonal(postId!);
      dataPost = Pagination(total: 0, currentPage: 1, data: [], perPage: 0);
    });
  }
  UserService service = UserService.client();
  CosMeticService consMeticService = CosMeticService.client();
  bool btnSave = false;
  ArticleDetailData? data;
  List<CommentData> lstComment = [];
  CommentService commentService = CommentService.client();
  String status = "";
  BlogDetailPersonalService blogDetailPersonalService =
      BlogDetailPersonalService.client();
  final PostService _post = PostService.client(isLoading: false);
  late Pagination<ConsMeticData> dataPost;
  void save() {
    btnSave = !btnSave;
    notifyListeners();
  }

  void getBlogDetailPersonal(int id) async {
    final test = await SharedPreferences.getInstance();
    try {
      data = await UserService.client(isLoading: false).getPostDetail(
        id,
        TypePost.post.name,
        test.getString('lang') ?? 'vn',
      );
      btnSave = data!.saveStatus;
      status = ('post_status_${data!.getFiledStatus}').tr();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void saveCosmetic(int id) async {
    try {
      SaveCosmeticResponse data =
          await CosMeticService.client(isLoading: false).saveCosmetic(id);
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

  void createComment(String comment) async {
    try {
      await commentService.createdComment(postId!, comment);
      getComment(postId!);
      NotifyHelper.showSnackBar(LocaleKeys.commentMessageStatus.tr());
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

  Future<void> changeStatus(String status) async {
    try {
      await blogDetailPersonalService.getUsers(postId!, status);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getPostUser(int size) async {
    final lang = await SharedPreferences.getInstance();
    return _post
        .getPostUser(size, 1, lang.getString('lang') ?? 'vn')
        .then((value) {
      if (value.data.isEmpty) {
        dataPost.data = [];
      } else {
        dataPost = value;
      }

      notifyListeners();
    }).catchError((err) {
      debugPrint('$err');
    });
  }

  String? getStatus(TypeBlog status) {
    switch (status) {
      case TypeBlog.waiting:
        return LocaleKeys.postStatusWaiting.tr();
      case TypeBlog.active:
        return LocaleKeys.postStatusActive.tr();
      case TypeBlog.disabled:
        return LocaleKeys.postStatusDisabled.tr();
      case TypeBlog.draft:
        return LocaleKeys.postStatusDraft.tr();
      default:
        return null;
    }
  }
}

enum TypeBlog {
  waiting,
  active,
  draft,
  disabled,
  delete,
}
