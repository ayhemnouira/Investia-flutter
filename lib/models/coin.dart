class Coin {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final String imageUrl;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.imageUrl,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    print('Coin JSON: $json');
    final price = (json['current_price'] as num?)?.toDouble() ??
        (json['market_data']?['current_price']?['usd'] as num?)?.toDouble() ??
        0.0;
    if (price == 0.0) {
      print('Warning: Price is 0.0 for coin ${json['id']}');
    }
    // Ensure imageUrl is a valid string, provide fallback if null or empty
    final image = json['image'] is String
        ? json['image']
        : json['image']?['thumb'] ??
            'https://via.placeholder.com/32'; // Fallback URL
    return Coin(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol']?.toUpperCase() ?? '',
      currentPrice: price,
      imageUrl: image.isNotEmpty ? image : 'https://via.placeholder.com/32',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'currentPrice': currentPrice,
      'imageUrl': imageUrl,
    };
  }
}
