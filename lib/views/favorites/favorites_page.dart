import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:flutter_application_1/services/favorites_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable:
            FavoritesService.getFavoritesBox().listenable(),
        builder: (context, Box<Recipe> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No favorite recipes yet'),
            );
          }

          final favorites = box.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final recipe = favorites[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      recipe.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    recipe.category.isNotEmpty
                        ? recipe.category
                        : 'Recipe',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(context, recipe);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/detail',
                      arguments: recipe.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Favorite'),
        content: Text('Remove "${recipe.name}" from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FavoritesService.removeFavorite(recipe.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from favorites'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
