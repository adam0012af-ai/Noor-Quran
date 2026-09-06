class ZikrItem {
  final String id;
  final String category;
  final String text;
  final int repeat;
  final String? reference;

  const ZikrItem({required this.id, required this.category, required this.text, required this.repeat, this.reference});

  factory ZikrItem.fromJson(Map<String, dynamic> json) => ZikrItem(
        id: json['id'].toString(),
        category: json['category'] as String,
        text: json['text'] as String,
        repeat: (json['repeat'] ?? 1) as int,
        reference: json['reference'] as String?,
      );
}
