import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedbapp/providers/favorite_provider.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.favorites.contains(widget.movie);

    String imageUrl = widget.movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
        : '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.movie.title,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(  // Menambahkan Center untuk memastikan konten terpusat
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),  // Menambahkan padding atas untuk memberi jarak
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,  // Memastikan kolom tetap di tengah
              children: [
                // Poster Film
                GestureDetector(
                  onTap: () {
                    if (imageUrl.isNotEmpty) {
                      _showFullImage(imageUrl);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: 300,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 300,
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: 300,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                  Icons.movie,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Informasi Film dalam Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul Film
                          Text(
                            widget.movie.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Deskripsi Film
                          Text(
                            widget.movie.overview.isNotEmpty
                                ? widget.movie.overview
                                : "No description available.",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),

                          // Informasi Tambahan
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.movie.releaseDate ?? "Unknown",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${widget.movie.voteAverage}/10",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      favoritesProvider.toggleFavorite(widget.movie);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isFavorite),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    label: Text(
                      isFavorite ? "Remove from Favorites" : "Add to Favorites",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: isFavorite ? Colors.redAccent : Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), 
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
