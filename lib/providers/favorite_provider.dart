import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/movie.dart';

class FavoritesProvider with ChangeNotifier {
  late Box _favoritesBox;
  Map<String, List<Movie>> _userFavorites = {}; // Data favorit per pengguna

  List<Movie> get favorites {
    final userId = _currentUserId;
    return _userFavorites[userId] ?? [];
  }

  String _currentUserId = '';

  // Inisialisasi Hive
  Future<void> initHive() async {
    _favoritesBox = await Hive.openBox('favorites');
  }

  // Muat data favorit berdasarkan userId
  Future<void> loadFavorites(String userId) async {
    _currentUserId = userId;

    if (!_favoritesBox.containsKey(userId)) {
      _userFavorites[userId] = [];
    } else {
      final List<dynamic> storedMovies = _favoritesBox.get(userId);
      _userFavorites[userId] = storedMovies.cast<Movie>();
    }

    notifyListeners();
  }

  // Menambahkan atau menghapus movie dari daftar favorit
  Future<void> toggleFavorite(Movie movie) async {
    final userId = _currentUserId;

    if (!_userFavorites.containsKey(userId)) {
      _userFavorites[userId] = [];
    }

    if (_userFavorites[userId]!.any((fav) => fav.id == movie.id)) {
      removeFavorite(movie); // Hapus jika sudah ada di favorit
    } else {
      addFavorite(movie); // Tambah jika belum ada
    }

    notifyListeners();
  }

  // Menambah movie ke daftar favorit
  Future<void> addFavorite(Movie movie) async {
    final userId = _currentUserId;

    if (!_userFavorites.containsKey(userId)) {
      _userFavorites[userId] = [];
    }

    _userFavorites[userId]?.add(movie);
    movie.isFavorite = true;

    await _favoritesBox.put(userId, _userFavorites[userId]);
    notifyListeners();
  }

  // Menghapus movie dari daftar favorit
  Future<void> removeFavorite(Movie movie) async {
    final userId = _currentUserId;

    if (_userFavorites[userId] != null) {
      _userFavorites[userId]?.removeWhere((fav) => fav.id == movie.id);
      movie.isFavorite = false;

      await _favoritesBox.put(userId, _userFavorites[userId]);
      notifyListeners();
    }
  }

  // Menghapus semua data favorit
  Future<void> clearFavorites() async {
    _userFavorites.clear();
    await _favoritesBox.clear();
    notifyListeners();
  }
}
