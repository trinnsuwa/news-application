import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_application/controllers/news_controller.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final Function(String) onSelected;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final NewsController newsController = Get.find<NewsController>();

    return GestureDetector(
      onTap: () {
        onSelected(categoryName);
        if (isSelected) {
          newsController.changeTopic('latest');
        } else {
          newsController.changeTopic(categoryName);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          categoryName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
