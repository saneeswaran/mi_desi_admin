import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desi_shopping_seller/model/youtube_video_model.dart';
import 'package:desi_shopping_seller/util/util.dart';
import 'package:flutter/material.dart';

class YoutubeVideoPlayerProvider extends ChangeNotifier {
  List<YoutubeVideoModel> _allVideos = [];
  List<YoutubeVideoModel> _filterVideos = [];
  List<YoutubeVideoModel> get allVideos => _allVideos;
  List<YoutubeVideoModel> get filterVideos => _filterVideos;

  Future<List<YoutubeVideoModel>> fetchVideos({
    required BuildContext context,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('youtubeVideos');
      final QuerySnapshot querySnapshot = await collectionReference.get();
      _allVideos = querySnapshot.docs
          .map(
            (e) => YoutubeVideoModel.fromMap(e.data() as Map<String, dynamic>),
          )
          .toList();
      _filterVideos = _allVideos;
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return _allVideos;
  }

  Future<bool> addYoutubeVideos({
    required BuildContext context,
    required String title,
    required String videoUrl,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('youtubeVideos');
      final docref = collectionReference.doc();
      final YoutubeVideoModel youtubeVideoModel = YoutubeVideoModel(
        id: docref.id,
        title: title,
        videoUrl: videoUrl,
      );
      await docref.set(youtubeVideoModel.toMap());
      _allVideos.add(youtubeVideoModel);
      _filterVideos = _allVideos;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> deleteYoutubeVideo({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('youtubeVideos');
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(id)
          .get();
      if (documentSnapshot.exists) {
        await documentSnapshot.reference.delete();
      }
      _allVideos.removeWhere((e) => e.id == id);
      _filterVideos = _allVideos;
      notifyListeners();
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }

  Future<bool> updateVideoDetails({
    required BuildContext context,
    required String id,
    required String videoUrl,
    required String title,
  }) async {
    try {
      final CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('youtubeVideos');
      final YoutubeVideoModel videoModel = YoutubeVideoModel(
        title: title,
        videoUrl: videoUrl,
      );
      final DocumentSnapshot documentSnapshot = await collectionReference
          .doc(id)
          .get();

      if (documentSnapshot.exists) {
        await documentSnapshot.reference.update(videoModel.toMap());
        final int index = _allVideos.indexWhere((e) => e.id == id);
        if (index != -1) {
          _allVideos[index] = videoModel;
          _filterVideos = _allVideos;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, e: e);
      }
    }
    return false;
  }
}
