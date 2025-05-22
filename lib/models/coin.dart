class Coin {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
    );
  }
}
