import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// Ma classe Anime
class Anime {
  late int id;
  late String title;
  late String main_picture;
  late String start_date;
  late int num_episodes;
  late int average_episode_duration;
  late Broadcast? broadcast;

  bool favorite;

  Anime(this.id, this.title, this.main_picture, this.start_date, this.num_episodes, this.average_episode_duration, [this.broadcast, this.favorite = false]);

  factory Anime.fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat('d/M/y');
    final String startDateFormatted = formatter.format(DateTime.parse(json['start_date']));

    final Broadcast? broadcast = json.containsKey('broadcast') ? Broadcast(daysEnglishToFrench[json['broadcast']['day_of_the_week']]!, json['broadcast']['start_time']) : null;

    return Anime(json['id'], json['title'], json['main_picture']['medium'], startDateFormatted, json['num_episodes'], json['average_episode_duration'], broadcast);
  }
}

// La classe Broadcast qui me sert à l'intérieur du modèle anime
class Broadcast {
  late String day_of_the_week;
  late String start_time;

  Broadcast(this.day_of_the_week, this.start_time);
}

// Un dictionnaire qui me permet de traduire les jours de la semaine, puisque l'API les renvoie en anglais et que je les veux en français.
const daysEnglishToFrench = {
  'monday': "lundi",
  'tuesday': 'mardi',
  'wednesday': 'mercredi',
  'thursday': 'jeudi',
  'friday': 'vendredi',
  'saturday': 'samedi',
  'sunday': 'dimanche',
  'other': '???'
};

// La classe FavoriteAnimeStorage qui me sert à sauvegarder les anime préférés de l'utilisateur dans son appareil.
class FavoriteAnimesStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/FavoriteAnimes.txt');
  }

  Future<List<int>> readFavoriteAnimes() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return json.decode(contents).cast<int>();
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  Future<File> writeFavoriteAnimes(List<int> favoriteAnimes) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$favoriteAnimes');
  }
}
