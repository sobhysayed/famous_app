class Person {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;
  final double popularity;
  final List<dynamic>? knownFor;

  Person({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
    required this.popularity,
    this.knownFor,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      knownForDepartment: json['known_for_department'],
      popularity: json['popularity']?.toDouble() ?? 0.0,
      knownFor: json['known_for'],
    );
  }
}
