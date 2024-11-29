import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;

  const MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MovieDetailScreen(movie: movie),
        ));
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            // Poster Film
            movie.posterPath.isNotEmpty
                ? Image.network(
                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 150,
                  )
                : const SizedBox(
                    width: 100,
                    height: 150,
                    child: Icon(
                      Icons.movie,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),

            const SizedBox(width: 8),

            // Informasi Film
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview.length > 100
                              ? "${movie.overview.substring(0, 100)}..."
                              : movie.overview
                          : "No description available.",
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
