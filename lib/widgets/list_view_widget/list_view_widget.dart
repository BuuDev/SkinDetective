import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListViewWidget extends StatefulWidget {
  final List<dynamic> list;
  final Function itemBuilder;

  const ListViewWidget({
    Key? key,
    required this.list,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 16);
      },
      itemCount: widget.list.length,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return widget.itemBuilder(context, index);
      },
    );
  }
}
