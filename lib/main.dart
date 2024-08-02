import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_application/model/main_new_model.dart';
import 'package:news_application/pages/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MainNewsModelAdapter());
  await Hive.openBox<MainNewsModel>('savedArticles');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
