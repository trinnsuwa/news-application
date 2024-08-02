import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:news_application/constant/text_style.dart';
import 'package:news_application/controllers/news_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedArticlesView extends StatelessWidget {
  const SavedArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsController newsController = Get.find<NewsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
      ),
      body: Obx(() {
        if (newsController.savedArticles.isEmpty) {
          return const Center(child: Text('No saved articles'));
        }

        return ListView.builder(
          itemCount: newsController.savedArticles.length,
          itemBuilder: (context, index) {
            final article = newsController.savedArticles[index];
            return Slidable(
              
              direction: Axis.horizontal,
              dragStartBehavior: DragStartBehavior.down,
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (context) => newsController.removeArticle(article),
                    label: 'Delete',
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(article.fullArticleUrl))) {
                    await launchUrl(Uri.parse(article.fullArticleUrl));
                  } else {
                    throw 'Could not launch ${article.fullArticleUrl}';
                  }
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(article.thumbnailUrl ?? ''),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        article.title,
                        style: headlineStyle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
