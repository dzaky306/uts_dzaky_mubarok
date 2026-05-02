import 'dart:convert';

// Model Daftar Masakan
ModelMakanan modelMakananFromJson(String str) => ModelMakanan.fromJson(json.decode(str));

class ModelMakanan {
  List<Meal> meals;
  ModelMakanan({required this.meals});

  factory ModelMakanan.fromJson(Map<String, dynamic> json) => ModelMakanan(
    meals: json["meals"] == null
        ? []
        : List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
  );
}

class Meal {
  String strMeal, strMealThumb, idMeal;
  Meal({required this.strMeal, required this.strMealThumb, required this.idMeal});

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    strMeal: json["strMeal"] ?? "",
    strMealThumb: json["strMealThumb"] ?? "",
    idMeal: json["idMeal"] ?? "",
  );
}

// Model Detail Masakan (Menggunakan Map)
ModelDetailMakanan modelDetailMakananFromJson(String str) => ModelDetailMakanan.fromJson(json.decode(str));

class ModelDetailMakanan {
  List<Map<String, String?>> meals;
  ModelDetailMakanan({required this.meals});

  factory ModelDetailMakanan.fromJson(Map<String, dynamic> json) => ModelDetailMakanan(
    meals: List<Map<String, String?>>.from(json["meals"].map((x) => Map<String, String?>.from(x))),
  );
}

// Model Kategori
class Category {
  final String id, name, thumb;
  Category({required this.id, required this.name, required this.thumb});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['idCategory'],
    name: json['strCategory'],
    thumb: json['strCategoryThumb'],
  );
}