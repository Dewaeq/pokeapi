import 'package:PokeAPI/app/model/PokemonEvolution.dart';

class PokemonSpecies {
  String name;
  String description;
  int evolutionChainId;

  /// Max is 255
  int baseHappiness;

  /// Max is 255
  int captureRate;

  /// The chance of this Pokémon being female, in eighths; or -1 for genderless
  int genderRate;

  /// Initial hatch counter: one must walk 255 × (hatch_counter + 1) steps
  /// before this Pokémon's egg hatches, unless utilizing bonuses like Flame Body's
  int hatchCounter;

  bool legendary;
  bool mythical;

  List<String> eggGroups = [];
  List<PokemonEvolution> evolutions = [];

  PokemonSpecies.fromData(Map<String, dynamic> data) {
    name = data['name'];
    description = data['description'];
    evolutionChainId = data['evolution_chain_id'];
    baseHappiness = data['base_happiness'];
    captureRate = data['capture_rate'];
    genderRate = data['gender_rate'];
    hatchCounter = data['hatch_counter'];
    legendary = data['is_legendary'];
    mythical = data['is_mythical'];
    eggGroups = List<String>.from(data['egg_groups']);
  }
}
