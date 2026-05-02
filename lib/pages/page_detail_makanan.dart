import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/makanan_model.dart';

class MealDetailScreen extends StatelessWidget {
  final String mealId;
  MealDetailScreen({required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Resep"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<ModelDetailMakanan>(
        future: ApiService().lookupMeal(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat detail."));
          }

          final meal = snapshot.data!.meals[0];
          List<String> ingredients = [];

          for (int i = 1; i <= 20; i++) {
            String? ing = meal['strIngredient$i'];
            String? meas = meal['strMeasure$i'];
            if (ing != null && ing.trim().isNotEmpty) {
              ingredients.add("$ing - $meas");
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        meal['strMealThumb'] ?? '',
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    meal['strMeal'] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Area: ${meal['strArea']} | Kategori: ${meal['strCategory']}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),

                const Divider(height: 40, thickness: 1.5),

                const Text(
                  "Bahan-bahan:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...ingredients.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                )).toList(),

                const SizedBox(height: 30),

                const Text(
                  "Instruksi Memasak:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  meal['strInstructions'] ?? '',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}