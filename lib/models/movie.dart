import 'package:hive/hive.dart';

part 'movie.g.dart'; // Akan menghasilkan file movie.g.dart saat build_runner dijalankan

@HiveType(typeId: 0) // typeId harus unik, bisa disesuaikan
class Movie {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String? releaseDate;

  @HiveField(5)
  final double voteAverage;

  @HiveField(6)
  bool isFavorite; // Menambahkan status isFavorite

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    this.releaseDate,
    required this.voteAverage,
    this.isFavorite = false, // Default isFavorite adalah false
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'isFavorite': isFavorite,
    };
  }
}
