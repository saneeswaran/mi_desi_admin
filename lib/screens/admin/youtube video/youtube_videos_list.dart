import 'package:cached_network_image/cached_network_image.dart';
import 'package:desi_shopping_seller/constants/constants.dart';
import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/screens/admin/youtube%20video/components/add_youtube_video.dart';
import 'package:desi_shopping_seller/screens/admin/youtube%20video/components/edit_youtube_videos.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        elevation: 0.0,
        shape: const CircleBorder(),
        onPressed: () => moveToNextPageWithFadeAnimations(
          context: context,
          route: const AddYoutubeVideo(),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.backgroundImages),
            fit: BoxFit.cover,
          ),
        ),
        child: video.isEmpty
            ? const Center(
                child: Text(
                  "No videos found.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            : GridView.builder(
                itemCount: video.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final videos = video[index];

                  // Extract the YouTube video ID from the full URL
                  final videoId = YoutubePlayer.convertUrlToId(
                    videos.videoUrl ?? '',
                  );

                  return GestureDetector(
                    onTap: () => moveToNextPageWithFadeAnimations(
                      context: context,
                      route: EditYoutubeVideos(video: videos),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height * 0.2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                            image: videoId != null
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      'https://img.youtube.com/vi/$videoId/0.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: videoId == null
                              ? const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          videos.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
