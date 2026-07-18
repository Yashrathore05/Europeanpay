class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.counterparty,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
    required this.category,
    required this.reference,
    required this.source,
    this.hasInvoicePdf = false,
  });

  final String id;
  final String counterparty;
  final String type; // 'Payment', 'Received', 'Transfer', 'Cashback'
  final double amount; // negative for debits, positive for credits
  final String status; // 'completed', 'pending', 'failed'
  final DateTime date;
  final String category;
  final String reference;
  final String source; // 'EU Pay', 'Invoice', 'Bank'
  final bool hasInvoicePdf;

  bool get isCredit => amount > 0;

  TransactionModel copyWith({
    String? id,
    String? counterparty,
    String? type,
    double? amount,
    String? status,
    DateTime? date,
    String? category,
    String? reference,
    String? source,
    bool? hasInvoicePdf,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      counterparty: counterparty ?? this.counterparty,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      date: date ?? this.date,
      category: category ?? this.category,
      reference: reference ?? this.reference,
      source: source ?? this.source,
      hasInvoicePdf: hasInvoicePdf ?? this.hasInvoicePdf,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'counterparty': counterparty,
      'type': type,
      'amount': amount,
      'status': status,
      'date': date.toIso8601String(),
      'category': category,
      'reference': reference,
      'source': source,
      'hasInvoicePdf': hasInvoicePdf,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      counterparty: json['counterparty'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      reference: json['reference'] as String,
      source: json['source'] as String,
      hasInvoicePdf: json['hasInvoicePdf'] as bool? ?? false,
    );
  }
}
