class PokemonStat {
  String name;
  int baseStat;
  int effort;

  PokemonStat.fromData(Map<String, dynamic> data) {
    name = data['name'];
    baseStat = data['base_stat'];
    effort = data['effort'];
  }
}
