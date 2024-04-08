import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(IngredientScreen());
}

class IngredientScreen extends StatefulWidget {
  @override
  _IngredientScreenState createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final TextEditingController _controller = TextEditingController();
  late Future<RecipeInformation> _futureRecipeInformation;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _futureRecipeInformation = fetchRecipeInformation(
        1); // Initially fetch recipe information for recipe ID 1
  }

  Future<RecipeInformation> fetchRecipeInformation(int recipeId) async {
    final url =
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=800fad2c8b12472198d0a3421f5a76a4';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['image'] != null) {
        setState(() {
          _imageUrl = data['image'];
        });
      }
      return RecipeInformation.fromJson(data);
    } else {
      throw Exception('Failed to load recipe information');
    }
  }

  void fetchRecipe(int recipeId) {
    setState(() {
      _futureRecipeInformation = fetchRecipeInformation(recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Information',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Recipe Information'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter Recipe ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  fetchRecipe(int.parse(value));
                  _controller.clear();
                },
              ),
            ),
            _imageUrl != null
                ? Container(
                    height: MediaQuery.of(context).size.height *
                        0.3, // Adjust the height as needed
                    child: Image.network(
                      _imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            Expanded(
              child: FutureBuilder<RecipeInformation>(
                future: _futureRecipeInformation,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${snapshot.data!.title}'),
                          SizedBox(height: 8),
                          Text(
                              'Ready in Minutes: ${snapshot.data!.readyInMinutes}'),
                          SizedBox(height: 8),
                          Text('Servings: ${snapshot.data!.servings}'),
                          SizedBox(height: 8),
                          Text(
                              'Cuisines: ${snapshot.data!.cuisines.join(', ')}'),
                          SizedBox(height: 8),
                          Text(
                              'Dish Types: ${snapshot.data!.dishTypes.join(', ')}'),
                          SizedBox(height: 8),
                          Text('Diets: ${snapshot.data!.diets.join(', ')}'),
                          SizedBox(height: 8),
                          Text('Instructions: ${snapshot.data!.instructions}'),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeInformation {
  final int id;
  final String title;
  final String? image;
  final int readyInMinutes;
  final int servings;
  final List<String> cuisines;
  final List<String> dishTypes;
  final List<String> diets;
  final String instructions;

  RecipeInformation({
    required this.id,
    required this.title,
    this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.cuisines,
    required this.dishTypes,
    required this.diets,
    required this.instructions,
  });

  factory RecipeInformation.fromJson(Map<String, dynamic> json) {
    return RecipeInformation(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      cuisines: List<String>.from(json['cuisines']),
      dishTypes: List<String>.from(json['dishTypes']),
      diets: List<String>.from(json['diets']),
      instructions: json['instructions'],
    );
  }
}
