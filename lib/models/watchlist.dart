

import 'package:investia/models/coin.dart';

class Watchlist {
  final int id;
  final List<Coin> coins;

  Watchlist({
    required this.id,
    required this.coins,
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    var coinsList = json['coins'] as List<dynamic>? ?? [];
    List<Coin> coins =
        coinsList.map((coinJson) => Coin.fromJson(coinJson)).toList();

    return Watchlist(
      id: json['id'] ?? 0,
      coins: coins,
    );
  }
}
