class Wallet {
  final int id;
  final double balance;

  Wallet({
    required this.id,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? 0,
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
