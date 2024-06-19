import 'package:flutter/material.dart';
import 'package:skin_detective/widgets/logic_widget/logic_widget.dart';

part 'view_model.dart';

class TestLogicWidget extends StatefulWidget {
  const TestLogicWidget({Key? key}) : super(key: key);

  @override
  State<TestLogicWidget> createState() => _TestLogicWidgetState();
}

class _TestLogicWidgetState extends State<TestLogicWidget> with LogicState<TestLogicWidget, LogicViewModel> {
  @override
  Widget buildWidget(BuildContext context) {
    return Text('This is value in view model logic: ${logic.title}');
  }

  @override
  LogicViewModel initViewModel(BuildContext context) {
    return LogicViewModel(context);
  }
}