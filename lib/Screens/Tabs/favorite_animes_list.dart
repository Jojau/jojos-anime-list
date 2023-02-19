import 'dart:io';
import 'package:flutter/material.dart';
import 'package:malapp/Models/anime.dart';
import 'package:malapp/Widgets/anime_item.dart';

class FavoriteAnimesList extends StatefulWidget {
  const FavoriteAnimesList({super.key, required this.storage});

  final FavoriteAnimesStorage storage;

  @override
  State<FavoriteAnimesList> createState() => _FavoriteAnimesListState();
}

class _FavoriteAnimesListState extends State<FavoriteAnimesList> {
  List<int> _favoriteAnimes = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readFavoriteAnimes().then((value) {
      setState(() {
        _favoriteAnimes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "MES FAVORIS",
          style: TextStyle(fontFamily: 'NewRodinBlack', fontSize: 20),
        ),
      ),
      Flexible(
        child: ListView.builder(
          itemCount: _favoriteAnimes.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ListTile(
              title: AnimeItem(animeId: _favoriteAnimes[index], storage: widget.storage),
            );
          },
        )
      ),
    ]);
  }
}
