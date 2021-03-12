class PokemonStat {
  String name;
  int baseStat;
  int effort;

  Map<String, dynamic> toJson() => {
        'name': name,
        'base_stat': baseStat,
        'effort': effort,
      };

  PokemonStat.fromData(Map<String, dynamic> data) {
    name = data['stat']['name'];
    baseStat = data['base_stat'];
    effort = data['effort'];
  }
}

/* class PokemonStat {
  int hpStat;
  int atStat;
  int defStat;
  int specAtStat;
  int specDefStat;
  int speedStat;

  Map<String, dynamic> toJson() => {
        'hp_stat': hpStat,
        'at_stat': atStat,
        'def_stat': defStat,
        'spec_at_stat': specAtStat,
        'spec_def_stat': specDefStat,
        'speed_stat': speedStat,
      };

  PokemonStat.fromData(List<Map<String, dynamic>> data) {
    hpStat = data[0]['base_stat'];
    atStat = data[1]['base_stat'];
    defStat = data[2]['base_stat'];
    specAtStat = data[3]['base_stat'];
    specDefStat = data[4]['base_stat'];
    speedStat = data[5]['base_stat'];
  }
}
 */
