import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/analytic/analytic.dart';
import 'package:skin_detective/models/popup_servey_check/popup_servey_check.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/providers/camera/camera_provider.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/screens/app/face_stream/face_guide.dart';
import 'package:skin_detective/screens/app/home/screens/history_skin_analysis/history_skin_analysis_logic.dart';

import 'package:skin_detective/services/apis/ance/ance.dart';
import 'package:skin_detective/services/apis/survey/survey.dart';

import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:skin_detective/utils/notify_helper/notify_helper.dart';
import '../../models/setting_device/setting_device.dart';
import '../../screens/app/face_stream/popup_analysis_results/popup_analysis_results.dart';
import '../../screens/app/home/home.dart';
import '../../screens/app/home/popup_survey/popup_survey.dart';
import '../../services/apis/user/user.dart';
import 'package:uuid/uuid.dart';

class AcneAnalyzeVM with ChangeNotifier {
  final BuildContext context;

  late HomeStepStatus status;
  UserService service = UserService.client(isLoading: false);
  SettingDevice? settingDevice;
  SurveyService ser = SurveyService.client(isLoading: false);

  bool isAnalyzed = false;
  bool isCheckAnalyzed = true;
  String uid = '';
  var uuid = const Uuid();

  Map<ETypeFace, XFile> images = {};
  PopupServeyCheck popupServeyCheck =
      PopupServeyCheck(showPopup: false, type: null);

  bool checkDirection = false;
  bool checkSurvey = false;
  String threeTime = """<p>${LocaleKeys.surveysPopupAContentPart1.tr()}</p>
                              <p>${LocaleKeys.surveysPopupAContentPart2.tr()}</p> 
                              
                              <p>${LocaleKeys.surveysPopupAContentPart3.tr()}</p>
                                  """;
  String sixMonth = """<p>${LocaleKeys.surveysPopupBContentPart1.tr()}</p>
                              <p>${LocaleKeys.surveysPopupBContentPart2.tr()}</p> 
                              
                              <p>${LocaleKeys.surveysPopupBContentPart3.tr()}</p>
                                  """;

  AcneAnalyzeVM(this.context) {
    if (GetIt.instance<AppVM>().isLogged) {
      status = HomeStepStatus.none;
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        getPopupCheck();
        callAPIcheckButton();
      });
    } else {
      status = HomeStepStatus.none;
    }
  }

  Future<void> getPopupCheck() async {
    final test = await SharedPreferences.getInstance();
    try {
      popupServeyCheck =
          await ser.getPopupCheck(test.getString('lang') ?? 'vn');
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> callAPIcheckButton() async {
    try {
      settingDevice = await service.getSettingUser();
      checkDirection = settingDevice!.direction;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showPopUp() {
    getPopupCheck();
    if (popupServeyCheck.showPopup) {
      if (popupServeyCheck.type == PopupServeyType.popupB) {
        showPopupSurvey(context, sixMonth).then((value) {
          getPopupCheck();
        });
      }
      if (popupServeyCheck.type == PopupServeyType.popupA) {
        showPopupSurvey(context, threeTime).then((value) {
          getPopupCheck();
        });
      }
    }
  }

  Analytic? analytic;

  Analytic get analyzeResult => analytic!;

  String get title {
    switch (status) {
      case HomeStepStatus.confirm:
        return LocaleKeys.confirm.tr() /* 'Xác nhận' */;
      case HomeStepStatus.analyzing:
        return isAnalyzed
            ? LocaleKeys.navtopEndAnalyze.tr() /* 'Phân tích xong!' */ : LocaleKeys
                .navtopAnalyzing
                .tr() /* 'Đang phân tích...' */;
      case HomeStepStatus.result:
        return LocaleKeys.navtopResult.tr();
      default:
        return LocaleKeys.homeTitle;
    }
  }

  void gotoDetail(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.faceAcneDetail, arguments: {
      'data': analyzeResult,
    });
  }

  void backToHome() {
    status = HomeStepStatus.none;
    /* if (isAnalyzed) {
      images.clear();
      isCheckAnalyzed = true;
    } */

    analytic = null;
    images.clear();
    isAnalyzed = false;
    notifyListeners();
  }

  void confirmAnalyze(Map<ETypeFace, XFile> images) {
    this.images = images;
    status = HomeStepStatus.confirm;
    notifyListeners();
  }

  void cancelAnalysis() async {
    try {
      var del = await AnceService.client(isLoading: false).cancelAnalyze(uid);

      if (del.success) {
        uid = '';
        isCheckAnalyzed = true;
        notifyListeners();
      }

      backToHome();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void startAnalyze(BuildContext context) async {
    uid = uuid.v4();

    status = HomeStepStatus.analyzing;

    isAnalyzed = false;

    isCheckAnalyzed = false;

    var popup = context.read<HomePageLogic>();
    var history = context.read<HistorySkinAnalysisLogic>();
    notifyListeners();

    final test = await SharedPreferences.getInstance();

    AnceService.client(isLoading: false)
        .resultAnalyze(
            uid,
            File(images[ETypeFace.Face]!.path),
            File(images[ETypeFace.FaceLeft]!.path),
            File(images[ETypeFace.FaceRight]!.path),
            test.getString('lang') ?? 'vn')
        .then((value) async {
      isCheckAnalyzed = true;

      isAnalyzed = true;

      notifyListeners();
      //kiem tra uid neu uid khong rong thi show popup va ngược lại
      if (uid.isNotEmpty) {
        if (popup.bottomIndex == 2 && status == HomeStepStatus.analyzing) {
          uid = '';
          analytic = value;
          notifyListeners();
        } else {
          //this.context dùng để dùng context của màn hình trc đó
          await history.getHistorySkinAnalysis();
          popupAnalysisResults(this.context).then((isShowResult) {
            if (isShowResult == true) {
              //Gán data phân tích và show result
              uid = '';
              analytic = value;
              NavigationService.popUntil(
                  ModalRoute.withName(AppRoutes.homePage));
              showResult();
              popup.onPageChange(2);
            }
            if (isShowResult == false) {
              //Gán data phân tích và show result
              uid = '';
              analytic = value;

              notifyListeners();
            }
          });
        }
      }
    }).catchError((error) {
      debugPrint('$error');
      isCheckAnalyzed = true;
      status = HomeStepStatus.confirm;
      notifyListeners();
    });
  }

  void showResult() async {
    if (analytic != null) {
      status = HomeStepStatus.result;
      await getPopupCheck();
      showPopUp();
      notifyListeners();
    }
  }

  void gotoAnalyze(BuildContext context) async {
    if (!context.read<AppVM>().isLogged) {
      return NotifyHelper.showSnackBar(
          LocaleKeys.generalMessageRequiredLogin.tr());
    }
    await callAPIcheckButton();

    if (!checkDirection) {
      Navigator.pushNamed(
        context,
        AppRoutes.facePermission,
      ).then((value) {
        context.read<CameraProvider>().doneCapture();
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SkinScanGuide(),
        ),
      ).then((value) {
        context.read<CameraProvider>().doneCapture();
      });
    }
    notifyListeners();
  }
}

enum HomeStepStatus {
  none,
  confirm,
  analyzing,
  result,
}
