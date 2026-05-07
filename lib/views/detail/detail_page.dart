import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/services/favorites_service.dart';

class DetailPage extends StatefulWidget {
  final String recipeId;

  const DetailPage({
    super.key,
    required this.recipeId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Recipe> _recipeFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _recipeFuture = ApiService.fetchRecipeDetail(widget.recipeId);
    _checkIfFavorite();
  }

  void _checkIfFavorite() {
    setState(() {
      _isFavorite = FavoritesService.isFavorite(widget.recipeId);
    });
  }

  void _toggleFavorite(Recipe recipe) async {
    if (_isFavorite) {
      await FavoritesService.removeFavorite(recipe.id);
    } else {
      await FavoritesService.addFavorite(recipe);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite
                ? 'Added to favorites'
                : 'Removed from favorites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
        centerTitle: true,
      ),
      body: FutureBuilder<Recipe>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading recipe detail'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _recipeFuture =
                            ApiService.fetchRecipeDetail(widget.recipeId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final recipe = snapshot.data;

          if (recipe == null) {
            return const Center(child: Text('Recipe not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  recipe.image,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _toggleFavorite(recipe),
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Category: ${recipe.category}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Area: ${recipe.area}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Ingredients:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.ingredients.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Text('• '),
                                Expanded(
                                  child: Text(
                                    '${recipe.ingredients[index]} - ${recipe.measures[index]}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        recipe.instructions,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
