import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/flip_widget/flip_widget.dart';

// ignore: must_be_immutable
class ImageItemWidget extends StatelessWidget {
  late String? path;

  ImageItemWidget({Key? key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: Helper.percentHeight(pixel: 127, context: context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: path != null
              ? FlipWidget(
                  child: Image.file(
                    File(path!),
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
