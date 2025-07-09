import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YoutubeVideosList extends StatefulWidget {
  const YoutubeVideosList({super.key});

  @override
  State<YoutubeVideosList> createState() => _YoutubeVideosListState();
}

class _YoutubeVideosListState extends State<YoutubeVideosList> {
  @override
  void initState() {
    super.initState();
    context.read<YoutubeVideoPlayerProvider>().fetchVideos(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YoutubeVideoPlayerProvider>(context);
    final video = provider.filterVideos;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          itemCount: video.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final videos = video[index];
            return GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.2,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          'https://img.youtube.com/vi/${videos.videoUrl}/0.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    videos.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
