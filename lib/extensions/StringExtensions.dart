extension StringExtensions on String {
  String fixDescription() {
    return this
        .replaceAll('\n', ' ')
        .replaceAll('\f', ' ')
        .replaceAll('POKéMON', 'pokémon')
        .replaceAll('  ', ' ')
        .replaceAll('  ', ' ');
  }
}
