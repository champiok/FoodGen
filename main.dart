import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Recipe>> fetchRecipes() async {
  final response = await http.get(Uri.parse('https://api.spoonacular.com/recipes/findByIngredients?ingredients=apples,+flour,+sugar&number=2&apiKey=d73f6315ce544b6bbfed948d3b360d92'));

  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    return List<Recipe>.from(l.map((model) => Recipe.fromJson(model)));
  } else {
    throw Exception('Failed to load recipes');
  }
}

class Recipe {
  final int id;
  final String title;
  final String? image; // Nullable type
  final String? imageType; // Nullable type
  final int usedIngredientCount;
  final int missedIngredientCount;
  final List<Ingredient> missedIngredients;
  final List<Ingredient> usedIngredients;
  final List<Ingredient> unusedIngredients;
  final int likes;

  Recipe({
    required this.id,
    required this.title,
    this.image, // Nullable
    this.imageType, // Nullable
    required this.usedIngredientCount,
    required this.missedIngredientCount,
    required this.missedIngredients,
    required this.usedIngredients,
    required this.unusedIngredients,
    required this.likes,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'] as String?, // Nullable with type casting
      imageType: json['imageType'] as String?, // Nullable with type casting
      usedIngredientCount: json['usedIngredientCount'],
      missedIngredientCount: json['missedIngredientCount'],
      missedIngredients: List<Ingredient>.from(json['missedIngredients'].map((x) => Ingredient.fromJson(x))),
      usedIngredients: List<Ingredient>.from(json['usedIngredients'].map((x) => Ingredient.fromJson(x))),
      unusedIngredients: List<Ingredient>.from(json['unusedIngredients'].map((x) => Ingredient.fromJson(x))),
      likes: json['likes'],
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


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Recipe>>(
            future: futureRecipes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
