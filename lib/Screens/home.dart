import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:malapp/Models/anime.dart';
import 'package:malapp/Screens/Tabs/favorite_animes_list.dart';
import 'package:malapp/Screens/Tabs/seasonal_animes_list.dart';

List<Widget> _tabs = <Widget>[
  const SeasonalAnimesList(),
  FavoriteAnimesList(storage: FavoriteAnimesStorage())
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Build Widget
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jojo's Anime List",
          style: TextStyle(fontFamily: 'RodinNTLG'),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF2e51a2),
      ),

      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child
        ),
        child: _tabs.elementAt(_selectedIndex)
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          )
        ],
        selectedItemColor: const Color(0xFF2e51a2),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, 
      ),
    );
  }
}
