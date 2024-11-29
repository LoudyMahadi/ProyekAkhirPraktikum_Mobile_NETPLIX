// import 'package:shared_preferences/shared_preferences.dart';

// class FavoriteHelper {
//   static const String _keyFavorites = 'favorite_movies';

//   // Menyimpan ID film favorit
//   static Future<void> saveFavoriteMovies(List<int> movieIds) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setStringList(_keyFavorites, movieIds.map((id) => id.toString()).toList());
//   }

//   // Mengambil daftar ID film favorit
//   static Future<List<int>> getFavoriteMovies() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? storedIds = prefs.getStringList(_keyFavorites);
//     return storedIds?.map((id) => int.parse(id)).toList() ?? [];
//   }

//   // Menghapus data favorit
//   static Future<void> clearFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(_keyFavorites);
//   }
// }
