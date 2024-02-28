import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(FOODGeNApp());
}

class FOODGeNApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodGen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => RecipeListScreen(),
        // Add more routes as needed
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              // Add validation logic here (e.g., validator)
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              // Add validation logic here (e.g., validator)
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the forgot password screen
                // Implement this route as needed
              },
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;
  TextEditingController ingredientsController = TextEditingController();

  static const String apiKey = ' 11775279883c4685915ff70114eaaae0';
  static const String baseApiUrl = 'https://spoonacular.com/food-api';

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes({String? ingredients}) async {
    try {
      final url = ingredients != null
          ? '$baseApiUrl?apiKey=$apiKey&ingredients=$ingredients'
          : '$baseApiUrl?apiKey=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          recipes = data.map((json) => Recipe.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        // Display error message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching recipes: ${response.statusCode}'),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Display error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception fetching recipes: $e'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Generator')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ingredientsController,
                    decoration: InputDecoration(
                      labelText: 'Enter Ingredients',
                      prefixIcon: Icon(Icons.shopping_cart),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    fetchRecipes(ingredients: ingredientsController.text);
                  },
                  child: Text('Generate Recipes'),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return ListTile(
                        title: Text(recipe.title),
                        subtitle: Text(recipe.description),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Recipe {
  final String title;
  final String description;

  Recipe({required this.title, required this.description});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
    );
  }
}
class Ingredient {
  final int id;
  final double? amount; // Nullable type
  final String? unit; // Nullable type
  final String? unitLong; // Nullable type
  final String? unitShort; // Nullable type
  final String aisle;
  final String name;
  final String original;
  final String? originalName; // Nullable type
  final List<String>? meta; // Nullable type
  final String? extendedName; // Nullable type
  final String? image; // Nullable type

  Ingredient({
    required this.id,
    this.amount, // Nullable
    this.unit, // Nullable
    this.unitLong, // Nullable
    this.unitShort, // Nullable
    required this.aisle,
    required this.name,
    required this.original,
    this.originalName, // Nullable
    this.meta, // Nullable
    this.extendedName, // Nullable
    this.image, // Nullable
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      amount: json['amount']?.toDouble(), // Nullable with safe call
      unit: json['unit'] as String?, // Nullable with type casting
      unitLong: json['unitLong'] as String?, // Nullable with type casting
      unitShort: json['unitShort'] as String?, // Nullable with type casting
      aisle: json['aisle'],
      name: json['name'],
      original: json['original'],
      originalName: json['originalName'] as String?, // Nullable with type casting
      meta: json['meta'] != null ? List<String>.from(json['meta']) : null, // Handle null
      extendedName: json['extendedName'] as String?, // Nullable with type casting
      image: json['image'] as String?, // Nullable with type casting
    );
  }
}

