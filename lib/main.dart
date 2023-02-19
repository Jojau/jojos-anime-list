import 'package:flutter/material.dart';
import 'package:malapp/Screens/details.dart';
import 'package:malapp/Screens/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => const HomeScreen(),
      AnimeDetailsScreen.routeName: (context) => const AnimeDetailsScreen()
      },
    theme: ThemeData(
      fontFamily: 'NewRodinMedium',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 12.0),
      ),
    ),
  ));
}
