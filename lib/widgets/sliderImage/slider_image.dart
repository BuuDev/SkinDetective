import 'package:flutter/material.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

import '../../theme/color.dart';

class SliderImage extends StatefulWidget {
  const SliderImage({
    Key? key,
    required this.lstImage,
  }) : super(key: key);

  final List<String> lstImage;

  @override
  State<SliderImage> createState() => _SliderImageState();
}

class _SliderImageState extends State<SliderImage> {
  ValueNotifier<int> indexImage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (widget.lstImage.isNotEmpty) {
          showDialog(
              barrierColor: const Color(0xff000000).withOpacity(0.8),
              context: context,
              builder: (_) {
                return Scaffold(
                  backgroundColor: AppColors.transparent,
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: AppColors.transparent,
                    centerTitle: true,
                    title: ValueListenableBuilder(
                        valueListenable: indexImage,
                        builder: (_, value, __) {
                          return Text(
                            '${indexImage.value + 1} / ${widget.lstImage.length}',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: AppColors.backgroundColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          );
                        }),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.backgroundColor,
                          ))
                    ],
                    leading: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.transparent,
                    ),
                  ),
                  body: GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: InteractiveViewer(
                              minScale: 0.1,
                              maxScale: 2,
                              child: PageView(
                                onPageChanged: (index) {
                                  indexImage.value = index;
                                },
                                scrollDirection: Axis.horizontal,
                                children: List.generate(widget.lstImage.length,
                                    (index) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.lstImage[index]))));
                                }),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(widget.lstImage.length, (index) {
                            return ValueListenableBuilder(
                                valueListenable: indexImage,
                                builder: (_, value, __) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, top: 8),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: indexImage.value == index
                                          ? AppColors.primary
                                          : AppColors.white,
                                    ),
                                  );
                                });
                          }),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              });
        }
      },
      child: widget.lstImage.length < 2
          ? Container(
              width: double.infinity,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageCustom(
                  urlImage: widget.lstImage.isEmpty ? '' : widget.lstImage[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: widget.lstImage.isEmpty ? 300 : null,
                ),
              ),
            )
          : widget.lstImage.length == 2
              ? Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageCustom(
                          urlImage: widget.lstImage[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 23,
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageCustom(
                          urlImage: widget.lstImage[1],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                )
              : widget.lstImage.length == 3
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ImageCustom(
                              urlImage: widget.lstImage[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 23,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: size / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageCustom(
                                    urlImage: widget.lstImage[1],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 23,
                            ),
                            Expanded(
                              child: Container(
                                height: size / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageCustom(
                                    urlImage: widget.lstImage[2],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : widget.lstImage.length > 3
                      ? Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageCustom(
                                  urlImage: widget.lstImage[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 23,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: size / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.transparent,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ImageCustom(
                                        urlImage: widget.lstImage[1],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 23,
                                ),
                                Expanded(
                                  child: Container(
                                    height: size / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.transparent,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ImageCustom(
                                        urlImage: widget.lstImage[2],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 23,
                                ),
                                Expanded(
                                  child: Container(
                                      height: size / 4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.lstImage[3]),
                                              fit: BoxFit.cover,
                                              opacity: 0.6)),
                                      child: Center(
                                        child: Text(
                                          widget.lstImage.length > 4
                                              ? '${widget.lstImage.length}+'
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ],
                        )
                      : null,
    );
  }
}
