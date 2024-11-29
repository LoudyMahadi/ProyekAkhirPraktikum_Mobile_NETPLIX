import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _latestMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _movies = [];

  List<Movie> get latestMovies => _latestMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;  // Getter untuk upcomingMovies
  List<Movie> get movies => _movies;

  final String _apiKey = '43f9051c4538bb2d4e326a6b1da1898c'; // Ganti dengan API Key yang valid

  // Method untuk mengambil latest movies
  Future<void> fetchLatestMovies() async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/latest?api_key=$_apiKey&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Movie> loadedMovies = [];
      for (var movieData in data['results']) {
        loadedMovies.add(Movie.fromJson(movieData));
      }
      _latestMovies = loadedMovies;
      notifyListeners();
    } else {
      throw Exception('Failed to load latest movies');
    }
  }

  // Method untuk mengambil popular movies
  Future<void> fetchPopularMovies() async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Movie> loadedMovies = [];
      for (var movieData in data['results']) {
        loadedMovies.add(Movie.fromJson(movieData));
      }
      _popularMovies = loadedMovies;
      notifyListeners();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Method untuk mengambil upcoming movies
  Future<void> fetchUpcomingMovies() async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Movie> loadedMovies = [];
      for (var movieData in data['results']) {
        loadedMovies.add(Movie.fromJson(movieData));
      }
      _upcomingMovies = loadedMovies; // Menyimpan upcoming movies
      notifyListeners();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  // Method untuk mencari movie berdasarkan query
  Future<void> searchMovies(String query) async {
    final url = Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Movie> loadedMovies = [];
      for (var movieData in data['results']) {
        loadedMovies.add(Movie.fromJson(movieData));
      }
      _movies = loadedMovies;
      notifyListeners();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
