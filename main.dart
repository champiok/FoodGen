import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spoon/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodGen',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF010E18, {
          50: Color(0xFFE0F2F1),
          100: Color(0xFFB2DFDB),
          200: Color(0xFF80CBC4),
          300: Color(0xFF4DB6AC),
          400: Color(0xFF26A69A),
          500: Color(0xFF009688),
          600: Color(0xFF00897B),
          700: Color(0xFF00796B),
          800: Color(0xFF00695C),
          900: Color(0xFF004D40),
        }),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => MyHomePage(title: 'FoodGen Home'),
        '/recipeDetails': (context) => RecipeDetailsPage(),
        '/login': (context) => LoginScreen(), 
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<dynamic> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(
      Uri.parse('https://api.spoonacular.com/recipes/random?number=10&apiKey=d73f6315ce544b6bbfed948d3b360d92'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> fetchedRecipes = jsonData['recipes'];
      if (fetchedRecipes != null) {
        setState(() {
          recipes = fetchedRecipes;
        });
      } else {
        // Handle null response
        print('Recipes data is null');
      }
    } else {
      // Handle HTTP error
      print('Failed to load recipes. Status code: ${response.statusCode}');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _navigateToRecipeDetails(BuildContext context, dynamic recipe) {
    Navigator.pushNamed(
      context,
      '/recipeDetails',
      arguments: recipe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe['title']),
            subtitle: Text(recipe['sourceName']),
            leading: Image.network(recipe['image']),
            onTap: () {
              _navigateToRecipeDetails(context, recipe);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dynamic recipe = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recipe Title: ${recipe['title']}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Source Name: ${recipe['sourceName']}',
              style: TextStyle(fontSize: 18),
            ),
            Image.network(recipe['image']),
            SizedBox(height: 20),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: (recipe['extendedIngredients'] as List<dynamic>).map((ingredient) {
                return Text(
                  '- ${ingredient['originalString']}',
                  style: TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
            // Add more recipe details here
          ],
        ),
      ),
    );
  }
}
