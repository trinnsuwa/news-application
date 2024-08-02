import 'package:hive/hive.dart';

part 'main_new_model.g.dart';

@HiveType(typeId: 0)
class MainNewsModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String snippet;

  @HiveField(2)
  final String? thumbnailUrl;

  @HiveField(3)
  final String fullArticleUrl;

  @HiveField(4)
  final DateTime timestamp;

  MainNewsModel({
    required this.title,
    required this.snippet,
    required this.fullArticleUrl,
    required this.thumbnailUrl,
    required this.timestamp,
  });

  factory MainNewsModel.fromJson(Map<String, dynamic> json) {
    return MainNewsModel(
      title: json['title'],
      snippet: json['snippet'],
      fullArticleUrl: json['newsUrl'],
      thumbnailUrl: json['images']?["thumbnail"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(json['timestamp'])),
    );
  }
  
}