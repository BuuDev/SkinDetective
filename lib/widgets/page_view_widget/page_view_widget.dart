import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/constants/type_globals.dart';
import 'package:skin_detective/providers/tut_camera/tut_camera_provider.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/widgets/dots_widget/dots_widget.dart';

class PageViewWidget extends StatefulWidget {
  final List<Widget> pages;
  final EDot? direction;
  final double? bottom;
  final Color? colorActive;
  final Color? colorInactive;

  const PageViewWidget({
    Key? key,
    this.pages = const [],
    this.direction = EDot.horizontal,
    this.bottom,
    this.colorActive,
    this.colorInactive,
  }) : super(key: key);

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  late TutCameraProvider _tutCameraProvider;

  final _controller = PageController();

  static const _kDuration = Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = const Color.fromARGB(255, 97, 80, 80).withOpacity(0.8);
  late ValueNotifier<int> indexSelected;

  @override
  void initState() {
    super.initState();

    indexSelected = ValueNotifier(0);
    _tutCameraProvider = context.read<TutCameraProvider>();
    _tutCameraProvider.addListener(onListener);
  }

  void onListener() {
    debugPrint("In File: page_view_widget.dart, Line: 52 NEXT EK ");
    if (_tutCameraProvider.ePageState == EPageState.next &&
        indexSelected.value < widget.pages.length) {
      _controller.animateToPage(
        indexSelected.value + 1,
        duration: _kDuration,
        curve: _kCurve,
      );
    }

    if (_tutCameraProvider.ePageState == EPageState.previous &&
        indexSelected.value > 0) {
      _controller.animateToPage(
        indexSelected.value - 1,
        duration: _kDuration,
        curve: _kCurve,
      );
    }
  }

  Widget getDot() {
    if (widget.direction == EDot.horizontal) {
      return ValueListenableBuilder<int>(
          valueListenable: indexSelected,
          builder: (context, index, _) {
            return Positioned(
              bottom:
                  widget.bottom ?? MediaQuery.of(context).size.height * 0.15,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: DotsWidget(
                    colorActive: widget.colorActive ?? AppColors.textBlue,
                    colorInactive:
                        widget.colorInactive ?? AppColors.textLightBlue,
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
                    indexSelected: index,
                  ),
                ),
              ),
            );
          });
    }
    return ValueListenableBuilder<int>(
        valueListenable: indexSelected,
        builder: (context, index, _) {
          return Positioned(
            top: 0,
            right: 24,
            bottom: 0,
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
                indexSelected: index,
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _tutCameraProvider.removeListener(onListener);
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: _kArrowColor),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: widget.pages.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.pages[index];
              },
              onPageChanged: (page) {
                if (mounted) {
                  indexSelected.value = page;
                }
              },
            ),
          ),
          getDot()
        ],
      ),
    );
  }
}
