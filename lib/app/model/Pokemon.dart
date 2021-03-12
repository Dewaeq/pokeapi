import 'package:PokeAPI/app/model/PokemonSpecies.dart';
import 'package:PokeAPI/app/model/PokemonStat.dart';

class Pokemon {
  String photoUrl;
  String name;
  String speciesName;
  PokemonSpecies species;
  List<String> types = [];
  int id;
  int order;

  /// In decimetres
  int height;

  /// In hectograms
  int weight;

  List<PokemonStat> stats = [];

  Pokemon({
    this.photoUrl,
    this.name,
    this.speciesName,
    this.species,
    this.types,
    this.id,
    this.order,
    this.height,
    this.weight,
  });

  Pokemon.fromData(Map<String, dynamic> data) {
    photoUrl = data['photo_url'];
    name = data['name'];
    speciesName = data['species_name'];
    types = List<String>.from(data['types']);
    id = data['id'];
    order = data['order'];
    height = data['height'];
    weight = data['height'];
    stats = List<PokemonStat>.from(
      data['stats'].map((e) => PokemonStat.fromData(e)),
    );
  }
}
