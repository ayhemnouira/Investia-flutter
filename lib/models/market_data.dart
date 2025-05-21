class MarketData {
  final String symbol;
  final double price;

  MarketData({required this.symbol, required this.price});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      symbol: json['symbol'],
      price: json['price'],
    );
  }
}
