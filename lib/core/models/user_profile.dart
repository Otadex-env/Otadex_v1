class UserProfile {
  final String id;
  final String pseudo;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final String rank;
  final String subscriptionPlan;
  final int fanScore;
  final int rankCount;
  final double progressPct;
  final int currentPts;
  final int maxPts;
  final String bio;
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
    this.fanScore = 0,
    this.rankCount = 0,
    this.progressPct = 0.0,
    this.currentPts = 0,
    this.maxPts = 5000,
    this.bio = '',
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
      fanScore: (json['fan_score'] as num?)?.toInt() ?? 0,
      rankCount: (json['rank_count'] as num?)?.toInt() ?? 0,
      progressPct: (json['progress_pct'] as num?)?.toDouble() ?? 0.0,
      currentPts: (json['current_pts'] as num?)?.toInt() ?? 0,
      maxPts: (json['max_pts'] as num?)?.toInt() ?? 5000,
      bio: json['bio'] as String? ?? '',
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
      'fan_score': fanScore,
      'rank_count': rankCount,
      'progress_pct': progressPct,
      'current_pts': currentPts,
      'max_pts': maxPts,
      'bio': bio,
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
    int? fanScore,
    int? rankCount,
    double? progressPct,
    int? currentPts,
    int? maxPts,
    String? bio,
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
      fanScore: fanScore ?? this.fanScore,
      rankCount: rankCount ?? this.rankCount,
      progressPct: progressPct ?? this.progressPct,
      currentPts: currentPts ?? this.currentPts,
      maxPts: maxPts ?? this.maxPts,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ── Niveau fan calculé dynamiquement depuis fanScore ───────────────────────
  int get fanLevel {
    if (fanScore >= 5000) return 5;
    if (fanScore >= 2000) return 4;
    if (fanScore >= 500) return 3;
    if (fanScore >= 100) return 2;
    return 1;
  }

  String get fanLevelName {
    switch (fanLevel) {
      case 5:
        return 'Kage Suprême';
      case 4:
        return 'Jonin Otaku';
      case 3:
        return 'Chunin Fan';
      case 2:
        return 'Otaku Débutant';
      default:
        return 'Spectateur';
    }
  }

  int get nextLevelScore {
    switch (fanLevel) {
      case 1:
        return 100;
      case 2:
        return 500;
      case 3:
        return 2000;
      case 4:
        return 5000;
      default:
        return 5000;
    }
  }

  static UserProfile mock() => UserProfile(
        id: 'usr_new_001',
        pseudo: 'NouveauGenin',
        displayName: 'NouveauGenin',
        email: 'nouveau@otadex.app',
        rank: 'genin',
        subscriptionPlan: 'free',
        fanScore: 0,
        rankCount: 0,
        progressPct: 0.0,
        currentPts: 0,
        maxPts: 5000,
        bio: '',
        createdAt: DateTime(2026, 4, 30),
      );
}
