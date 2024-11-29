class FavoriteMovie {
  final int id;
  final String title;
  final String posterPath;
  final String note;

  FavoriteMovie({
    required this.id,
    required this.title,
    this.posterPath = '',
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'note': note,
    };
  }

  static FavoriteMovie fromMap(Map<String, dynamic> map) {
    return FavoriteMovie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      note: map['note'],
    );
  }
}
