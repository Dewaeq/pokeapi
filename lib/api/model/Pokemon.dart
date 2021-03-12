import 'dart:convert';
import 'package:PokeAPI/api/model/PokemonSpecies.dart';
import 'package:PokeAPI/api/model/PokemonStat.dart';

class Pokemon {
  String name;
  String photoUrl;
  String shinyPhotoUrl;
  String speciesName;
  PokemonSpecies species;
  String json_string;
  List<String> types = [];
  int id;
  int order;

  /// In decimetres
  int height;

  /// In hectograms
  int weight;

  List<PokemonStat> stats = [];
  List<Map<String, dynamic>> abilities = [];

  Pokemon({
    this.photoUrl,
    this.name,
    this.speciesName,
    this.species,
    this.json_string,
    this.types,
    this.id,
    this.order,
    this.height,
    this.weight,
  });

  Map<String, dynamic> toJson() => {
        'photo_url': photoUrl,
        'shiny_photo_url': shinyPhotoUrl,
        'name': name,
        'species_name': speciesName,
        'types': types,
        'id': id,
        'order': order,
        'height': height,
        'weight': weight,
        'species': species.toJson(),
        'stats': stats.map((e) => e.toJson()).toList(),
        'abilities': abilities,
      };

  Pokemon.fromData(Map<String, dynamic> data) {
    photoUrl = data['sprites']['other']['official-artwork']['front_default'] ??
        data['sprites']['front_default'];
    name = data['name'];
    json_string = jsonEncode(data);
    for (var k in data['types']) {
      types.add(k['type']['name']);
    }
    id = data['id'];
    order = data['order'];
    height = data['height'];
    weight = data['weight'];
    speciesName = data['species']['name'];
    stats = List<PokemonStat>.from(
      data['stats'].map((e) => PokemonStat.fromData(e)),
    );
    abilities = List<Map<String, dynamic>>.from(data['abilities'].map(
      (e) => <String, dynamic>{
        'name': e['ability']['name'],
        'slot': e['slot'],
        'is_hidden': e['is_hidden'],
      },
    ));
  }
}
