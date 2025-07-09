import 'package:desi_shopping_seller/model/youtube_video_model.dart';
import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EditYoutubeVideos extends StatefulWidget {
  final YoutubeVideoModel video;
  const EditYoutubeVideos({super.key, required this.video});

  @override
  State<EditYoutubeVideos> createState() => _EditYoutubeVideosState();
}

class _EditYoutubeVideosState extends State<EditYoutubeVideos> {
  final youtubeVideoUrl = TextEditingController();
  final youtubeVideoTitle = TextEditingController();
  bool isLoading = false;

  YoutubePlayerController? _controller;
  String? videoId;

  @override
  void initState() {
    super.initState();
    youtubeVideoUrl.text = widget.video.videoUrl ?? '';
    youtubeVideoTitle.text = widget.video.title ?? '';
    youtubeVideoUrl.addListener(_loadYoutubeVideo);

    // Preload video if valid
    _loadYoutubeVideo();
  }

  void _loadYoutubeVideo() {
    final id = YoutubePlayer.convertUrlToId(youtubeVideoUrl.text.trim());
    if (id != null && id != videoId) {
      setState(() {
        videoId = id;
        _controller = YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false,
            hideControls: false,
            controlsVisibleAtStart: true,
            showLiveFullscreenButton: true,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    youtubeVideoUrl.removeListener(_loadYoutubeVideo);
    youtubeVideoUrl.dispose();
    youtubeVideoTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YoutubeVideoPlayerProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit YouTube Video")),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (videoId != null && _controller != null)
                      YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.red,
                          bottomActions: [
                            const SizedBox(width: 14),
                            const CurrentPosition(),
                            const SizedBox(width: 8),
                            const ProgressBar(isExpanded: true),
                            const SizedBox(width: 8),
                            const RemainingDuration(),
                          ],
                        ),
                        builder: (context, player) => Column(
                          children: [player, const SizedBox(height: 20)],
                        ),
                      ),
                    CustomTextFormField(
                      hintText: "Video Url",
                      controller: youtubeVideoUrl,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: "Video Title",
                      controller: youtubeVideoTitle,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: size.height * 0.07,
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          final bool isSuccess = await provider
                              .updateVideoDetails(
                                context: context,
                                id: widget.video.id.toString(),
                                title: youtubeVideoTitle.text,
                                videoUrl: youtubeVideoUrl.text,
                              );
                          if (isSuccess && context.mounted) {
                            Navigator.pop(context);
                          }
                          setState(() => isLoading = false);
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: size.height * 0.07,
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          final bool isSuccess = await provider
                              .deleteYoutubeVideo(
                                context: context,
                                id: widget.video.id.toString(),
                              );
                          if (isSuccess && context.mounted) {
                            Navigator.pop(context);
                          }
                          setState(() => isLoading = false);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                height: size.height,
                width: size.width,
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
