import 'dart:math';

class SimulatedPaymentReceipt {
  const SimulatedPaymentReceipt({
    required this.transactionId,
    required this.bankReference,
    required this.schemeReference,
    required this.status,
    required this.pointsEarned,
    required this.processedAt,
    required this.settlementEta,
  });

  final String transactionId;
  final String bankReference;
  final String schemeReference;
  final String status;
  final int pointsEarned;
  final DateTime processedAt;
  final String settlementEta;

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'bankReference': bankReference,
      'schemeReference': schemeReference,
      'status': status,
      'pointsEarned': pointsEarned,
      'processedAt': processedAt.toIso8601String(),
      'settlementEta': settlementEta,
    };
  }
}

class PaymentSimulator {
  PaymentSimulator({Random? random}) : _random = random ?? Random();

  final Random _random;

  Future<SimulatedPaymentReceipt> authorize({
    required double amount,
    String rail = 'SEPA Instant',
  }) async {
    await Future.delayed(const Duration(milliseconds: 1150));
    final now = DateTime.now();
    final suffix = now.microsecondsSinceEpoch.toString().substring(7);
    return SimulatedPaymentReceipt(
      transactionId: 'EUP-${now.year}${_two(now.month)}${_two(now.day)}-$suffix',
      bankReference: 'BNK-${10000000 + _random.nextInt(89999999)}',
      schemeReference: '$rail SIM-${1000 + _random.nextInt(8999)}',
      status: amount > 750 ? 'pending' : 'completed',
      pointsEarned: max(1, amount.floor()),
      processedAt: now,
      settlementEta: amount > 750 ? 'Manual review, usually under 15 minutes' : 'Instantly settled',
    );
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
