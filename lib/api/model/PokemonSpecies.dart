import 'package:PokeAPI/api/model/PokemonEvolution.dart';

class PokemonSpecies {
  String name;

  String description;

  String generation;

  String habitat;

  String growthRate;

  String evolutionChainUrl;

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

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'generation': generation,
        'habitat': habitat,
        'growth_rate': growthRate,
        'evolution_chain_id': evolutionChainId,
        'base_happiness': baseHappiness,
        'gender_rate': genderRate,
        'capture_rate': captureRate,
        'hatch_counter': hatchCounter,
        'is_legendary': legendary,
        'is_mythical': mythical,
        'egg_groups': eggGroups,
      };

  PokemonSpecies.fromData(Map<String, dynamic> data) {
    name = data['name'];
    var des = data['flavor_text_entries'].firstWhere(
      (e) => e['language']['name'] == 'en' && e['version']['name'] == 'sword',
      orElse: () => data['flavor_text_entries'].firstWhere(
        (e) => e['language']['name'] == 'en',
        orElse: () => null,
      ),
    );
    description = des['flavor_text'].replaceAll('\n', ' ');
    generation = data['genera'].firstWhere(
      (e) => e['language']['name'] == 'en',
      orElse: () => null,
    )['genus'];
    growthRate =
        data['growth_rate'] == null ? null : data['growth_rate']['name'];
    habitat = data['habitat'] == null ? null : data['habitat']['name'];
    eggGroups = List<String>.from(data['egg_groups'].map((e) => e['name']));
    evolutionChainUrl = data['evolution_chain']['url'];
    baseHappiness = data['base_happiness'];
    captureRate = data['capture_rate'];
    genderRate = data['gender_rate'];
    hatchCounter = data['hatch_counter'];
    legendary = data['is_legendary'];
    mythical = data['is_mythical'];
    for (var i = 0; i < data['egg_groups'].length; i++) {
      eggGroups.add(data['egg_groups'][i]['name']);
    }
  }
}
