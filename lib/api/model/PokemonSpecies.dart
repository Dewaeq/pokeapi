import 'package:PokeAPI/api/model/PokemonEvolution.dart';
import 'package:PokeAPI/constants/constants.dart';

class PokemonSpecies {
  String name;

  String description;

  String region;

  int generationId;

  String typeDescription;

  String habitat;

  String growthRate;

  String evolutionChainUrl;

  int evolutionChainId;

  /// Max is 255
  int baseHappiness;

  /// Max is 255
  int baseExperience;

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
        'region': region,
        'generation_id': generationId,
        'type_description': typeDescription,
        'habitat': habitat,
        'growth_rate': growthRate,
        'evolution_chain_id': evolutionChainId,
        'base_happiness': baseHappiness,
        'base_experience': baseExperience,
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
    region = GENERATIONS[data['generation']['name']]['region'];
    generationId = GENERATIONS[data['generation']['name']]['id'];
    typeDescription = data['genera'].firstWhere(
      (e) => e['language']['name'] == 'en',
      orElse: () => null,
    )['genus'];
    growthRate =
        data['growth_rate'] == null ? null : data['growth_rate']['name'];
    habitat = data['habitat'] == null ? null : data['habitat']['name'];
    evolutionChainUrl = data['evolution_chain']['url'];
    baseHappiness = data['base_happiness'];
    baseExperience = data['base_experience'];
    captureRate = data['capture_rate'];
    genderRate = data['gender_rate'];
    hatchCounter = data['hatch_counter'];
    legendary = data['is_legendary'];
    mythical = data['is_mythical'];
    eggGroups = List<String>.from(data['egg_groups'].map((e) => e['name']));
    eggGroups = eggGroups.map((e) {
      if (e == 'no-eggs') return 'unknown';
      return e;
    }).toList();
  }
}
