import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

void moveToNextPageWithFadeAnimations({
  required BuildContext context,
  required Widget route,
}) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 500),
      child: route,
    ),
  );
}

void replaceCurrentPageWithFadeAnimations({
  required BuildContext context,
  required Widget route,
}) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 500),
      child: route,
    ),
  );
}

Future<List<File>> pickListOfImages({required BuildContext context}) async {
  List<File> compressedImages = [];

  try {
    // Ask permission
    var status = await Permission.storage.request(); // For Android < 13
    if (!status.isGranted) {
      status = await Permission.storage.request();
    } else if (status.isPermanentlyDenied) {
      await Permission.storage.request();
    }

    // Pick images
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final tempDir = await getTemporaryDirectory();

      for (XFile pickedFile in pickedFiles) {
        final originalPath = pickedFile.path;
        final extension = path
            .extension(originalPath)
            .toLowerCase(); // .jpg / .png

        // Only allow jpg, jpeg, png
        if (!(extension == '.jpg' ||
            extension == '.jpeg' ||
            extension == '.png')) {
          continue;
        }

        final fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${path.basenameWithoutExtension(originalPath)}$extension";
        final targetPath = path.join(tempDir.path, fileName);

        // Determine compression format
        CompressFormat format = CompressFormat.jpeg;
        if (extension == '.png') {
          format = CompressFormat.png;
        }

        final compressed = await FlutterImageCompress.compressAndGetFile(
          originalPath,
          targetPath,
          quality: 75,
          format: format,
        );

        if (compressed != null) {
          compressedImages.add(File(compressed.path));
        }
      }

      log("Compressed ${compressedImages.length} images");
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  return compressedImages;
}

Future<File?> pickBrandImage({required BuildContext context}) async {
  File? compressedImage;

  try {
    // Request storage permission
    var permission = await Permission.storage.request();

    if (!permission.isGranted) {
      permission = await Permission.storage.request();
    }

    // Pick image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    final originalFile = File(pickedFile.path);
    final extension = path
        .extension(originalFile.path)
        .toLowerCase(); // .jpg/.png
    final tempDir = await getTemporaryDirectory();

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${path.basenameWithoutExtension(originalFile.path)}$extension";
    final targetPath = path.join(tempDir.path, fileName);

    // Set compression format
    CompressFormat format = CompressFormat.jpeg;
    if (extension == '.png') {
      format = CompressFormat.png;
    }

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      originalFile.path,
      targetPath,
      quality: 80,
      format: format,
    );

    if (compressedFile != null) {
      compressedImage = File(compressedFile.path);
    } else {
      compressedImage = originalFile;
    }

    return compressedImage;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
    return null;
  }
}

Future<List<File>> pickMultipleVideos({required BuildContext context}) async {
  List<File> videoFiles = [];
  final picker = ImagePicker();

  try {
    while (true) {
      final XFile? pickedVideo = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 2),
      );

      if (pickedVideo != null && context.mounted) {
        videoFiles.add(File(pickedVideo.path));

        // Ask if the user wants to add more
        bool? addMore = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Add another video?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes"),
              ),
            ],
          ),
        );

        if (addMore != true) break;
      } else {
        break;
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  return videoFiles;
}

showSnackBar({required BuildContext context, required Object e}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(e.toString())));
}
