class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.euPayId,
    required this.isVerified,
    required this.loyaltyPoints,
    required this.loyaltyTier,
    required this.linkedBanksCount,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String euPayId;
  final bool isVerified;
  final int loyaltyPoints;
  final String loyaltyTier;
  final int linkedBanksCount;

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? euPayId,
    bool? isVerified,
    int? loyaltyPoints,
    String? loyaltyTier,
    int? linkedBanksCount,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      euPayId: euPayId ?? this.euPayId,
      isVerified: isVerified ?? this.isVerified,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
      linkedBanksCount: linkedBanksCount ?? this.linkedBanksCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'euPayId': euPayId,
      'isVerified': isVerified,
      'loyaltyPoints': loyaltyPoints,
      'loyaltyTier': loyaltyTier,
      'linkedBanksCount': linkedBanksCount,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      euPayId: json['euPayId'] as String,
      isVerified: json['isVerified'] as bool,
      loyaltyPoints: json['loyaltyPoints'] as int,
      loyaltyTier: json['loyaltyTier'] as String,
      linkedBanksCount: json['linkedBanksCount'] as int,
    );
  }
}
