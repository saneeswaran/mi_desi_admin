import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String e;
  const PhotoViewPage({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        color: Colors.white,
        child: PhotoView(imageProvider: CachedNetworkImageProvider(e)),
      ),
    );
  }
}
