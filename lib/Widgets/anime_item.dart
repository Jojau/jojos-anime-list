import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:malapp/Models/anime.dart';
import 'package:malapp/Screens/details.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AnimeItem extends StatefulWidget {
  const AnimeItem({
    super.key,
    required this.animeId,
    required this.storage
  });
  final int animeId;
  final FavoriteAnimesStorage storage;

  @override
  State<AnimeItem> createState() => _AnimeItemState();
}

Future<Anime> fetchAnimeDetails(int animeId) async {
  var headers = {'X-MAL-CLIENT-ID': dotenv.env['X-MAL-CLIENT-ID']!};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://api.myanimelist.net/v2/anime/$animeId?fields=title,main_picture,start_date,num_episodes,average_episode_duration,broadcast'));

  request.headers.addAll(headers);

  http.StreamedResponse streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return Anime.fromJson(jsonResponse);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

class _AnimeItemState extends State<AnimeItem> {
  bool _isFavorited = false;
  List<int> _favoriteAnimes = [];

  void _toggleFavorite() {
    widget.storage.readFavoriteAnimes().then((favoriteAnimes) {
      setState(() {
        _favoriteAnimes = favoriteAnimes;

        if (_isFavorited) {
          // S'il était favori, alors il ne l'est plus :
          _favoriteAnimes.remove(widget.animeId);
        } else {
          // S'il n'était pas favori, il le devient :
          _favoriteAnimes.add(widget.animeId);
        }
        widget.storage.writeFavoriteAnimes(_favoriteAnimes);
        _isFavorited = !_isFavorited;
      });
    });
  }

  late Future<Anime> futureAnime;
  @override
  void initState() {
    super.initState();
    futureAnime = fetchAnimeDetails(widget.animeId);

    widget.storage.readFavoriteAnimes().then((favoriteAnimes) {
      setState(() {
        _favoriteAnimes = favoriteAnimes;
        _isFavorited = _favoriteAnimes.contains(widget.animeId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureAnime,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: SizedBox(
                        width: 100,
                        child: Image(
                          image: NetworkImage(snapshot.data!.main_picture),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.title,
                              style:
                                  const TextStyle(fontFamily: 'NewRodinBold')),
                          const Divider(),
                          Text('Commence le ${snapshot.data!.start_date}',
                              style: const TextStyle(fontSize: 12)),
                          Text(
                              "${snapshot.data!.num_episodes} ${snapshot.data!.num_episodes == 1 ? "épisode" : "épisodes"} de ${(snapshot.data!.average_episode_duration / 60).round()} minutes",
                              style: const TextStyle(fontSize: 12)),
                          
                          if (snapshot.data!.broadcast != null)
                            Text(
                                "Tous les ${snapshot.data!.broadcast!.day_of_the_week} à ${snapshot.data!.broadcast!.start_time} JST",
                                style: const TextStyle(fontSize: 12)),
                          
                          _isFavorited
                              ? OutlinedButton(
                                  onPressed: _toggleFavorite,
                                  child: const Text('Retirer des favoris',
                                      style: TextStyle(
                                          fontFamily: 'NewRodinBold',
                                          color: Color(0xFF2e51a2))),
                                )
                              : ElevatedButton(
                                  onPressed: _toggleFavorite,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2e51a2)),
                                  child: const Text('Ajouter aux favoris',
                                      style: TextStyle(
                                          fontFamily: 'NewRodinBold')),
                                ),
                          
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AnimeDetailsScreen.routeName,
                                arguments: ScreenArguments(snapshot.data!.id),
                              );
                            },
                            child: const Text('Voir en détails',
                                style: TextStyle(
                                    fontFamily: 'NewRodinBold',
                                    color: Color(0xFF2e51a2))),
                          ),

                          OutlinedButton(
                              onPressed: () {
                                  Share.share("L'anime dont je t'ai parlé, ${snapshot.data!.title} : https://myanimelist.net/anime/${snapshot.data!.id}", subject: snapshot.data!.title);
                              }, 
                              child: const Text("Partager",
                                  style: TextStyle(
                                      fontFamily: 'NewRodinBold',
                                      color: Color(0xFF2e51a2)))
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        });
  }
}
