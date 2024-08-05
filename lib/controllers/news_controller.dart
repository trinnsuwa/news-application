import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:news_application/model/main_new_model.dart';
import 'package:news_application/services/call_api.dart';

class NewsController extends GetxController {
  RxList listNews = <MainNewsModel>[].obs;
  RxList savedArticles = <MainNewsModel>[].obs;
  RxInt currentArticleIndex = 0.obs;
  RxString currentTopic = 'latest'.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString? selectedCategory = 'default'.obs;

  late Box<MainNewsModel> savedArticlesBox;
  final NewsService newsService;

  NewsController(this.newsService) {
    savedArticlesBox = Hive.box<MainNewsModel>('savedArticles');
    savedArticles.addAll(savedArticlesBox.values);
  }

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  void fetchArticles() async {
    try {
      isLoading(true);
      errorMessage('');
      listNews.value = await newsService.fetchArticles(currentTopic.value);
      currentArticleIndex(0);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void saveArticle(MainNewsModel article) {
    if (!isArticleSaved(article)) {
      savedArticlesBox.add(article);
      savedArticles.add(article);
    }
  }

  void removeArticle(MainNewsModel article) {
    final index = savedArticles.indexWhere((element) => element.title == article.title);
    if (index != -1) {
      savedArticlesBox.deleteAt(index);
      savedArticles.removeAt(index);
    }
  }

  bool isArticleSaved(MainNewsModel article) {
    return savedArticles.any((element) => element.title == article.title);
  }

  void changeTopic(String topic) {
    if (currentTopic.value == topic) return;
    currentTopic(topic);
    fetchArticles();
  }

  void nextArticle() {
    if (currentArticleIndex.value < listNews.length - 1) {
      currentArticleIndex(currentArticleIndex.value + 1);
    }
  }

  void previousArticle() {
    if (currentArticleIndex.value > 0) {
      currentArticleIndex(currentArticleIndex.value - 1);
    }
  }

  void onCategorySelected(String categoryName) {
      if (selectedCategory?.value == categoryName) {
        selectedCategory?.value = 'default';
      } else {
        selectedCategory?.value = categoryName;
      }
  }
}
