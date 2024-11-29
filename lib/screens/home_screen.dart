import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movie_detail_screen.dart';
import '../providers/movie_provider.dart';
import 'favorite_screen.dart';
import 'team_profile_screen.dart'; // Tambahkan import baru
import '../providers/favorite_provider.dart';
import '../storage/user_storage.dart'; // Untuk akses userId
import '../models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Ambil userId dan load data favorit
    Future.microtask(() async {
      final String? userId = UserStorage.getUserId();
      if (userId != null) {
        await context.read<FavoritesProvider>().initHive();
        await context.read<FavoritesProvider>().loadFavorites(userId);
      }

      // Fetch movies
      context.read<MovieProvider>().fetchUpcomingMovies();
      context.read<MovieProvider>().fetchPopularMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(context),
      const FavoritesScreen(),
      const TeamProfileScreen(), // Tambahkan halaman Team Profile
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('NETPLIX', style: TextStyle(color: Colors.red)),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem( // Tambahkan item baru
            icon: Icon(Icons.group),
            label: 'Team Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSearchBar(),
        ),  
        Expanded(
          child: Consumer<MovieProvider>(builder: (context, movieProvider, _) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildSlider(movieProvider.upcomingMovies, 'Upcoming Movies'),
                  const SizedBox(height: 15),
                  _buildMovieGrid(movieProvider.popularMovies.take(12).toList(),
                      'Popular Movies'),
                  const SizedBox(height: 20),
                  _buildSearchResults(movieProvider),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search Movies',
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            final query = _searchController.text.trim();
            if (query.isNotEmpty) {
              context.read<MovieProvider>().searchMovies(query);
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSearchResults(MovieProvider movieProvider) {
    final searchResults = movieProvider.movies;

    if (searchResults.isEmpty) {
      return _searchController.text.isEmpty
          ? const SizedBox.shrink()
          : const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'No movies found.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Results',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final movie = searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildMovieItem(movie),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(List<Movie> movies, String title) {
    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildMovieItem(movie),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieGrid(List<Movie> movies, String title) {
    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: movies.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _buildMovieItem(movie);
          },
        ),
      ],
    );
  }

  Widget _buildMovieItem(Movie movie) {
    String imageUrl = movie.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w200${movie.posterPath}'
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.movie, size: 150, color: Colors.grey);
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
            top: 8,
            right: 8,
            child: Consumer<FavoritesProvider>(builder: (context, favoritesProvider, _) {
              final isFavorite = favoritesProvider.favorites.contains(movie);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(movie);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
