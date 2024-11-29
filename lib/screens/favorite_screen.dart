import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../models/movie.dart';
// import 'movie_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = context.watch<FavoritesProvider>().favorites;

    if (favoriteMovies.isEmpty) {
      return const Center(
        child: Text(
          'No favorites yet.',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = favoriteMovies[index];
        String imageUrl = movie.posterPath.isNotEmpty
            ? 'https://image.tmdb.org/t/p/w200${movie.posterPath}'
            : 'https://via.placeholder.com/150';

        return Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.movie,
                          size: 150, color: Colors.grey);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(context, movie);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Favorite'),
          content: Text(
              'Are you sure you want to remove "${movie.title}" from favorites?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoritesProvider>().removeFavorite(movie);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildFavoritesPage(BuildContext context) {
  final favoriteMovies = context.watch<FavoritesProvider>().favorites;

  if (favoriteMovies.isEmpty) {
    return const Center(
      child: Text(
        'No favorites yet.',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  return GridView.builder(
    padding: const EdgeInsets.all(8.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.6,
    ),
    itemCount: favoriteMovies.length,
    itemBuilder: (context, index) {
      final movie = favoriteMovies[index];
      String imageUrl = movie.posterPath.isNotEmpty
          ? 'https://image.tmdb.org/t/p/w200${movie.posterPath}'
          : 'https://via.placeholder.com/150';

      return GestureDetector(
        onTap: () {
          // Aksi jika klik pada film, bisa membuka halaman detail film
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[800], // Background color untuk grid item
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.movie,
                        size: 150, color: Colors.grey);
                  },
                ),
              ),
              const SizedBox(height: 5),
              Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () async {
                    // Tampilkan dialog konfirmasi sebelum menghapus
                    bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: const [
                              Icon(Icons.warning, color: Colors.red, size: 30),
                              SizedBox(width: 8),
                              Text(
                                'Confirm Deletion',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          content: const Text(
                            'Are you sure you want to remove this movie from your favorites?',
                            style: TextStyle(color: Colors.black87),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // Tidak hapus
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Hapus
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white,
                        );
                      },
                    );

                    // Jika konfirmasi hapus, lakukan penghapusan
                    if (confirmDelete == true) {
                      context.read<FavoritesProvider>().removeFavorite(movie);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
