import 'package:flutter/material.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/widgets/dots_widget/dots_widget.dart';

class PageViewCustomWidget extends StatefulWidget {
  final List<Widget> pages;
  final EDot direction;
  final double? bottom;
  final Color? colorActive;
  final Color? colorInactive;
  final Function(int index)? onPress;
  final void Function(int index)? onChangePage;

  const PageViewCustomWidget({
    Key? key,
    this.pages = const [],
    this.direction = EDot.horizontal,
    this.bottom,
    this.colorActive,
    this.colorInactive,
    this.onPress,
    this.onChangePage,
  }) : super(key: key);

  @override
  _PageViewCustomWidgetState createState() => _PageViewCustomWidgetState();
}

class _PageViewCustomWidgetState extends State<PageViewCustomWidget> {
  final _controller = PageController(viewportFraction: 0.9, initialPage: 1);

  static const _kDuration = Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = const Color.fromARGB(255, 97, 80, 80).withOpacity(0.8);
  late int indexSelected;

  @override
  void initState() {
    super.initState();

    indexSelected = 1;
    _controller.addListener(() {});
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 0 : 50;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.only(top: margin),
      margin: const EdgeInsets.only(bottom: 10),
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    if (widget.onPress != null) {
                      widget.onPress!(pagePosition);
                    }
                  },
                  child: widget.pages[pagePosition]
                  // child: ClipRRect(
                  //   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  //   child: Image.network(
                  //     images[pagePosition],
                  //     // height: active ? 300 : 200,
                  //     fit: BoxFit.fitHeight,
                  //   ),
                  // ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDot() {
    if (widget.direction == EDot.horizontal) {
      return Positioned(
        bottom: widget.bottom ?? 150,
        left: 0.0,
        right: 0.0,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: DotsWidget(
              colorActive: widget.colorActive ?? AppColors.textBlue,
              colorInactive: widget.colorInactive ?? AppColors.textLightBlue,
              direction: widget.direction,
              controller: _controller,
              itemCount: widget.pages.length,
              onPageSelected: (int page) {
                _controller.animateToPage(
                  page,
                  duration: _kDuration,
                  curve: _kCurve,
                );
              },
              indexSelected: indexSelected,
            ),
          ),
        ),
      );
    }
    return Positioned(
      top: 0,
      right: 24,
      bottom: 0,
      child: Center(
        child: SizedBox(
          // color: Colors.grey[800]?.withOpacity(0.5),
          // height: widget.pages.length * 20,
          child: Center(
            child: DotsWidget(
                direction: widget.direction,
                controller: _controller,
                itemCount: widget.pages.length,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: _kDuration,
                    curve: _kCurve,
                  );
                },
                indexSelected: indexSelected),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: _kArrowColor),
      child: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(bottom: widget.pages.length == 1 ? 0 : 40.0),
            child: PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              pageSnapping: true,
              itemCount: widget.pages.length,
              itemBuilder: (BuildContext context, int index) {
                bool active = indexSelected == index;
                return slider(widget.pages, index, active);
              },
              onPageChanged: (page) {
                if (mounted) {
                  setState(() {
                    indexSelected = page;
                  });
                  widget.onChangePage?.call(page);
                }
              },
            ),
          ),
          widget.pages.length == 1 ? const SizedBox() : getDot()
        ],
      ),
    );
  }
}
