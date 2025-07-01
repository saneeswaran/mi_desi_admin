import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';
import 'video_dialog_player.dart';

class VideoGridView extends StatelessWidget {
  final List<String> videoUrls;
  const VideoGridView({super.key, required this.videoUrls});

  Future<Uint8List?> getThumbnail(String url) async {
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: videoUrls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 videos per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final url = videoUrls[index];
          return FutureBuilder<Uint8List?>(
            future: getThumbnail(url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final thumbnail = snapshot.data;
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => VideoDialogPlayer(videoUrl: url),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: thumbnail != null
                      ? Image.memory(thumbnail, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.videocam)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
