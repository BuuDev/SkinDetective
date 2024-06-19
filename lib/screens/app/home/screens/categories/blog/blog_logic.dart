part of 'blog.dart';

class BlogLogic extends ChangeNotifier {
  final BuildContext context;
  final CosMeticService _consMetic = CosMeticService.client(isLoading: false);

  BlogLogic({required this.context}) {
    controller.addListener(onScroll);
  }

  final ScrollController controller = ScrollController();

  Pagination<ConsMeticData> blogData =
      Pagination.initial(perPage: Constant.sizePage);

  void onScroll() async {
    if (controller.position.maxScrollExtent == controller.position.pixels) {
      loadMoreBlog();
    }
  }

  void refreshBlog() async {
    try {
      final lang = await SharedPreferences.getInstance();
      blogData.isRefreshing = true;
      notifyListeners();

      var dataResponse = await _consMetic.getBlog(blogData.perPage!, 1,
          TypePost.blog.name, lang.getString('lang') ?? 'vn');

      if (dataResponse.data.isNotEmpty) {
        blogData = blogData.refresh(dataResponse);
        notifyListeners();
      } else {
        blogData = blogData.refresh(dataResponse);
        notifyListeners();
      }
    } catch (err) {
      debugPrint('$err');
      blogData.isRefreshing = false;
      notifyListeners();
    }
  }

  void loadMoreBlog() async {
    if (!blogData.canLoadMore) {
      return;
    }

    blogData.isLoading = true;
    final lang = await SharedPreferences.getInstance();
    notifyListeners();

    try {
      var dataResponse = await _consMetic.getBlog(
          blogData.perPage!,
          blogData.currentPage! + 1,
          TypePost.blog.name,
          lang.getString('lang') ?? 'vn');

      if (dataResponse.data.isNotEmpty) {
        blogData = blogData.loadMore(dataResponse);
        notifyListeners();
      }
    } catch (err) {
      debugPrint('$err');
      blogData.isLoading = false;
      notifyListeners();
    }
  }
}
