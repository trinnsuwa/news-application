import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:news_application/model/main_new_model.dart';
import 'dart:convert';

// MOCK API RESPONSE
// class NewsService {

//  Future<List<MainNewsModel>> fetchArticles(String topic) async {
//     String mockDataPath = 'assets/$topic.json';
//     final response = await rootBundle.loadString(mockDataPath);

//     final data = jsonDecode(response);

//     return (data['items'] as List)
//         .map((json) => MainNewsModel.fromJson(json))
//         .toList();
//   }
// }

class NewsService {
  static const String apiKey = '79c537b425msha1983a183c96248p121180jsnffa7110c1bd8';
  static const String baseUrl = 'https://google-news13.p.rapidapi.com/';

  Future<List<MainNewsModel>> fetchArticles(String topic) async {
    final response = await http.get(
      Uri.parse('$baseUrl$topic?lr=en-US'),
      headers: {
        'X-Rapidapi-Key': apiKey,
        'X-Rapidapi-Host': 'google-news13.p.rapidapi.com',
        'Host': 'google-news13.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['items'] as List)
          .map((json) => MainNewsModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 429) {
      throw ('API limit exceeded');
    } else {
      throw ('Failed to load articles');
    }
  }
}