class WalletTransaction {
  final double amount;
  final String purpose;

  WalletTransaction({
    required this.amount,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'purpose': purpose,
    };
  }
}
