class PointActivity {
  const PointActivity({
    required this.id,
    required this.title,
    required this.points,
    required this.type, // 'cashback', 'vip_bonus', 'streak_bonus', etc.
    required this.date,
  });

  final String id;
  final String title;
  final int points;
  final String type;
  final DateTime date;

  factory PointActivity.fromJson(Map<String, dynamic> json) {
    return PointActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      points: json['points'] as int,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'points': points,
      'type': type,
      'date': date.toIso8601String(),
    };
  }
}

class LoyaltyDetails {
  const LoyaltyDetails({
    required this.pointsBalance,
    required this.pendingPoints,
    required this.earnedThisMonth,
    required this.streakDays,
    required this.vipTier,
    required this.lifetimeEarned,
    required this.lifetimeRedeemed,
    required this.cashbackExtraPercentage,
    required this.nextTierProgress,
    required this.nextTierPoints,
    required this.nextTierTarget,
    required this.nextTierName,
    required this.recentActivity,
  });

  final int pointsBalance;
  final int pendingPoints;
  final int earnedThisMonth;
  final int streakDays;
  final String vipTier;
  final int lifetimeEarned;
  final int lifetimeRedeemed;
  final double cashbackExtraPercentage;
  final double nextTierProgress;
  final int nextTierPoints;
  final int nextTierTarget;
  final String nextTierName;
  final List<PointActivity> recentActivity;

  double get eurValue => pointsBalance * 0.01;

  LoyaltyDetails copyWith({
    int? pointsBalance,
    int? pendingPoints,
    int? earnedThisMonth,
    int? streakDays,
    String? vipTier,
    int? lifetimeEarned,
    int? lifetimeRedeemed,
    double? cashbackExtraPercentage,
    double? nextTierProgress,
    int? nextTierPoints,
    int? nextTierTarget,
    String? nextTierName,
    List<PointActivity>? recentActivity,
  }) {
    return LoyaltyDetails(
      pointsBalance: pointsBalance ?? this.pointsBalance,
      pendingPoints: pendingPoints ?? this.pendingPoints,
      earnedThisMonth: earnedThisMonth ?? this.earnedThisMonth,
      streakDays: streakDays ?? this.streakDays,
      vipTier: vipTier ?? this.vipTier,
      lifetimeEarned: lifetimeEarned ?? this.lifetimeEarned,
      lifetimeRedeemed: lifetimeRedeemed ?? this.lifetimeRedeemed,
      cashbackExtraPercentage: cashbackExtraPercentage ?? this.cashbackExtraPercentage,
      nextTierProgress: nextTierProgress ?? this.nextTierProgress,
      nextTierPoints: nextTierPoints ?? this.nextTierPoints,
      nextTierTarget: nextTierTarget ?? this.nextTierTarget,
      nextTierName: nextTierName ?? this.nextTierName,
      recentActivity: recentActivity ?? this.recentActivity,
    );
  }
}
