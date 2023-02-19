import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:malapp/Models/anime.dart';
import 'package:malapp/Widgets/anime_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SeasonalAnimesList extends StatefulWidget {
  const SeasonalAnimesList({super.key});

  @override
  State<SeasonalAnimesList> createState() => _SeasonalAnimesListState();
}

Future<List> fetchSeasonalAnimes() async {
  var headers = {'X-MAL-CLIENT-ID': dotenv.env['X-MAL-CLIENT-ID']!};
  var request = http.Request('GET',
      Uri.parse('https://api.myanimelist.net/v2/anime/season/2023/winter'));

  request.headers.addAll(headers);

  http.StreamedResponse streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body)['data'];
    return jsonResponse;
  } else {
    throw Exception(response.reasonPhrase);
  }
}

class _SeasonalAnimesListState extends State<SeasonalAnimesList> {
  late Future<List> futureSeasonalAnimesList;

  @override
  void initState() {
    super.initState();
    futureSeasonalAnimesList = fetchSeasonalAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "HIVER 2023",
          style: TextStyle(fontFamily: 'NewRodinBlack', fontSize: 20),
        ),
      ),
      Flexible(
        child: FutureBuilder<List>(
            future: futureSeasonalAnimesList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: AnimeItem(animeId: snapshot.data![index]['node']['id'], storage: FavoriteAnimesStorage(),),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          ),
      ),
    ]);
  }
}
