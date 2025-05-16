import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:issue/core/widgets/shimmer.dart';

class CacheImageWidget extends StatelessWidget {
  const CacheImageWidget({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit,
    this.widgetLoading,
    this.isCircleShimmer = false,
    this.tagHero,
    this.errorWidget,
  });
  final String url;

  final String? tagHero;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isCircleShimmer;
  final Widget? widgetLoading;
  final Widget? errorWidget;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return tagHero != null ? Hero(tag: tagHero!, child: contentBody(size)) : contentBody(size);
      },
    );
  }

  CachedNetworkImage contentBody(Size size) {
    return CachedNetworkImage(
      placeholder: (context, url) =>
          widgetLoading ??
          CustomShimmer(
            height: height ?? size.height,
            width: width ?? size.width,
            isCircle: false,
          ),
      errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
    );
  }

  Function(BuildContext, String) placeholderWidgetFn() {
    return (_, s) => placeholderWidget();
  }

  Widget placeholderWidget() {
    return Container(color: Colors.grey.withValues(alpha: 0.1));
  }
}
