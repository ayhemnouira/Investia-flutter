import 'package:flutter/material.dart';
import 'package:investia/providers/market_data_provider.dart';
import 'package:provider/provider.dart';


class AssetDetailScreen extends StatefulWidget {
  final String assetId; // L'ID de l'actif CoinGecko (passé via les arguments de route)

  const AssetDetailScreen({Key? key, required this.assetId}) : super(key: key);

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  // ** CORRECTION : Déclare une variable pour stocker la référence du provider **
  late MarketDataProvider _marketDataProvider;

  @override
  void initState() {
    super.initState();
     // ** CORRECTION : Obtient la référence du provider ici (listen: false) **
     _marketDataProvider = Provider.of<MarketDataProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
        // Utilise la référence stockée pour appeler la méthode du provider
       _marketDataProvider.startFetchingSingleAsset(widget.assetId);
    });
  }

  @override
  void dispose() {
    // ** CORRECTION : Utilise la référence stockée pour appeler stopFetchingSingleAsset **
    // Évite d'utiliser Provider.of(context) dans dispose
    _marketDataProvider.stopFetchingSingleAsset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     // Écoute toujours le provider ici pour la reconstruction de l'UI
    final provider = Provider.of<MarketDataProvider>(context);
    // Accède aux données via le provider écouté dans build
    final asset = provider.getLiveAssetPrice(widget.assetId);

    Widget content;

    if (provider.isLoadingSingleAsset && asset == null) {
       content = const CircularProgressIndicator();
    } else if (provider.errorMessageSingleAsset != null) {
       content = Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                 provider.errorMessageSingleAsset!,
                 textAlign: TextAlign.center,
                 style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
               const SizedBox(height: 20),
               if (!provider.isLoadingSingleAsset && asset == null)
                 ElevatedButton(
                    // ** CORRECTION : Utilise la référence stockée pour appeler startFetchingSingleAsset **
                    onPressed: () => _marketDataProvider.startFetchingSingleAsset(widget.assetId),
                    child: const Text("Réessayer"),
                 ),
            ],
          ),
       );
    } else if (asset == null) {
       content = Center(child: Text("Données non disponibles pour ${widget.assetId}"));
    }
    else {
      final Color changeColor = asset.priceChange24h >= 0 ? Colors.green : Colors.red;
      final IconData changeIcon = asset.priceChange24h >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           if (asset.imageUrl.isNotEmpty) ...[
             CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(asset.imageUrl),
                backgroundColor: Colors.transparent,
             ),
             const SizedBox(height: 16),
           ],
          Text(
            asset.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            asset.symbol.toUpperCase(),
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            "${asset.currentPrice.toStringAsFixed(2)} USD",
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(changeIcon, color: changeColor, size: 24),
               const SizedBox(width: 8),
               Text(
                 "${asset.priceChange24h.toStringAsFixed(2)} (${asset.priceChangePercentage24h.toStringAsFixed(2)}%)",
                 style: TextStyle(
                   fontSize: 24,
                   color: changeColor,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ],
           ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(asset?.name ?? asset?.symbol.toUpperCase() ?? widget.assetId),
      ),
      body: Center(child: content),
    );
  }
}