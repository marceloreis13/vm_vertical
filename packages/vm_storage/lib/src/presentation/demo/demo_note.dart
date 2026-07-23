/// A structured record demoed via `DocumentStore<DemoNote>` in the visual
/// example. Owned by the demo itself, not a consumer — the module never
/// imports an actual consumer model.
class DemoNote {
  const DemoNote({required this.id, required this.text});

  final String id;
  final String text;

  Map<String, dynamic> toJson() => {'id': id, 'text': text};

  static DemoNote fromJson(Map<String, dynamic> json) {
    return DemoNote(id: json['id'] as String, text: json['text'] as String);
  }
}
