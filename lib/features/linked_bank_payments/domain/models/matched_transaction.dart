class MatchedTransaction {
  const MatchedTransaction({
    required this.id,
    required this.bankTxnName,
    required this.bankTxnAmount,
    required this.bankTxnDate,
    required this.euPayTxnName,
    required this.euPayTxnAmount,
    required this.euPayTxnDate,
    required this.confidence,
    required this.status, // 'pending', 'matched', 'rejected'
  });

  final String id;
  final String bankTxnName;
  final double bankTxnAmount;
  final DateTime bankTxnDate;
  final String euPayTxnName;
  final double euPayTxnAmount;
  final DateTime euPayTxnDate;
  final int confidence;
  final String status;

  MatchedTransaction copyWith({
    String? id,
    String? bankTxnName,
    double? bankTxnAmount,
    DateTime? bankTxnDate,
    String? euPayTxnName,
    double? euPayTxnAmount,
    DateTime? euPayTxnDate,
    int? confidence,
    String? status,
  }) {
    return MatchedTransaction(
      id: id ?? this.id,
      bankTxnName: bankTxnName ?? this.bankTxnName,
      bankTxnAmount: bankTxnAmount ?? this.bankTxnAmount,
      bankTxnDate: bankTxnDate ?? this.bankTxnDate,
      euPayTxnName: euPayTxnName ?? this.euPayTxnName,
      euPayTxnAmount: euPayTxnAmount ?? this.euPayTxnAmount,
      euPayTxnDate: euPayTxnDate ?? this.euPayTxnDate,
      confidence: confidence ?? this.confidence,
      status: status ?? this.status,
    );
  }
}
