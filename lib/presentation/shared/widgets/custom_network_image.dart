import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projects/domain/controllers/images_controller.dart';
import 'package:projects/presentation/shared/theme/custom_theme.dart';

// TODO use this for images
class CustomNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double height;
  final double width;

  const CustomNetworkImage({
    Key key,
    @required this.image,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaintingBinding.instance.imageCache.clear();
    return FutureBuilder(
      future: ImagesController.getHeaders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircleAvatar(
              backgroundColor: Theme.of(context)
                  .customColors()
                  .bgDescription
                  .withOpacity(0.4));
        return CachedNetworkImage(
          imageUrl: ImagesController.getImagePath(image),
          httpHeaders: snapshot.data,
          fit: fit,
          height: height,
          width: width,
          placeholder: (context, url) => CircleAvatar(
              backgroundColor: Theme.of(context)
                  .customColors()
                  .bgDescription
                  .withOpacity(0.4)),
        );
      },
    );
  }
}
