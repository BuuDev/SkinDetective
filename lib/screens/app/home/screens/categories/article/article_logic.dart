import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/pagination/pagination.dart';
import 'package:skin_detective/models/posts/posts.dart';

import 'package:skin_detective/services/apis/user/user.dart';

import '../../../../../../constants/constant.dart';

class ArticleLogic with ChangeNotifier {
  late BuildContext context;

  UserService ser = UserService.client(isLoading: false);
  bool checkEmpty = false;

  ArticleLogic({required this.context}) {
    controller.addListener(onScroll);
  }

  final ScrollController controller = ScrollController();

  Pagination<Posts> post = Pagination.initial(perPage: Constant.sizePage);

  void onScroll() async {
    if (controller.position.maxScrollExtent == controller.position.pixels) {
      loadMorePost();
    }
  }

  void refreshPost() async {
    try {
      post.isRefreshing = true;
      final lang = await SharedPreferences.getInstance();

      notifyListeners();

      var dataResponse = await ser.getPosts(
          post.perPage!, 1, TypePost.post.name, lang.getString('lang') ?? 'vn');

      if (dataResponse.data.isNotEmpty) {
        post = post.refresh(dataResponse);
        checkEmpty = false;
        notifyListeners();
      } else {
        checkEmpty = true;
        post.data = [];
        notifyListeners();
      }
    } catch (err) {
      debugPrint('$err');
      post.isRefreshing = false;
      notifyListeners();
    }
  }

  void loadMorePost() async {
    if (!post.canLoadMore) {
      return;
    }

    post.isLoading = true;
    notifyListeners();

    try {
      final lang = await SharedPreferences.getInstance();
      var dataResponse = await ser.getPosts(
          post.perPage!,
          post.currentPage! + 1,
          TypePost.post.name,
          lang.getString('lang') ?? 'vn');

      post = post.loadMore(dataResponse);
      if (dataResponse.data.isEmpty) {
        checkEmpty = true;
      } else {
        checkEmpty = false;
      }
      notifyListeners();
    } catch (err) {
      debugPrint('$err');
      post.isLoading = false;
      notifyListeners();
    }
  }
}
