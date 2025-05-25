import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Pour formater le prix et le pourcentage
import 'package:cached_network_image/cached_network_image.dart'; // <-- AJOUTE CET IMPORT pour afficher les images

import 'package:investia/providers/market_data_provider.dart'; // Importe le MarketDataProvider
import 'package:investia/models/asset.dart'; // Importe le modèle Asset
// Retire les imports de l'ancien service/modèle (si ces fichiers existent encore, SUPPRIME-LES)
// import '../widgets/price_card.dart';
// import '../services/api_service.dart';
// import '../models/market_data.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  void initState() {
    super.initState();
    // Déclenche le chargement de la liste d'assets au démarrage en utilisant le Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Utilise listen: false car on ne veut pas provoquer de rebuild dans initState
      Provider.of<MarketDataProvider>(context, listen: false).fetchAssets();
    });
  }

  // Helper pour obtenir la couleur de la variation
  Color _getPriceChangeColor(double? change) {
    if (change == null) return Colors.grey;
    if (change > 0) return Colors.green;
    if (change < 0) return Colors.red;
    return Colors.grey;
  }

  // Helper pour formater le prix
  String _formatPrice(double? price) {
    if (price == null) return 'N/A';
    // Utilise NumberFormat si besoin d'un formatage plus spécifique avec groupes de milliers
    return '\$${price.toStringAsFixed(2)}'; // Formate le prix avec 2 décimales
  }

  // Helper pour formater le pourcentage
  String _formatPercentage(double? percentage) {
    if (percentage == null) return 'N/A';
    return '${percentage.toStringAsFixed(2)}%'; // Formate le pourcentage avec 2 décimales
  }

  @override
  Widget build(BuildContext context) {
    // "Écoute" le MarketDataProvider pour reconstruire l'UI lors des changements d'état
    // Utilise context.watch pour une syntaxe plus concise
    final provider = context.watch<MarketDataProvider>();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Marché des Actifs')), // Titre de l barre d'applis
      body: RefreshIndicator(
        // Permet le "pull-to-refresh"
        onRefresh: () => provider
            .fetchAssets(), // Appelle la fonction de chargement lors du rafraîchissement
        child: _buildBody(
            provider), // Méthode pour construire le contenu dynamique
      ),
    );
  }

  // Méthode privée pour construire le corps de l'écran en fonction de l'état du provider
  Widget _buildBody(MarketDataProvider provider) {
    // 1. État de chargement (affichage d'un spinner)
    // On affiche le spinner s'il est en chargement ET qu'il n'y a pas encore de données à afficher
    if (provider.isLoadingAssets && provider.assets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. État d'erreur (affichage d'un message d'erreur et bouton retry)
    // On affiche l'erreur s'il y en a une ET qu'il n'y a pas de données à afficher (pas de cache disponible)
    if (provider.errorMessageAssets != null && provider.assets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                provider.errorMessageAssets!, // Affiche le message d'erreur
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    provider.fetchAssets(), // Bouton pour réessayer l'appel API
                child: const Text("Réessayer"),
              ),
              // Si le cache a été chargé malgré l'erreur API, cette condition ne sera pas vraie dans ce bloc
            ],
          ),
        ),
      );
    }

    // 3. État vide (affichage d'un message si la liste est vide après chargement/erreur)
    // Si pas de chargement, pas d'erreur (ou erreur avec cache affiché), et la liste est vide
    if (provider.assets.isEmpty) {
      return const Center(
        child: Text("Aucun actif de marché disponible."),
      );
    }

    // 4. État des données (affichage de la liste)
    // Si pas dans les états précédents, cela signifie qu'il y a des données à afficher.
    return ListView.builder(
      itemCount: provider.assets.length,
      itemBuilder: (context, index) {
        final asset = provider.assets[index];
        // Utilise un ListTile simple enveloppé dans une Card
        return Card(
          // Utilise le CardTheme défini dans main.dart
          margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0), // Marge réduite entre les cartes
          child: ListTile(
            // ====== AFFICHAGE DE L'IMAGE DE L'ACTIF ICI ======
            leading: asset.imageUrl
                    .isNotEmpty // Vérifie si l'URL de l'image existe et n'est pas vide
                ? CachedNetworkImage(
                    // Utilise CachedNetworkImage pour afficher l'image depuis l'URL
                    imageUrl: asset.imageUrl, // L'URL de l'image
                    width: 40, // Largeur de l'icône
                    height: 40, // Hauteur de l'icône
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(), // Widget affiché pendant le chargement
                    errorWidget: (context, url, error) => const Icon(
                        Icons.currency_bitcoin,
                        size: 40,
                        color: Colors.grey), // Icône par défaut en cas d'erreur
                  )
                : const Icon(Icons.currency_bitcoin,
                    size: 40,
                    color:
                        Colors.grey), // Icône par défaut si pas d'URL d'image
            // ===============================================

            title: Text(
              "${asset.name} (${asset.symbol.toUpperCase() ?? 'N/A'})", // Affiche nom et symbole
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              // Affiche le prix et la variation à droite
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_formatPrice(asset.currentPrice), // Formatage du prix
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                    _formatPercentage(asset
                        .priceChangePercentage24h), // Formatage du pourcentage
                    style: TextStyle(
                      fontSize: 14,
                      color: _getPriceChangeColor(asset
                          .priceChangePercentage24h), // Couleur dynamique (vert/rouge)
                    )),
              ],
            ),
            // Rendre la carte cliquable pour aller aux détails de cet actif spécifique
            onTap: () {
              // Navigue vers l'écran de détail, en passant l'ID de l'actif
              // Assure-toi que la route '/asset_detail' est gérée dans ton routeur (comme configuré précédemment)
              if (asset.id.isNotEmpty) {
                Navigator.pushNamed(context, '/asset_detail',
                    arguments: asset.id);
              } else {
                print("Asset ID is missing for navigation!");
              }
            },
          ),
        );
      },
    );
  }
}
