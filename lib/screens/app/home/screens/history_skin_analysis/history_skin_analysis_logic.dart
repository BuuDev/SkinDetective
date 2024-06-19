import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/history_skin_analysis/history_skin_analysis.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/history_skin_analysis/history_skin_analysis.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';

class HistorySkinAnalysisLogic with ChangeNotifier {
  late BuildContext context;

  HistorySkinAnalysisLogic({required this.context}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getHistorySkinAnalysis();
    });
  }

  HistorySkinAnalysisService service =
      HistorySkinAnalysisService.client(isLoading: false);
  bool enableBtnEdit = false;
  bool enableBtnSkinAnalysis = false;
  int count = 0;
  List<HistorySkinAnalysisResponse> data = [];
  int a = 5;
  List<bool> ob = [];
  Set<int> listId = {};
  String id = "";

  void changeValue(int index, int id) {
    if (!enableBtnEdit) {
      Navigator.pushNamed(context, AppRoutes.faceAcneDetail, arguments: {
        'id': id,
      });

      return;
    }
    ob[index] = !ob[index];
    if (ob[index]) {
      listId.add(id);
    } else {
      listId.remove(id);
    }
    toList(listId);
    countSelectItem(index);
    notifyListeners();
  }

  void active() {
    enableBtnEdit = !enableBtnEdit;
    enableBtnSkinAnalysis = true;
    notifyListeners();
  }

  void active2() {
    if (!enableBtnSkinAnalysis) {
      return;
    }

    enableBtnSkinAnalysis = !enableBtnSkinAnalysis;
    enableBtnEdit = false;

    for (int i = 0; i < data.length; i++) {
      ob[i] = false;
    }
    count = 0;
    notifyListeners();
  }

  void selectAll() {
    for (int i = 0; i < data.length; i++) {
      ob[i] = true;
    }
    for (var item in data) {
      listId.add(item.id);
    }
    toList(listId);
    count = ob.length;
    notifyListeners();
  }

  void countSelectItem(int index) {
    ob[index] ? count++ : count--;
  }

  Future<void> getHistorySkinAnalysis() async {
    final test = await SharedPreferences.getInstance();
    if (GetIt.instance<AppVM>().isLogged) {
      try {
        data = await service
            .getHistorySkinAnalysis(test.getString('lang') ?? 'vn');
        ob = List.generate(data.length, (index) => false);
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    } /* else {
      //chưa đổi
      NotifyHelper.showSnackBar(LocaleKeys.generalMessageRequiredLogin.tr());
    } */
  }

  void deleteHistorySkinAnalysis() async {
    if (count > 0) {
      try {
        await service.deleteHistorySkinAnalysis(id);
        count = 0;
        notifyListeners();
        getHistorySkinAnalysis();
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      NotifyHelper.showSnackBar(
          LocaleKeys.generalMessageSelectImageDelete.tr());
    }
  }

  String toList(Set<int> list) {
    id = "";
    for (int i = 0; i < list.length; i++) {
      id += '${list.toList()[i]},';
    }
    notifyListeners();
    return id;
  }
}
