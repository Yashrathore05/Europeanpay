class Recipient {
  const Recipient({
    required this.fullName,
    required this.euPayId,
    required this.type,
  });

  final String fullName;
  final String euPayId;
  final String type; // 'Customer', 'Merchant'

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      fullName: json['fullName'] as String,
      euPayId: json['euPayId'] as String,
      type: json['type'] as String? ?? 'Customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'euPayId': euPayId,
      'type': type,
    };
  }
}
