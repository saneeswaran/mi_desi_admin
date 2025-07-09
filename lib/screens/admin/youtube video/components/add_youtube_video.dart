import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:desi_shopping_seller/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddYoutubeVideo extends StatefulWidget {
  const AddYoutubeVideo({super.key});

  @override
  State<AddYoutubeVideo> createState() => _AddYoutubeVideoState();
}

class _AddYoutubeVideoState extends State<AddYoutubeVideo> {
  final youtubeVideoUrl = TextEditingController();
  final youtubeVideoTitle = TextEditingController();
  bool isLoading = false;

  YoutubePlayerController? _controller;
  String? videoId;

  @override
  void initState() {
    super.initState();
    youtubeVideoUrl.addListener(_updateVideoIdFromUrl);
  }

  void _updateVideoIdFromUrl() {
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
            showLiveFullscreenButton: false,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    youtubeVideoUrl.removeListener(_updateVideoIdFromUrl);
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
        appBar: AppBar(title: const Text("Add YouTube Video")),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: size.width,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        builder: (context, player) {
                          return Column(
                            children: [player, const SizedBox(height: 20)],
                          );
                        },
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
                              .addYoutubeVideos(
                                context: context,
                                title: youtubeVideoTitle.text,
                                videoUrl: youtubeVideoUrl.text,
                              );

                          if (isSuccess && context.mounted) {
                            youtubeVideoUrl.clear();
                            youtubeVideoTitle.clear();
                            Navigator.pop(context);
                          }

                          setState(() => isLoading = false);
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    height: size.height * 1,
                    width: size.width * 1,
                    color: Colors.black26,
                    child: const Center(child: Loader()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
