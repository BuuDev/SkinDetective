part of 'face_acne_detail.dart';

class FaceAcneDetailLogic with ChangeNotifier {
  final BuildContext context;
  Analytic? analytic;
  AnalyzeDetail? acneDetail;
  List<AnalyzeDetail> acneData = [];

  int pageIndex = 1; // [0,1,2 : frontal,left,right]
  FaceAcneDetailLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Analytic? data = dataDetail;

      if (data != null) {
        updateDetailData(data);
      } else {
        loadDetail(analyzeId!);
      }
    });
  }

  void loadDetail(int id) async {
    final test = await SharedPreferences.getInstance();
    AnceService.client()
        .detailAnalyze(test.getString('lang') ?? 'vn', id)
        .then((value) {
      updateDetailData(value);
    });
  }

  ///id từ argument
  int? get analyzeId {
    return (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['id'];
  }

  ///data từ argument
  Analytic? get dataDetail {
    return (ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>)['data'];
  }

  void updateDetailData(Analytic detail) {
    analytic = detail;
    acneData = [];
    // acneData.add(analytic!.left);
    acneData.add(analytic!.frontal);
    // acneData.add(analytic!.right);
    acneDetail = acneData[0];
    notifyListeners();
  }

  void onChangePageIndex(int index) {
    if (pageIndex != index) {
      pageIndex = index;
      acneDetail = acneData[index];
      notifyListeners();
    }
  }
}
