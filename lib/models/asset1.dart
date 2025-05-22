class Asset {
  final int id;
  final String coinId;
  final double quantity;
  final double averageBuyPrice;

  Asset({
    required this.id,
    required this.coinId,
    required this.quantity,
    required this.averageBuyPrice,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] ?? 0,
      coinId: json['coinId'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      averageBuyPrice: (json['averageBuyPrice'] ?? 0).toDouble(),
    );
  }
}
