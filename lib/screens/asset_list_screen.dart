import 'package:flutter/material.dart';
import 'package:investia/providers/market_data_provider.dart';
import 'package:investia/widgets/asset_card.dart';
import 'package:provider/provider.dart';


class AssetListScreen extends StatefulWidget {
  const AssetListScreen({super.key});

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Provider.of<MarketDataProvider>(context, listen: false).fetchAssets();
    });
  }

  // Fonction pour gérer le tap sur un actif (navigue vers l'écran de détail en passant l'ID)
  void _handleAssetTap(String assetId) { // Accepte l'ID
    print("Tapped on asset: $assetId");
    // Navigue vers l'écran de détail en passant l'ID de l'actif
    Navigator.pushNamed(context, '/asset_detail', arguments: assetId); // Passe l'ID
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MarketDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Marché des Actifs"),
         leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Center(
        child: provider.isLoadingAssets
            ? const CircularProgressIndicator()
            : provider.errorMessageAssets != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Icon(Icons.error_outline, color: Colors.red, size: 50),
                         const SizedBox(height: 10),
                         Text(
                            provider.errorMessageAssets!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                             onPressed: () => provider.fetchAssets(),
                             child: const Text("Réessayer"),
                          ),
                       ],
                     ),
                  )
                : provider.assets.isEmpty
                    ? const Text("Aucun actif disponible pour l'instant.")
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchAssets(),
                        child: ListView.builder(
                          itemCount: provider.assets.length,
                          itemBuilder: (context, index) {
                            final asset = provider.assets[index];
                            // Utilise le widget AssetCard
                            return AssetCard(
                              asset: asset,
                              onTap: () => _handleAssetTap(asset.id), // Passe l'ID lors du tap
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}