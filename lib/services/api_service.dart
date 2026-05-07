import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/filter.php?c=$category'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['meals'] ?? [];
        return data
            .map(
              (json) => Recipe(
                id: json['idMeal'] ?? '',
                name: json['strMeal'] ?? '',
                image: json['strMealThumb'] ?? '',
                category: '',
                area: '',
                instructions: '',
                ingredients: [],
                measures: [],
              ),
            )
            .toList();
      } else {
        throw Exception('Gagal memuat resep');
      }
    } catch (e) {
      throw Exception('Gagal mengambil resep: $e');
    }
  }

  static Future<List<Recipe>> fetchRecipesByMultipleCategories(
    List<String> categories,
  ) async {
    try {
      final Iterable<Future<List<Recipe>>> futures = categories.map(
        (category) => fetchRecipesByCategory(category),
      );

      final List<List<Recipe>> results = await Future.wait(futures);

      return results.expand((recipes) => recipes).toList();
    } catch (e) {
      throw Exception('Gagal mengambil beberapa kategori: $e');
    }
  }

  static Future<Recipe> fetchRecipeDetail(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/lookup.php?i=$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        if (meals.isNotEmpty) {
          return Recipe.fromJson(meals[0]);
        } else {
          throw Exception('Resep tidak ditemukan');
        }
      } else {
        throw Exception('Gagal memuat detail resep');
      }
    } catch (e) {
      throw Exception('Gagal mengambil detail resep: $e');
    }
  }
}
