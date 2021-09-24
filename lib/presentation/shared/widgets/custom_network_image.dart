import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projects/domain/controllers/images_controller.dart';
import 'package:projects/internal/locator.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double height;
  final double width;
  final defaultImage;

  const CustomNetworkImage({
    Key key,
    @required this.image,
    this.defaultImage,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<ImagesController>().getHeaders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircleAvatar(
              backgroundColor:
                  Get.theme.colors().bgDescription.withOpacity(0.4));
        return CachedNetworkImage(
            imageUrl: locator<ImagesController>().getImagePath(image),
            httpHeaders: snapshot.data,
            fit: fit,
            height: height,
            width: width,
            placeholder: (_, __) =>
                defaultImage ??
                CircleAvatar(
                    backgroundColor:
                        Get.theme.colors().bgDescription.withOpacity(0.4)),
            errorWidget: (_, __, ___) =>
                defaultImage ??
                CircleAvatar(
                    backgroundColor:
                        Get.theme.colors().bgDescription.withOpacity(0.4)));
      },
    );
  }
}
