part of 'survey.dart';

class SurveyLogic with ChangeNotifier {
  late BuildContext context;

  SurveyModel dataSurvey = SurveyModel(
      id: 0,
      name: "",
      creator: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: SurveyStatus.active,
      partOne: [],
      partTwo: [],
      partThree: []);

  SurveyAnswers? data;
  SurveyAnswers? surveyAnswers;

  SurveyLogic({
    required this.context,
  }) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _readData();
      callApi();
    });
  }

  Map<int, int> questionHienThi = {};
  SurveyService service = SurveyService.client();
  int check = 1;
  bool isChecked = false;

  List<Answers> lstAnswers = [];

  final ScrollController _scrollController = ScrollController();

  void callApi() async {
    final test = await SharedPreferences.getInstance();
    try {
      dataSurvey = await service.surveyAPI(test.getString('lang') ?? 'vn');
      hienthiQuestion(dataSurvey.partOne, 0);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void surveyAnswer() async {
    try {
      data = await service.saveAnswer(surveyAnswers!);
      notifyListeners();
    } catch (err) {
      debugPrint('$err');
    }
  }

  Widget questionItem(SurveyQuestionType checkQuestion, int index,
      List<QuestionSurvey> lst, int id) {
    switch (checkQuestion) {
      case SurveyQuestionType.radio:
        return RadioQuestion(
          sTT: id,
          data: lst[index].detailModel,
          dataAnswer: checkOption(lst[index].id)!,
          onCheck: (lst, questionId) {
            bool checked = false;
            if (lst[0].freeText == false) {
              checkRadio(lst, questionId);
            }
            if (lst[0].freeText == true) {
              if (lst[0].text!.isEmpty && lst[0].freeText == true) {
                if (!checked) {
                  addQuestion(id, questionId);
                  lstAnswers.removeWhere(
                      (element) => element.questionId == questionId);
                }
              } else {
                checkRadio(lst, questionId);
              }
            }
            _writeData(lstAnswers);
          },
        );
      case SurveyQuestionType.slider:
        return SliderQuestion(
          sTT: id,
          data: lst[index].detailModel,
          dataAnswer: checkOption(lst[index].id)!,
          levels: lst[index].levels,
          onCheck: (lst, soluong, questionId) {
            checkSlider(lst, soluong, questionId);
            _writeData(lstAnswers);
          },
        );
      default:
        return AreaQuestion(
          sTT: id,
          data: lst[index].detailModel,
          dataAnswer: checkOption(lst[index].id)!,
          onCheck: (value, lst, questionId) {
            if (value!.isEmpty) {
              addQuestion(id, questionId);
              lstAnswers
                  .removeWhere((element) => element.questionId == questionId);
            }
            if (value.isNotEmpty) {
              checkArea(lst, questionId);
            }
            _writeData(lstAnswers);
          },
        );
    }
  }

  List<OptionAnswer>? checkOption(int id) {
    bool checked = false;
    int index = 0;
    for (int i = 0; i < lstAnswers.length; i++) {
      if (lstAnswers[i].questionId == id) {
        checked = true;
        index = i;
      }
    }
    switch (checked) {
      case true:
        return lstAnswers[index].options;
      default:
        return [];
    }
  }

  List<Widget> getListQuestion(
      BuildContext context, List<QuestionSurvey> lst, int id) {
    return List.generate(
      lst.length,
      (index) => questionItem(lst[index].type, index, lst, id + index),
    );
  }

  void hienthiQuestion(List<QuestionSurvey> lst, int id) {
    for (int i = 0; i < lst.length; i++) {
      questionHienThi[id + 1 + i] = lst[i].id;
    }
    _readData();

    for (int j = 0; j < lstAnswers.length; j++) {
      questionHienThi
          .removeWhere((key, value) => value == lstAnswers[j].questionId);
      isChecked = questionHienThi.isEmpty;
    }
    notifyListeners();
  }

  void addQuestion(int id, int questionId) {
    questionHienThi[id + 1] = questionId;
    isChecked = false;
    notifyListeners();
  }

  void removeQuestion(int questionId) {
    for (int i = 0; i < questionHienThi.length; i++) {
      if (questionHienThi.values.toList()[i] == questionId) {
        questionHienThi.removeWhere((key, value) => value == questionId);
      }
    }
    isChecked = questionHienThi.isEmpty;
    notifyListeners();
  }

  ///xử lý type của câu hỏi
  void checkSlider(List<OptionAnswer> lst, int soluong, int questionId) {
    for (int i = 0; i < lstAnswers.length; i++) {
      if (lstAnswers[i].questionId == questionId) {
        lstAnswers.removeAt(i);
      }
    }
    if (lst.length == soluong) {
      removeQuestion(questionId);
    }
    lstAnswers.add(Answers(questionId: questionId, options: lst));

    notifyListeners();
  }

  void checkRadio(List<OptionAnswer> lst, int questionId) {
    for (int i = 0; i < lstAnswers.length; i++) {
      if (lstAnswers[i].questionId == questionId) {
        lstAnswers.removeAt(i);
      }
    }
    removeQuestion(questionId);
    lstAnswers.add(Answers(questionId: questionId, options: lst));

    notifyListeners();
  }

  void checkArea(List<OptionAnswer> lst, int questionId) {
    for (int i = 0; i < lstAnswers.length; i++) {
      if (lstAnswers[i].questionId == questionId) {
        lstAnswers.removeAt(i);
      }
    }
    removeQuestion(questionId);
    lstAnswers.add(Answers(questionId: questionId, options: lst));
    notifyListeners();
  }

  ///xử lý button chuyển page
  void checkButton() {
    if (isChecked) {
      if (check < 3) {
        isChecked = false;
      }
      if (check <= 3) {
        check++;
      } else {
        Navigator.of(context).pop();
      }
      if (check == 2) {
        questionHienThi = {};
        hienthiQuestion(dataSurvey.partTwo, dataSurvey.partOne.length);
        for (int j = 0; j < lstAnswers.length; j++) {
          questionHienThi
              .removeWhere((key, value) => value == lstAnswers[j].questionId);
        }
        isChecked = questionHienThi.isEmpty;
      }
      if (check == 3) {
        questionHienThi = {};
        hienthiQuestion(dataSurvey.partThree,
            dataSurvey.partOne.length + dataSurvey.partTwo.length);
        isChecked = questionHienThi.isEmpty;
      }

      if (check == 4) {
        surveyAnswers =
            SurveyAnswers(surveyId: dataSurvey.id, answers: lstAnswers);
        _removeData();
        surveyAnswer();
      }
      _scrollController.animateTo(0.0,
          duration: const Duration(microseconds: 1000), curve: Curves.ease);
    }
    notifyListeners();
  }

  void _readData() async {
    final data = await SharedPreferences.getInstance();
    String? list = data.getString('data');

    if (list!.isEmpty) {
      lstAnswers = [];
    } else {
      var lstdata = json.decode(list) as List<dynamic>;
      lstAnswers = lstdata.map((e) => Answers.fromJson(e)).toList();
    }
  }

  void _writeData(List<Answers> lst) async {
    final data = await SharedPreferences.getInstance();
    data.setString('data', json.encode(lst));
    notifyListeners();
  }

  void _removeData() async {
    final data = await SharedPreferences.getInstance();
    data.setString('data', json.encode([]));
    notifyListeners();
  }
}
