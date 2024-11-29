import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:themoviedbapp/providers/favorite_provider.dart';
import 'screens/login_screen.dart';
import 'providers/movie_provider.dart';
import 'storage/user_storage.dart';

void main() async {
  // Inisialisasi Hive
  await Hive.initFlutter();
  await UserStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Awali aplikasi dengan halaman LoginScreen
      home: LoginScreen(),
    );
  }
}
