class Ayah {
  final int number;
  final int numberInSurah;
  final int juz;
  final String text;

  const Ayah({required this.number, required this.numberInSurah, required this.juz, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json['number'] as int,
        numberInSurah: json['numberInSurah'] as int,
        juz: json['juz'] as int,
        text: json['text'] as String,
      );
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String revelationType;
  final List<Ayah> ayahs;

  const Surah({required this.number, required this.name, required this.englishName, required this.revelationType, required this.ayahs});

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json['number'] as int,
        name: json['name'] as String,
        englishName: (json['englishName'] ?? '') as String,
        revelationType: (json['revelationType'] ?? '') as String,
        ayahs: (json['ayahs'] as List).map((e) => Ayah.fromJson(Map<String, dynamic>.from(e))).toList(),
      );
}
