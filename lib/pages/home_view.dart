import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_application/constant/colors.dart';
import 'package:news_application/constant/text_style.dart';
import 'package:news_application/controllers/news_controller.dart';
import 'package:news_application/model/main_new_model.dart';
import 'package:news_application/services/call_api.dart';
import 'package:news_application/widgets/category_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedCategory = 'default';

  void _onCategorySelected(String categoryName) {
    setState(() {
      if (selectedCategory == categoryName) {
        selectedCategory = null;
      } else {
        selectedCategory = categoryName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final NewsController newsController =
        Get.put(NewsController(NewsService()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Application'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            if (newsController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (newsController.errorMessage.value.isNotEmpty) {
              return Center(child: Text(newsController.errorMessage.value));
            }

            if (newsController.listNews.isEmpty) {
              return const Center(child: Text('No articles available'));
            }

            final MainNewsModel article = newsController
                .listNews[newsController.currentArticleIndex.value];

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Category News',
                      style: filterButtonStyle,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...[
                        'latest',
                        'entertainment',
                        'world',
                        'business',
                        'health',
                        'sport',
                        'science',
                        'technology'
                      ].map((category) => CategoryTile(
                            categoryName: category,
                            isSelected: selectedCategory == category,
                            onSelected: _onCategorySelected,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        article.title,
                        style: headlineStyle,
                      ),
                    ),
                    Obx(() => IconButton(
                      icon: Icon(
                        newsController.isArticleSaved(article)
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined,
                      ),
                      onPressed: () {
                        if (newsController.isArticleSaved(article)) {
                          newsController.removeArticle(article);
                        } else {
                          newsController.saveArticle(article);
                        }
                      },
                    )),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                    onTap: () async {
                      if (await canLaunchUrl(
                          Uri.parse(article.fullArticleUrl))) {
                        await launchUrl(Uri.parse(article.fullArticleUrl));
                      } else {
                        throw 'Could not launch ${article.fullArticleUrl}';
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(article.thumbnailUrl ?? '',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.contain),
                    )),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat('dd MMM yyyy HH:mm').format(article.timestamp),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  article.snippet,
                  style: snippetStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: newsController.previousArticle,
                      child: const Text(
                        'Previous',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: newsController.nextArticle,
                      child: const Text(
                        'Next',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
