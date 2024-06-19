import 'package:flutter/material.dart'
    show StatefulWidget, ChangeNotifier, BuildContext, protected, State, Widget;
import 'package:provider/provider.dart';

///Sử dụng cho mục đích đóng gói view model và giao diện.
///- Hộ trợ tạo view model từ 1 widget
///- Truy xuất logic từ widget
///- Tự động dispose view model
mixin LogicState<T extends StatefulWidget, E extends ChangeNotifier>
    on State<T> {
  late E _viewModel;

  @protected
  E initViewModel(BuildContext context);

  E get logic => _viewModel;

  @override
  void initState() {
    _viewModel = initViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<E>.value(
      value: _viewModel,
      child: buildWidget(context),
    );
  }

  ///Thay thế cho build method
  @protected
  Widget buildWidget(BuildContext context);

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
