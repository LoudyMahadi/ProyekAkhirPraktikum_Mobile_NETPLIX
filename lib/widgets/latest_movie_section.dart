import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../screens/movie_detail_screen.dart';

class LatestMoviesSection extends StatefulWidget {
  const LatestMoviesSection({Key? key}) : super(key: key);

  @override
  _LatestMoviesSectionState createState() => _LatestMoviesSectionState();
}

class _LatestMoviesSectionState extends State<LatestMoviesSection> {
  @override
  void initState() {
    super.initState();
    // Mengambil film terbaru saat screen pertama kali muncul
    Future.microtask(() =>
        Provider.of<MovieProvider>(context, listen: false).fetchLatestMovies());
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final latestMovies = movieProvider.latestMovies;

    if (latestMovies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // Loader saat data masih kosong
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Latest Movies",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: latestMovies.length,
            itemBuilder: (context, index) {
              final movie = latestMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ));
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      movie.posterPath.isNotEmpty
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                              fit: BoxFit.cover,
                              width: 150,
                              height: 200,
                            )
                          : Container(
                              width: 150,
                              height: 200,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.movie,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
