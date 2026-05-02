import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/makanan_model.dart';
import 'meal_list_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Category>> _futureCategories;
  ModelMakanan? _searchResponse;
  bool _isSearching = false;
  bool _isLoadingSearch = false;

  @override
  void initState() {
    super.initState();
    _futureCategories = _apiService.fetchCategories();
  }

  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() { _isSearching = false; _searchResponse = null; });
      return;
    }
    setState(() { _isSearching = true; _isLoadingSearch = true; });
    final response = await _apiService.searchMeals(query);
    setState(() { _searchResponse = response; _isLoadingSearch = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Makanan"),
        backgroundColor: Colors.orange,
        leading: _isSearching
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _searchResponse = null;
            });
          },
        )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari masakan...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch("");
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: _onSearch,
            ),
          ),
        ),
      ),
      body: _isSearching ? _buildSearchList() : _buildCategoryGrid(),
    );
  }

  Widget _buildCategoryGrid() {
    return FutureBuilder<List<Category>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final cat = snapshot.data![index];
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (c) => MealListScreen(categoryName: cat.name),
              )),
              child: Card(
                child: Column(
                  children: [
                    Expanded(child: Image.network(cat.thumb)),
                    Padding(padding: const EdgeInsets.all(8), child: Text(cat.name)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchList() {
    if (_isLoadingSearch) return const Center(child: CircularProgressIndicator());
    if (_searchResponse == null || _searchResponse!.meals.isEmpty) {
      return const Center(child: Text("Maaf, masakan tidak ditemukan."));
    }
    return ListView.builder(
      itemCount: _searchResponse!.meals.length,
      itemBuilder: (context, index) {
        final meal = _searchResponse!.meals[index];
        return ListTile(
          leading: Image.network(meal.strMealThumb, width: 50),
          title: Text(meal.strMeal),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (c) => MealDetailScreen(mealId: meal.idMeal),
            ));
          },
        );
      },
    );
  }
}