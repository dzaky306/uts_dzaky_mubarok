import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/makanan_model.dart';

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['categories'];
      return data.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat kategori');
  }

  Future<ModelMakanan> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    return modelMakananFromJson(response.body);
  }

  Future<ModelMakanan> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    return modelMakananFromJson(response.body);
  }

  Future<ModelDetailMakanan> lookupMeal(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    return modelDetailMakananFromJson(response.body);
  }
}