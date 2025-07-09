import 'package:desi_shopping_seller/providers/youtube_video_player_provider.dart';
import 'package:desi_shopping_seller/widgets/custom_elevated_button.dart';
import 'package:desi_shopping_seller/widgets/custom_text_form_field.dart';
import 'package:desi_shopping_seller/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddYoutubeVideo extends StatefulWidget {
  const AddYoutubeVideo({super.key});

  @override
  State<AddYoutubeVideo> createState() => _AddYoutubeVideoState();
}

class _AddYoutubeVideoState extends State<AddYoutubeVideo> {
  final youtubeVideoUrl = TextEditingController();
  final youtubeVideoTitle = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<YoutubeVideoPlayerProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: size.height * 1,
        width: size.width * 1,
        child: Stack(
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
                      final bool isSuccess = await provider.addYoutubeVideos(
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
    );
  }
}
