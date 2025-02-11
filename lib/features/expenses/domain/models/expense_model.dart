class ExpenseModel {
  final String id;
  final String category;
  final String currency;
  final String title;
  final double amount;
  final DateTime date;
  final DateTime createdAt;
  final String? status;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.createdAt,
    required this.category,
    required this.currency,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'date': date.toIso8601String(),
      'category': category,
      'currency': currency,
      'status': status,
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      status: json['status'],
      createdAt:
          DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      currency: json['currency'],
    );
  }
}
