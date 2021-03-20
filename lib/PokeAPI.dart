import 'package:PokeAPI/api/model/Pokemon.dart';
import 'package:PokeAPI/api/model/PokemonAbility.dart';
import 'package:PokeAPI/api/model/PokemonEvolution.dart';
import 'package:PokeAPI/api/model/PokemonSpecies.dart';
import 'package:PokeAPI/constants/constants.dart';
import 'package:dart_console/dart_console.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class PokeAPI {
  final dio = Dio();
  final console = Console();
  bool _includeEvolutions = false;

  void init({bool includeEvolutions}) async {
    _includeEvolutions = includeEvolutions ?? false;
    console.writeLine('initializing');
    dio.options = BaseOptions(responseType: ResponseType.plain);
  }

  Future<Map<String, dynamic>> getPokemonJsonById({@required int index}) async {
    var data = await getPokemonJsonByUrl(url: '$BASE_URL/pokemon/$index');
    return data;
  }

  Future<Map<String, dynamic>> getPokemonJsonByUrl(
      {@required String url, bool recursive = false}) async {
    Response response;
    try {
      response = await dio.get(url);
    } catch (e) {
      /// Sometimes pokeapi gives a 404 when the url ends with a slash,
      /// sometimes they give one when it doesn't, due to some issues they're having
      /// with CloudFlare.
      /// This isn't the most elegant fix but it works
      if (!recursive && url.endsWith('/')) {
        url = url.substring(0, url.length - 1);
        return await getPokemonJsonByUrl(url: url, recursive: true);
      }
      console.writeErrorLine('there was an error :( while handling $url');
      console.writeErrorLine(e.toString());
      return null;
    }
    if (!checkResponse(response)) return null;

    Map<String, dynamic> data = jsonDecode(response.data);
    return data;
  }

  Future<Pokemon> getPokemonById({@required int index}) async {
    var data = await getPokemonJsonById(index: index);

    return Pokemon.fromData(data);
  }

  Future<Pokemon> getPokemonByUrl(
      {@required String url, Map<String, dynamic> data}) async {
    data ??= await getPokemonJsonByUrl(url: url);

    if (data == null) return null;

    return Pokemon.fromData(data);
  }

  Future<PokemonSpecies> getPokemonSpecies(
      {@required String speciesName}) async {
    var url = '$BASE_URL/pokemon-species/$speciesName';

    Response response;
    try {
      response = await dio.get(url);
    } catch (e) {
      console.writeErrorLine('there was an error :( while handling $url');
      console.writeErrorLine(e);
      return null;
    }
    if (!checkResponse(response)) return null;

    Map<String, dynamic> data = jsonDecode(response.data);
    var species = PokemonSpecies.fromData(data);
    if (_includeEvolutions) {
      var result =
          await getPokemonEvolutions(chainUrl: species.evolutionChainUrl);
      if (result != null) {
        species.evolutions = result['evolutions'];
      } else {
        species.evolutionChainId = null;
      }
    }
    return species;
  }

  Future<PokemonAbility> getPokemonAbility(String name) async {
    var url = '$BASE_URL/ability/$name';
    Response response;
    try {
      response = await dio.get(url);
    } catch (e) {
      console.writeErrorLine('there was an error :( while handling $url');
      console.writeErrorLine(e);
      return null;
    }
    if (!checkResponse(response)) return null;
    var data = jsonDecode(response.data);
    return PokemonAbility.fromData(data);
  }

  Future<List<PokemonAbility>> getAllPokemonAbilities() async {
    console.writeLine('getting all abilities...');
    var url = '$BASE_URL/ability/?limit=2000';

    Response response;
    try {
      response = await dio.get(url);
    } catch (e) {
      console.writeErrorLine('there was an error :( while handling $url');
      console.writeErrorLine(e);
      return null;
    }
    if (!checkResponse(response)) return null;

    var abilities = <PokemonAbility>[];

    var data = jsonDecode(response.data)['results'];
    for (var i = 0; i < data.length; i++) {
      var ability = await getPokemonAbility(data[i]['name']);
      abilities.add(ability);
      console.clearScreen();
      console.writeLine('got ${i + 1} abilities from database');
    }
    return abilities;
  }

  Future<Map<String, dynamic>> getPokemonEvolutions(
      {@required String chainUrl}) async {
    Response response;
    try {
      response = await dio.get(chainUrl);
    } catch (e) {
      console.writeErrorLine('there was an error :( while handling $chainUrl');
      console.writeErrorLine(e);
      return null;
    }
    if (!checkResponse(response)) return null;

    Map<String, dynamic> data = jsonDecode(response.data);

    if ('evolves_to'.allMatches(response.data).length == 1) return null;

    var evolutions = <PokemonEvolution>[];
    Map<String, dynamic> thisData = data['chain'];
    for (var i = 0; i < thisData['evolves_to'].length; i++) {
      var evolution = PokemonEvolution.fromData(thisData, i);
      evolutions.add(evolution);
      if (thisData['evolves_to'][i]['evolves_to'].isNotEmpty) {
        var t = thisData['evolves_to'][i]['evolves_to'];
        for (var j = 0; j < t.length; j++) {
          var newEvolution =
              PokemonEvolution.fromData(thisData['evolves_to'][i], j);
          evolutions.add(newEvolution);
        }
      }
    }

    int id = data['id'];
    var result = <String, dynamic>{
      'id': id,
      'evolutions': evolutions,
    };

    return result;
  }

  Future<List<Pokemon>> getAllPokemonInRange(
      {int min = 0, int max = 10000}) async {
    console.writeLine('getting $max pokemon, starting from $min');

    final response = await dio.get('$BASE_URL/pokemon/?limit=$max&offset=$min',
        options: Options(responseType: ResponseType.plain));
    if (!checkResponse(response)) return null;

    var pokemon = <Pokemon>[];
    Map<String, dynamic> data = jsonDecode(response.data);
    var size = data['results'].length;

    for (var i = 0; i < size; i++) {
      String url = data['results'][i]['url'];

      /// Fix for pokeapi's issues with cloudflare
      url = url.endsWith('/') ? url : url + '/';

      var p = await getPokemonByUrl(url: url);

      if (p != null) {
        console.clearScreen();
        console.writeLine('got ${i + 1} pokemon from database');
        var species =
            await getPokemonSpecies(speciesName: p.speciesName).catchError(
          (e) => throw (e) /* console.writeErrorLine('error: $e') */,
        );

        if (species != null) {
          p.species = species;
          p.species.baseExperience = p.baseExperience;
          pokemon.add(p);
        }
      } else {
        console.writeErrorLine(
            "got an error while trying to get pokemon ${data['results'][i]['name']}\n with url: $url");
      }
    }
    return pokemon;
  }

  bool checkResponse(Response response) {
    if (response == null || response.statusCode != 200) {
      throw Exception('ERROR while handling request. ${response.statusCode}');
    }
    return true;
  }
}
