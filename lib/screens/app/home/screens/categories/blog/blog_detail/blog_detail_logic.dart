import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/comment/comment.dart';
import 'package:skin_detective/models/comment/comment_data.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_data.dart';
import 'package:skin_detective/services/apis/comment/comment.dart';
import 'package:skin_detective/services/apis/cosmetic/cosmetic.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';

import '../../../../../../../models/blog_detail/blog_detail_data.dart';
import '../../../../../../../models/save_cosmetic_response/save_cosmetic_response.dart';

class BlogDetailLogic with ChangeNotifier {
  late BuildContext context;
  int? postId;
  BlogDetailLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      postId = ModalRoute.of(context)!.settings.arguments as int;
      getComment(postId!);
      getDataBlogDetail(postId!);
    });
  }
  bool btnSave = false;
  UserService service = UserService.client();
  CosMeticService cosMeticService = CosMeticService.client();
  CommentService commentService = CommentService.client();
  BlogDetailData? data;
  List<CommentData> lstComment = [];
  void save() {
    btnSave = !btnSave;
    notifyListeners();
  }

  void getDataBlogDetail(int id) async {
    final test = await SharedPreferences.getInstance();
    try {
      data = await UserService.client(isLoading: false).getBlogDetail(
        id,
        TypePost.blog.name,
        test.getString('lang') ?? 'vn',
      );
      btnSave = data!.saveStatus;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveBlog(int id) async {
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
}
