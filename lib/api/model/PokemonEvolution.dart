class PokemonEvolution {
  String fromPokemon;
  String toPokemon;

  int minLevel;
  String itemName;

  Map<String, dynamic> toJson() => {
        'from_pokemon': fromPokemon,
        'to_pokemon': toPokemon,
        'min_level': minLevel,
        'item_name': itemName,
      };

  PokemonEvolution.fromData(Map<String, dynamic> data, index) {
    if (data['evolves_to'].isEmpty) {
      print(data);
      print('returning');
      return;
    }

    // try {
    fromPokemon = data['species']['name'];
    toPokemon = data['evolves_to'][index]['species']['name'];
    if (data['evolves_to'][index]['evolution_details'].length == 0) return;
    minLevel = data['evolves_to'][index]['evolution_details'][0]['min_level'];
    itemName = data['evolves_to'][index]['evolution_details'][0]['item'] == null
        ? null
        : data['evolves_to'][index]['evolution_details'][0]['item']['name'];
    /* } catch (e) {
      print('error :( $e');
    } */
  }
}
