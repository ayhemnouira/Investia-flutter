import 'package:flutter/material.dart';
import 'package:investia/models/asset.dart';
// Optionnel: Utilise CachedNetworkImage pour mettre en cache les images (ajoute la dépendance si besoin)
// import 'package:cached_network_image/cached_network_image.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap; // Pour naviguer vers l'écran de détail

  const AssetCard({
    super.key,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Détermine la couleur et l'icône de variation sur 24h
    final Color changeColor =
        asset.priceChange24h >= 0 ? Colors.green : Colors.red;
    final IconData changeIcon =
        asset.priceChange24h >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap, // Gère le tap (passera l'ID depuis AssetListScreen)
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Afficher l'image de l'actif si l'URL est disponible
              if (asset.imageUrl.isNotEmpty) ...[
                CircleAvatar(
                  radius: 20, // Taille de l'image/icône
                  // Utilise NetworkImage ou CachedNetworkImage
                  backgroundImage: NetworkImage(asset.imageUrl),
                  backgroundColor:
                      Colors.transparent, // Utile si l'image est transparente
                  // Si l'image ne charge pas, tu peux ajouter child: Icon(...) ou onBackgroundImageError
                ),
                const SizedBox(width: 12),
              ] else ...[
                // Afficher une icône par défaut si pas d'image
                const Icon(Icons.currency_exchange,
                    size: 30, color: Colors.grey),
                const SizedBox(width: 12),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol
                          .toUpperCase(), // Symbole en majuscules (ex: BTC)
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      asset.name, // Nom complet (ex: Bitcoin)
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Affichage du prix et de la variation
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    asset.currentPrice.toStringAsFixed(
                        2), // Affiche le prix avec 2 décimales (USD)
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .end, // Aligne à droite dans la colonne
                    children: [
                      Icon(changeIcon, color: changeColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        // Affiche la variation absolue et en pourcentage sur 24h
                        "${asset.priceChange24h.toStringAsFixed(2)} (${asset.priceChangePercentage24h.toStringAsFixed(2)}%)",
                        style: TextStyle(
                          fontSize: 12,
                          color: changeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
