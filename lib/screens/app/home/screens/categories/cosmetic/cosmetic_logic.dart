part of 'cosmetic.dart';

class CosMeticLogic extends ChangeNotifier {
  final BuildContext context;
  final CosMeticService _consMetic = CosMeticService.client(isLoading: false);

  final ScrollController controller = ScrollController();

  Pagination<ConsMeticData> cosmeticData =
      Pagination.initial(perPage: Constant.sizePage);

  CosMeticLogic({required this.context}) {
    controller.addListener(onScroll);
  }

  void onScroll() async {
    if (controller.position.maxScrollExtent == controller.position.pixels) {
      loadMoreCosmetic();
    }
  }

  void loadMoreCosmetic() async {
    if (!cosmeticData.canLoadMore) {
      return;
    }

    cosmeticData.isLoading = true;
    notifyListeners();

    try {
      final lang = await SharedPreferences.getInstance();
      var dataResponse = await _consMetic.getCosmeTic(
          cosmeticData.perPage!,
          cosmeticData.currentPage! + 1,
          TypePost.cosmetics.name,
          lang.getString('lang') ?? 'vn');

      if (dataResponse.data.isNotEmpty) {
        cosmeticData = cosmeticData.loadMore(dataResponse);
        notifyListeners();
      }
    } catch (err) {
      debugPrint('$err');
      cosmeticData.isLoading = false;
      notifyListeners();
    }
  }

  void refreshCosmetic() async {
    try {
      cosmeticData.isRefreshing = true;
      notifyListeners();
      final lang = await SharedPreferences.getInstance();
      var dataResponse = await _consMetic.getCosmeTic(cosmeticData.perPage!, 1,
          TypePost.cosmetics.name, lang.getString('lang') ?? 'vn');

      if (dataResponse.data.isNotEmpty) {
        cosmeticData = cosmeticData.refresh(dataResponse);
        notifyListeners();
      } else {
        cosmeticData = cosmeticData.refresh(dataResponse);
        notifyListeners();
      }
    } catch (err) {
      debugPrint('$err');
      cosmeticData.isRefreshing = false;
      notifyListeners();
    }
  }
}
