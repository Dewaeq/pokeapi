class PokemonEvolution {
  String fromPokemon;
  String toPokemon;

  int minLevel;
  String itemName;

  PokemonEvolution.fromData(Map<String, dynamic> data) {
    fromPokemon = data['from_pokemon'];
    toPokemon = data['to_pokemon'];
    minLevel = data['min_level'];
    itemName = data['item_name'];
  }
}
