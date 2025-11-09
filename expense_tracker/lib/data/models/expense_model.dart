class ExpenseModel {
  final String id;
  final String category;
  final double amount;
  final String comments;

  ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.comments,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0).toDouble(),
      comments: (json['comments'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'amount': amount,
      'comments': comments,
    };
  }
}
