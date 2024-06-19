import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_detective/gen/assets.gen.dart';

enum PlaceHolderType { svg, imageAsset }

class ImageCustom extends StatefulWidget {
  final String? urlImage;

  ///Image assets local khi load url bị lỗi
  final String? placeholder;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Duration? fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final PlaceHolderType placeHolderType;

  /// Skin custom image url
  /// - Error placeholder default là [PlaceHolderType.svg]
  const ImageCustom(
      {Key? key,
      required this.urlImage,
      this.placeholder,
      this.height,
      this.width,
      this.fit,
      this.fadeOutDuration = const Duration(milliseconds: 1000),
      this.fadeOutCurve = Curves.easeOut,
      this.fadeInDuration = const Duration(milliseconds: 500),
      this.fadeInCurve = Curves.easeIn,
      this.placeHolderType = PlaceHolderType.svg})
      : super(key: key);

  @override
  State<ImageCustom> createState() => _ImageCustomState();
}

class _ImageCustomState extends State<ImageCustom> {
  Widget get placeholder {
    if (widget.placeHolderType == PlaceHolderType.svg) {
      return SvgPicture.asset(
        Assets.icons.productPlaceholder,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
      );
    }

    return Assets.images.avatarLogout.image(
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: widget.height,
      width: widget.height,
      fit: widget.fit,
      imageUrl: widget.urlImage ?? '',
      fadeOutDuration: widget.fadeOutDuration,
      fadeOutCurve: widget.fadeOutCurve,
      fadeInDuration: widget.fadeInDuration,
      fadeInCurve: widget.fadeInCurve,
      placeholder: (context, url) => Stack(
        children: const [
          Positioned(
            child: Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
                width: 10,
                height: 10,
              ),
            ),
          ),
        ],
      ),
      errorWidget: (context, url, error) => placeholder,
    );
  }
}
