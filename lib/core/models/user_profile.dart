class UserProfile {
  final String id;
  final String pseudo;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final String rank;
  final String subscriptionPlan;
  final int collectCount;
  final int fanScore;
  final int rankCount;
  final double progressPct;
  final int currentPts;
  final int maxPts;
  final String bio;
  final List<String> collectedCharacterIds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.pseudo,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.rank = 'genin',
    this.subscriptionPlan = 'free',
    this.collectCount = 0,
    this.fanScore = 0,
    this.rankCount = 0,
    this.progressPct = 0.0,
    this.currentPts = 0,
    this.maxPts = 5000,
    this.bio = '',
    this.collectedCharacterIds = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      pseudo: json['pseudo'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      rank: json['rank'] as String? ?? 'genin',
      subscriptionPlan: json['subscription_plan'] as String? ?? 'free',
      collectCount: (json['collect_count'] as num?)?.toInt() ?? 0,
      fanScore: (json['fan_score'] as num?)?.toInt() ?? 0,
      rankCount: (json['rank_count'] as num?)?.toInt() ?? 0,
      progressPct: (json['progress_pct'] as num?)?.toDouble() ?? 0.0,
      currentPts: (json['current_pts'] as num?)?.toInt() ?? 0,
      maxPts: (json['max_pts'] as num?)?.toInt() ?? 5000,
      bio: json['bio'] as String? ?? '',
      collectedCharacterIds:
          (json['collected_character_ids'] as List<dynamic>?)
              ?.cast<String>() ??
              const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pseudo': pseudo,
      'display_name': displayName,
      'email': email,
      'avatar_url': avatarUrl,
      'rank': rank,
      'subscription_plan': subscriptionPlan,
      'collect_count': collectCount,
      'fan_score': fanScore,
      'rank_count': rankCount,
      'progress_pct': progressPct,
      'current_pts': currentPts,
      'max_pts': maxPts,
      'bio': bio,
      'collected_character_ids': collectedCharacterIds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? pseudo,
    String? displayName,
    String? email,
    String? avatarUrl,
    String? rank,
    String? subscriptionPlan,
    int? collectCount,
    int? fanScore,
    int? rankCount,
    double? progressPct,
    int? currentPts,
    int? maxPts,
    String? bio,
    List<String>? collectedCharacterIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      pseudo: pseudo ?? this.pseudo,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rank: rank ?? this.rank,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      collectCount: collectCount ?? this.collectCount,
      fanScore: fanScore ?? this.fanScore,
      rankCount: rankCount ?? this.rankCount,
      progressPct: progressPct ?? this.progressPct,
      currentPts: currentPts ?? this.currentPts,
      maxPts: maxPts ?? this.maxPts,
      bio: bio ?? this.bio,
      collectedCharacterIds:
          collectedCharacterIds ?? this.collectedCharacterIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static UserProfile mock() => UserProfile(
        id: 'usr_new_001',
        pseudo: 'NouveauGenin',
        displayName: 'NouveauGenin',
        email: 'nouveau@otadex.app',
        rank: 'genin',
        subscriptionPlan: 'free',
        collectCount: 0,
        fanScore: 0,
        rankCount: 0,
        progressPct: 0.0,
        currentPts: 0,
        maxPts: 5000,
        bio: '',
        createdAt: DateTime(2026, 4, 30),
      );
}
