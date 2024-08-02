import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_application/controllers/news_controller.dart';
import 'package:news_application/model/main_new_model.dart';
import 'package:news_application/services/call_api.dart';
import 'home_test.mocks.dart';

@GenerateMocks([NewsService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NewsController newsController;
  late MockNewsService mockNewsService;

  setUpAll(() async {
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.';
      }
      return null;
    });

    mockNewsService = MockNewsService();
    await Hive.initFlutter();
    Hive.registerAdapter(MainNewsModelAdapter());
    await Hive.openBox<MainNewsModel>('savedArticles');
    newsController = NewsController(mockNewsService);
  });

  test('fetchArticles sets listNews correctly on success', () async {
    when(mockNewsService.fetchArticles(any)).thenAnswer((_) async => []);

    newsController.fetchArticles();

    expect(newsController.listNews, []);

    expect(newsController.errorMessage.value, '');
 
    expect(newsController.isLoading.value, true);
  });
  test('fetchArticles sets errorMessage on failure', () async {
    const error = 'Exception: Failed to load articles';

    when(mockNewsService.fetchArticles(any)).thenThrow((error));

    newsController.fetchArticles();

    expect(newsController.errorMessage.value, error);

    expect(newsController.isLoading.value, false);
  });
}
