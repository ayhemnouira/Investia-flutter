class Withdrawal {
  final int id;
  final double amount;
  final bool accepted;

  Withdrawal({
    required this.id,
    required this.amount,
    required this.accepted,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      accepted: json['accepted'] ?? false,
    );
  }
}
