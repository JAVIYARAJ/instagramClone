import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonImageWidget extends StatelessWidget {
  final double? radius;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final Widget? errorHolder;
  final String? imageUrl;

  const CommonImageWidget({super.key,this.imageUrl,this.radius,this.width,this.height,this.errorHolder,this.placeholder});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius??50),
      child: CachedNetworkImage(
        fadeInCurve: Curves.ease,
        filterQuality: FilterQuality.high,
        placeholderFadeInDuration: const Duration(seconds: 2),
        fadeOutCurve: Curves.ease,
        width:width?? 30,
        height:height?? 30,
        fit: BoxFit.cover,
        imageUrl: imageUrl ?? "",
        placeholder: (context, url) =>
            placeholder ?? Image.asset("assets/ic_placeholder_icon.png"),
        errorWidget: (context, url, error) => errorHolder?? Image.asset(
         "assets/ic_error_placeholder_icon.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
