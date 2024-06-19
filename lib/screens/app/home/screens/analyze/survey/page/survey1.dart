import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../survey.dart';

class Survey1 extends StatefulWidget {
  const Survey1({
    Key? key,
  }) : super(key: key);

  @override
  _Survey1PageState createState() => _Survey1PageState();
}

class _Survey1PageState extends State<Survey1> {
  @override
  Widget build(BuildContext context) {
    var surveyLogic = context.read<SurveyLogic>();
    return ChangeNotifierProvider.value(
      value: surveyLogic,
      child: Consumer<SurveyLogic>(
        builder: (context, value, child) {
          return Column(
            children: surveyLogic.getListQuestion(
                context, surveyLogic.dataSurvey.partOne, 0),
          );
        },
      ),
    );
  }
}
