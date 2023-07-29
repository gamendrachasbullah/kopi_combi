import 'package:flutter/material.dart';

class ImageUrl extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  const ImageUrl(
      {super.key,
      required this.url,
      this.width = 120,
      this.height = 120,
      this.fit = BoxFit.cover});
  @override
  Widget build(BuildContext context) {
    return Image.network(
      url.replaceAll('localhost:8080', '192.168.1.17:8080'),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
