import 'package:desi_shopping_seller/model/youtube_video_model.dart';
import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    youtubeVideoUrl.text = widget.video.videoUrl!;
    youtubeVideoTitle.text = widget.video.title!;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YoutubeVideoPlayerProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              spacing: size.height * 0.02,
              children: [
                CustomTextFormField(
                  hintText: "Video Url",
                  controller: youtubeVideoUrl,
                ),
                CustomTextFormField(
                  hintText: "Video Title",
                  controller: youtubeVideoTitle,
                ),
                const Spacer(),
                SizedBox(
                  height: size.height * 0.07,
                  width: size.width * 1,
                  child: CustomElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      final bool isSuccess = await provider.updateVideoDetails(
                        context: context,
                        id: widget.video.id.toString(),
                        title: youtubeVideoTitle.text,
                        videoUrl: youtubeVideoUrl.text,
                      );
                      if (isSuccess && context.mounted) {
                        Navigator.pop(context);
                        setState(() => isLoading = false);
                      }
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
                SizedBox(
                  height: size.height * 0.07,
                  width: size.width * 1,
                  child: CustomElevatedButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      final bool isSuccess = await provider.deleteYoutubeVideo(
                        context: context,
                        id: widget.video.id.toString(),
                      );
                      if (isSuccess && context.mounted) {
                        Navigator.pop(context);
                        setState(() => isLoading = false);
                      }
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
            if (isLoading)
              Container(
                height: size.height * 1,
                width: size.width * 1,
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
