import 'package:PokeAPI/extensions/StringExtensions.dart';

class PokemonAbility {
  String name;
  String description;
  String shortEffectDescription;
  String effectDescription;
  List<String> pokemon = [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'effect_description': effectDescription,
        'short_effect_description': shortEffectDescription,
        'pokemon': pokemon,
      };

  PokemonAbility.fromData(Map<String, dynamic> data) {
    name = data['name'];
    description = data['flavor_text_entries'].isEmpty
        ? null
        : data['flavor_text_entries']
            .firstWhere(
              (e) =>
                  e['language']['name'] == 'en' &&
                  e['version_group']['name'] == 'x-y',
              orElse: () => data['flavor_text_entries']
                  .firstWhere((e) => e['language']['name'] == 'en'),
            )['flavor_text']
            .toString()
            .fixDescription();

    shortEffectDescription = data['effect_entries'].isEmpty
        ? null
        : data['effect_entries']
            .firstWhere(
              (e) => e['language']['name'] == 'en',
              orElse: () => data['effect_entries']
                  .firstWhere((e) => e['language']['name'] == 'en'),
            )['short_effect']
            .toString()
            .fixDescription();
    effectDescription = data['effect_entries'].isEmpty
        ? null
        : data['effect_entries']
            .firstWhere(
              (e) => e['language']['name'] == 'en',
              orElse: () => data['effect_entries']
                  .firstWhere((e) => e['language']['name'] == 'en'),
            )['effect']
            .toString()
            .fixDescription();
    pokemon = List<String>.from(
      data['pokemon'].map((e) => e['pokemon']['name']),
    );
  }
}
