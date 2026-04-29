class CreatorEntry {
  final String id;
  final String name;
  final String? realName;
  final String role;
  final String? nationality;
  final int? bornYear;
  final List<String> works;
  final String initials;
  final String? bio;
  final List<String> tags;
  final String? serializedIn;
  final int? debutYear;

  const CreatorEntry({
    required this.id,
    required this.name,
    this.realName,
    required this.role,
    this.nationality,
    this.bornYear,
    this.works = const [],
    required this.initials,
    this.bio,
    this.tags = const [],
    this.serializedIn,
    this.debutYear,
  });

  factory CreatorEntry.fromJson(Map<String, dynamic> json) {
    return CreatorEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      realName: json['realName'] as String?,
      role: json['role'] as String? ?? '',
      nationality: json['nationality'] as String?,
      bornYear: (json['bornYear'] as num?)?.toInt(),
      works: (json['works'] as List<dynamic>?)?.cast<String>() ?? const [],
      initials: json['initials'] as String? ?? '',
      bio: json['bio'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
      serializedIn: json['serializedIn'] as String?,
      debutYear: (json['debutYear'] as num?)?.toInt(),
    );
  }
}
