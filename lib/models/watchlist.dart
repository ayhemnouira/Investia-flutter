import 'package:investia/models/coin.dart';

class Watchlist {
  final int id;
  final List<Coin> coins;

  Watchlist({
    required this.id,
    required this.coins,
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'] as int? ?? 0, // Parse id, default to 0 if missing
      coins: (json['coins'] as List<dynamic>?)
              ?.map((e) => Coin.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coins': coins.map((e) => e.toJson()).toList(),
    };
  }
}
