class Preferences {
  final bool isDarkMode;
  final String sortOrder;

  Preferences({required this.isDarkMode, required this.sortOrder});

  // Convert preferences to a map
  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'sortOrder': sortOrder,
    };
  }

  // Convert map to preferences object
  static Preferences fromMap(Map<String, dynamic> map) {
    return Preferences(
      isDarkMode: map['isDarkMode'] ?? false,
      sortOrder: map['sortOrder'] ?? 'date',
    );
  }
}
