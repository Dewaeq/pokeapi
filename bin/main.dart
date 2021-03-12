import 'dart:io';
import 'dart:convert';
import 'package:PokeAPI/PokeAPI.dart';
import 'package:PokeAPI/api/model/Pokemon.dart';
import 'package:PokeAPI/api/model/PokemonAbility.dart';
import 'package:dart_console/dart_console.dart';

Map<String, bool> filters = {
  'verbose': false,
  'include_abilities': false,
  'include_forms': false,
  'include_game_indices': false,
  'include_held_items': false,
  'include_moves': false,
  'include_species': false,
  'include_sprites': false,
  'include_stats': false,
  'include_types': false,
};

File pokemonFile;
File speciesFile;
File evolutionFile;
File abilityFile;
final api = PokeAPI();
final console = Console();

int min = 0;
int max = 10000;

var pokemonData = <String, dynamic>{};
var speciesData = <String, dynamic>{};
var evolutionData = <String, dynamic>{};
var abilityData = <String, dynamic>{};

List<Pokemon> pokemons = [];
List<PokemonAbility> abilities = [];

void handleArgs(List<String> arguments) {
  if (arguments.isNotEmpty) {
    for (var arg in arguments) {
      if (arg.contains('-r')) {
        try {
          var args = arguments[0]
              .replaceAll('-r', '')
              .split('-')
              .map(int.parse)
              .toList();
          if (args.length < 2) {
            throw ('''Please enter a valid range, with the starting position as 
          \nthe first argument and the amount of pokemon as the second. ex: -r10-40\n''');
          }
          min = args[0];
          max = args[1];
        } on Exception {
          throw ('''Please enter a valid range, with the starting position as 
          \nthe first argument and the amout of pokemon as the second. ex: -r10-40\n''');
        }
      } else if (arg.contains('-v')) {
        filters['verbose'] = true;
        filters.updateAll((key, value) => true);
      } else if (arg.contains('-abilities')) {
        filters['include_abilities'] = true;
      } else if (arg.contains('-forms')) {
        filters['include_forms'] = true;
      } else if (arg.contains('-indices')) {
        filters['include_game_indices'] = true;
      } else if (arg.contains('-items')) {
        filters['include_held_items'] = true;
      } else if (arg.contains('-moves')) {
        filters['include_moves'] = true;
      } else if (arg.contains('-species')) {
        filters['include_species'] = true;
      } else if (arg.contains('-sprites')) {
        filters['include_sprites'] = true;
      } else if (arg.contains('-stats')) {
        filters['include_stats'] = true;
      } else if (arg.contains('-types')) {
        filters['include_types'] = true;
      } else {
        throw ('Argument $arg not found. Please try again');
      }
    }
  }
}

Future<void> init() async {
  if (filters['verbose']) {
    pokemonFile = await File('./ouput/all_pokemon_with_data.json')
        .create(recursive: true);
  } else {
    pokemonFile =
        await File('./output/all_pokemon.json').create(recursive: true);
  }
  speciesFile = await File('./output/all_species.json').create(recursive: true);
  evolutionFile =
      await File('./output/all_evolutions.json').create(recursive: true);
  abilityFile =
      await File('./output/all_abilities.json').create(recursive: true);

  api.init();
}

void main(List<String> arguments) async {
  handleArgs(arguments);
  await init();

//   if (filters['include_abilities']) {
  abilities = await api.getAllPokemonAbilities();
//   }
  pokemons = await api.getAllPokemonInRange(min: min, max: max);

  pokemons.sort((a, b) => a.order.compareTo(b.order));

  console.writeLine('applying filters...');
  console.writeLine('processing abilities');
  for (var ability in abilities) {
    abilityData[ability.name] = ability.toJson();
  }
  console.writeLine('processing pokemon');

  for (var pokemon in pokemons) {
    pokemonData[pokemon.name] = pokemon.toJson();
    pokemonData[pokemon.name].remove('species');
    speciesData[pokemon.speciesName] = pokemon.species.toJson();

    evolutionData['${pokemon.species.evolutionChainId}'] =
        pokemon.species.evolutions.map((e) => e.toJson()).toList();

    /* Map<String, dynamic> d = jsonDecode(pokemon.json_string);
    var a = d;

    if (!filters['verbose']) {
      a['photo_url'] = pokemon.photo_url;
      a['url'] = '$BASE_URL/pokemon/${pokemon.id}';
      a['hp_stat'] = d['stats'][0]['base_stat'];
      a['at_stat'] = d['stats'][1]['base_stat'];
      a['def_stat'] = d['stats'][2]['base_stat'];
      a['spec_at_stat'] = d['stats'][3]['base_stat'];
      a['spec_def_stat'] = d['stats'][4]['base_stat'];
      a['speed_stat'] = d['stats'][5]['base_stat'];
      a['species_info'] = pokemon.species;
      a.remove('base_experience');
      a.remove('location_area_encounters');
      a.remove('past_types');
    }
    List<dynamic> t = d['types'];
    a['types'] = <String>[];

    for (int i = 0; i < t.length; i++) {
      a['types'].add(t[i]['type']['name']);
    }

    if (!filters['include_abilities']) a.remove('abilities');

    if (!filters['include_forms']) a.remove('forms');

    if (!filters['include_game_indices']) a.remove('game_indices');

    if (!filters['include_held_items']) a.remove('held_items');

    if (!filters['include_moves']) a.remove('moves');

    if (!filters['include_species']) a.remove('species');

    if (!filters['include_sprites']) a.remove('sprites');

    if (!filters['include_stats']) a.remove('stats');

    // if (!filters['include_types']) a.remove('types');

    data[pokemon.name] = a; */
  }
  console.writeLine('saving data...');
  await save();
  console.writeLine('done!');
}

Future<void> save() async {
  await pokemonFile.writeAsString(jsonEncode(pokemonData));
  await speciesFile.writeAsString(jsonEncode(speciesData));
  await evolutionFile.writeAsString(jsonEncode(evolutionData));
  await abilityFile.writeAsString(jsonEncode(abilityData));
}
