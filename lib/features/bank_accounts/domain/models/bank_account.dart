class BankAccount {
  const BankAccount({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.iban,
    required this.accountNumber,
    required this.balance,
    required this.available,
    required this.pending,
    required this.type,
    required this.lastSynced,
    this.isPrimary = false,
  });

  final String id;
  final String bankName;
  final String accountName;
  final String iban;
  final String accountNumber;
  final double balance;
  final double available;
  final double pending;
  final String type; // 'Checking', 'Savings'
  final DateTime lastSynced;
  final bool isPrimary;

  BankAccount copyWith({
    String? id,
    String? bankName,
    String? accountName,
    String? iban,
    String? accountNumber,
    double? balance,
    double? available,
    double? pending,
    String? type,
    DateTime? lastSynced,
    bool? isPrimary,
  }) {
    return BankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountName: accountName ?? this.accountName,
      iban: iban ?? this.iban,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      available: available ?? this.available,
      pending: pending ?? this.pending,
      type: type ?? this.type,
      lastSynced: lastSynced ?? this.lastSynced,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
