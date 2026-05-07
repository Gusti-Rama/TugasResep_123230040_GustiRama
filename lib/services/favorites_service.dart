import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/models/recipe.dart';

class FavoritesService {
  static const String boxName = 'favorites';

  static Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeAdapter());
    }
    await Hive.openBox<Recipe>(boxName);
  }

  static Box<Recipe> getFavoritesBox() {
    return Hive.box<Recipe>(boxName);
  }

  static Future<void> addFavorite(Recipe recipe) async {
    final box = getFavoritesBox();
    await box.put(recipe.id, recipe);
  }

  static Future<void> removeFavorite(String recipeId) async {
    final box = getFavoritesBox();
    await box.delete(recipeId);
  }

  static List<Recipe> getAllFavorites() {
    final box = getFavoritesBox();
    return box.values.toList();
  }

  static bool isFavorite(String recipeId) {
    final box = getFavoritesBox();
    return box.containsKey(recipeId);
  }

  static Future<void> clearAllFavorites() async {
    final box = getFavoritesBox();
    await box.clear();
  }
}

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      category: fields[3] as String,
      area: fields[4] as String,
      instructions: fields[5] as String,
      ingredients: List<String>.from(fields[6] as List),
      measures: List<String>.from(fields[7] as List),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer.writeByte(8);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.image);
    writer.writeByte(3);
    writer.write(obj.category);
    writer.writeByte(4);
    writer.write(obj.area);
    writer.writeByte(5);
    writer.write(obj.instructions);
    writer.writeByte(6);
    writer.write(obj.ingredients);
    writer.writeByte(7);
    writer.write(obj.measures);
  }
}
