import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/makanan_model.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatelessWidget {
  final String categoryName;
  MealListScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName),
        backgroundColor: Colors.orange,),
      body: FutureBuilder<ModelMakanan>(
        future: ApiService().fetchMealsByCategory(categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final listMeals = snapshot.data!.meals;
          return ListView.builder(
            itemCount: listMeals.length,
            itemBuilder: (context, index) {
              final meal = listMeals[index];
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(meal.strMealThumb)),
                title: Text(meal.strMeal),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (c) => MealDetailScreen(mealId: meal.idMeal),
                )),
              );
            },
          );
        },
      ),
    );
  }
}