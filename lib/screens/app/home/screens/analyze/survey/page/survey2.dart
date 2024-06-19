import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../survey.dart';

class Survey2 extends StatefulWidget {
  const Survey2({
    Key? key,
  }) : super(key: key);

  @override
  _Survey2PageState createState() => _Survey2PageState();
}

class _Survey2PageState extends State<Survey2> {
  @override
  Widget build(BuildContext context) {
    var surveyLogic = context.read<SurveyLogic>();
    return ChangeNotifierProvider.value(
      value: surveyLogic,
      child: Consumer<SurveyLogic>(
        builder: (context, value, child) {
          return Column(
            children: surveyLogic.getListQuestion(
                context,
                surveyLogic.dataSurvey.partTwo,
                surveyLogic.dataSurvey.partOne.length),
          );
        },
      ),
    );
  }
}
