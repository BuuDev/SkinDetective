import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../survey.dart';

class Survey3 extends StatefulWidget {
  const Survey3({
    Key? key,
  }) : super(key: key);

  @override
  _Survey3PageState createState() => _Survey3PageState();
}

class _Survey3PageState extends State<Survey3> {
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
                surveyLogic.dataSurvey.partThree,
                surveyLogic.dataSurvey.partTwo.length +
                    surveyLogic.dataSurvey.partOne.length),
          );
        },
      ),
    );
  }
}
