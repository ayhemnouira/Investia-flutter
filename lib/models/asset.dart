import 'package:hive/hive.dart';

part 'asset.g.dart';

@HiveType(typeId: 2) // ID unique pour Asset (doit être différent des autres modèles)
class Asset {
  @HiveField(0)
  final String id; // L'ID unique de CoinGecko (ex: "bitcoin")
  @HiveField(1)
  final String symbol; // Le symbole (ex: "btc")
  @HiveField(2)
  final String name;   // Le nom (ex: "Bitcoin")
  @HiveField(3)
  final String imageUrl; // URL de l'image (peut être null dans certaines réponses)
  @HiveField(4)
  final double currentPrice;
  @HiveField(5)
  final double priceChange24h; // Variation absolue sur 24h
  @HiveField(6)
  final double priceChangePercentage24h; // Variation en pourcentage sur 24h
  // Tu peux ajouter d'autres champs pertinents de l'API si tu en as besoin (market_cap, volume, etc.)
  // @HiveField(7)
  // final int? marketCapRank;
  // @HiveField(8)
  // final double? totalVolume;


  Asset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    // this.marketCapRank,
    // this.totalVolume,
  });

  // Méthode factory pour créer un actif depuis le JSON de l'endpoint /coins/markets de CoinGecko
  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String? ?? '', // L'ID de CoinGecko
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '', // L'URL de l'image
      currentPrice: (json['current_price'] as num? ?? 0.0).toDouble(), // Accès à 'current_price'
      priceChange24h: (json['price_change_24h'] as num? ?? 0.0).toDouble(), // Accès à 'price_change_24h'
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num? ?? 0.0).toDouble(), // Accès à 'price_change_percentage_24h'
      // marketCapRank: json['market_cap_rank'] as int?,
      // totalVolume: (json['total_volume'] as num?)?.toDouble(),
    );
  }

   // Méthode pour mettre à jour les données d'un Asset existant (utile pour le temps réel)
   // Si on utilise l'endpoint /simple/price, il faudrait l'adapter ici
   // Si on utilise /coins/{id}, on peut juste refaire un fromJson et remplacer l'objet
   Asset copyWith({
    double? currentPrice,
    double? priceChange24h,
    double? priceChangePercentage24h,
     // Ajoute d'autres champs si tu veux pouvoir les mettre à jour
  }) {
    return Asset(
      id: this.id,
      symbol: this.symbol,
      name: this.name,
      imageUrl: this.imageUrl, // L'URL de l'image change rarement
      currentPrice: currentPrice ?? this.currentPrice,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      // marketCapRank: this.marketCapRank,
      // totalVolume: this.totalVolume,
    );
  }
}