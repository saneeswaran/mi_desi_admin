import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class YoutubeVideoModel {
  String? id;
  String? title;
  String? videoUrl;
  YoutubeVideoModel({this.id, this.title, this.videoUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'title': title, 'videoUrl': videoUrl};
  }

  factory YoutubeVideoModel.fromMap(Map<String, dynamic> map) {
    return YoutubeVideoModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory YoutubeVideoModel.fromJson(String source) =>
      YoutubeVideoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
