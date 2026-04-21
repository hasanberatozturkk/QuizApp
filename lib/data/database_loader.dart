import 'package:flutter/services.dart';
import 'package:quiz_app/data/database_helper.dart';
import 'package:quiz_app/models/category.dart';
import 'dart:convert';
import 'package:quiz_app/models/questions.dart';

class DatabaseLoader {
  static Future<void> loadDataIfEmpty() async {
    final categoriesControl = await DatabaseHelper.instance.getCategories();
    if (categoriesControl.isEmpty) {
      print('Veritabanı boş...');

      final String response = await rootBundle.loadString(
        'assets/questions.json',
      );
      final data = await jsonDecode(response);
      final categoriestList = data['categories'] as List;
      for (var categoryData in categoriestList) {
        Category category = Category(
          id: categoryData['id'],
          name: categoryData['name'],
        );
        await DatabaseHelper.instance.insertCategory(category);
      }

      final questionsList = data['questions'] as List;
      for (var questionsData in questionsList) {
        String optionsString = jsonEncode(questionsData['options']);
        Question question = Question(
          categoryId: questionsData['categoryId'],
          question: questionsData['question'],
          correctAnswer: questionsData['correctAnswer'],
          options: optionsString,
        );
        await DatabaseHelper.instance.insertQuestion(question);
      }
      print('veriler başarıyla SQLite veritabaına kaydedildi.');
    } else {
      print('veritabanı ztn dolu!');
    }
  }
}
