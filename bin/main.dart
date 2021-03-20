import 'dart:io';
import 'dart:convert';
import 'package:PokeAPI/PokeAPI.dart';
import 'package:PokeAPI/api/model/Pokemon.dart';
import 'package:PokeAPI/api/model/PokemonAbility.dart';
import 'package:dart_console/dart_console.dart';

Map<String, bool> filters = {
  'verbose': false,
  'include_abilities': false,
  'include_evolutions': false,
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
      } else if (arg.contains('-evolutions')) {
        filters['include_evolutions'] = true;
      } else {
        throw ('Argument $arg not found. Please try again');
      }
    }
  }
}

Future<void> init() async {
  if (filters['verbose']) {
    evolutionFile =
        await File('./output/all_evolutions.json').create(recursive: true);
    abilityFile =
        await File('./output/all_abilities.json').create(recursive: true);
  } else {
    if (filters['include_evolutions']) {
      evolutionFile =
          await File('./output/all_evolutions.json').create(recursive: true);
    }
    if (filters['include_abilities']) {
      abilityFile =
          await File('./output/all_abilities.json').create(recursive: true);
    }
  }
  speciesFile = await File('./output/all_species.json').create(recursive: true);
  pokemonFile = await File('./output/all_pokemon.json').create(recursive: true);
  api.init(includeEvolutions: filters['include_evolutions']);
}

void main(List<String> arguments) async {
  handleArgs(arguments);
  await init();

  if (filters['include_abilities']) {
    abilities = await api.getAllPokemonAbilities();
  }
  pokemons = await api.getAllPokemonInRange(min: min, max: max);

  pokemons.sort((a, b) => a.order.compareTo(b.order));

  console.writeLine('applying filters...');
  if (filters['include_abilities']) {
    console.writeLine('processing abilities');
    for (var ability in abilities) {
      abilityData[ability.name] = ability.toJson();
    }
  }
  console.writeLine('processing pokemon');

  for (var pokemon in pokemons) {
    pokemonData[pokemon.name] = pokemon.toJson();
    pokemonData[pokemon.name].remove('species');
    speciesData[pokemon.speciesName] = pokemon.species.toJson();

    if (filters['include_evolutions']) {
      evolutionData['${pokemon.species.evolutionChainId}'] =
          pokemon.species.evolutions.map((e) => e.toJson()).toList();
    }
  }
  console.writeLine('saving data...');
  await save();
  console.writeLine('done!');
}

Future<void> save() async {
  await pokemonFile.writeAsString(jsonEncode(pokemonData));
  await speciesFile.writeAsString(jsonEncode(speciesData));
  if (filters['include_evolutions']) {
    await evolutionFile.writeAsString(jsonEncode(evolutionData));
  }
  if (filters['include_abilities']) {
    await abilityFile.writeAsString(jsonEncode(abilityData));
  }
}
