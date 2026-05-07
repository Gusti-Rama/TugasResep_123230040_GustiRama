import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fetch recipes by category
  static Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['meals'] ?? [];
        return data
            .map((json) => Recipe(
                  id: json['idMeal'] ?? '',
                  name: json['strMeal'] ?? '',
                  image: json['strMealThumb'] ?? '',
                  category: '',
                  area: '',
                  instructions: '',
                  ingredients: [],
                  measures: [],
                ))
            .toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }

  // Fetch recipes by first letter
  static Future<List<Recipe>> fetchRecipesByLetter(String letter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?f=$letter'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        return meals
            .map((json) => Recipe(
                  id: json['idMeal'] ?? '',
                  name: json['strMeal'] ?? '',
                  image: json['strMealThumb'] ?? '',
                  category: '',
                  area: '',
                  instructions: '',
                  ingredients: [],
                  measures: [],
                ))
            .toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }

  // Fetch recipe details by ID
  static Future<Recipe> fetchRecipeDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$id'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        if (meals.isNotEmpty) {
          return Recipe.fromJson(meals[0]);
        } else {
          throw Exception('Recipe not found');
        }
      } else {
        throw Exception('Failed to load recipe detail');
      }
    } catch (e) {
      throw Exception('Error fetching recipe detail: $e');
    }
  }
}
