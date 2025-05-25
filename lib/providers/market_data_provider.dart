import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:investia/models/asset.dart';
import 'package:investia/services/data_service.dart';

class MarketDataProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<Asset> _assets = []; // Liste pour la watchlist/marché global
  final Map<String, Asset> _livePrices =
      {}; // Stocke les prix des actifs qu'on suit en temps réel (par ID)
  bool _isLoadingAssets = false;
  bool _isLoadingSingleAsset = false;
  String? _errorMessageAssets;
  String? _errorMessageSingleAsset;

  Timer? _pollingTimer;
  String? _currentPollingAssetId; // Utilisez l'ID de l'actif CoinGecko ici

  List<Asset> get assets => _assets;
  bool get isLoadingAssets => _isLoadingAssets;
  String? get errorMessageAssets => _errorMessageAssets;

  // Getter pour les données d'un seul actif suivies en temps réel (utilise l'ID)
  Asset? getLiveAssetPrice(String assetId) =>
      _livePrices[assetId.toLowerCase()]; // Stocke par ID en minuscule
  bool get isLoadingSingleAsset => _isLoadingSingleAsset;
  String? get errorMessageSingleAsset => _errorMessageSingleAsset;

  // --- Méthodes pour la liste d'actifs (Watchlist) ---

  Future<void> fetchAssets() async {
    _isLoadingAssets = true;
    _errorMessageAssets = null;
    notifyListeners();

    try {
      _assets = await _dataService.fetchMarketAssets();
      _errorMessageAssets = null;
    } catch (e) {
      _errorMessageAssets = "Failed to load market assets: ${e.toString()}";
      _assets = [];
    } finally {
      _isLoadingAssets = false;
      notifyListeners();
    }
  }

  // --- Méthodes pour un seul actif (Détail et Temps Réel) ---

  // Commence le chargement initial et le polling pour un actif spécifique (par son ID CoinGecko)
  Future<void> startFetchingSingleAsset(String assetId) async {
    final lowerCaseId = assetId.toLowerCase();

    // Si on poll déjà cet actif, on ne fait rien
    if (_currentPollingAssetId == lowerCaseId) {
      print("Already polling $lowerCaseId");
      // S'il y a déjà des données, notifier quand même au cas où l'UI a besoin de se mettre à jour
      if (_livePrices.containsKey(lowerCaseId)) {
        notifyListeners();
      }
      return;
    }

    // Arrête le timer précédent s'il existe
    stopFetchingSingleAsset();

    _currentPollingAssetId = lowerCaseId; // Définit l'ID qu'on va suivre
    _isLoadingSingleAsset = true;
    _errorMessageSingleAsset = null;
    // Ne pas effacer l'ancien prix immédiatement si on en a un
    // _livePrices.remove(lowerCaseId);

    notifyListeners(); // Notifie que le chargement commence

    // 1. Fait un premier appel pour obtenir les données initiales complètes
    try {
      // Appel à la méthode du service qui utilise l'ID
      final initialAsset = await _dataService.fetchAssetPrice(lowerCaseId);
      _livePrices[lowerCaseId] =
          initialAsset; // Stocke la première donnée reçue par ID
      _errorMessageSingleAsset = null;
      print(
          "Initial price fetched for $lowerCaseId: ${initialAsset.currentPrice}");

      // 2. Démarre le polling (mise à jour toutes les 5 secondes)
      _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        try {
          // Récupère la mise à jour (réappelle la même méthode)
          final updatedAsset = await _dataService.fetchAssetPrice(lowerCaseId);

          // Met à jour l'Asset dans _livePrices
          _livePrices[lowerCaseId] =
              updatedAsset; // Remplace l'ancien objet par le nouveau

          _errorMessageSingleAsset =
              null; // Efface l'erreur si une mise à jour réussit

          // print("Polling update for $lowerCaseId: ${_livePrices[lowerCaseId]!.currentPrice}");
          notifyListeners(); // Notifie les listeners (l'écran de détail)
        } catch (e) {
          // Gérer les erreurs de mise à jour sans arrêter tout le polling
          print("Error during polling for $lowerCaseId: ${e.toString()}");
          // Optionnel: Mettre à jour une variable d'état d'erreur de polling si tu veux l'afficher subtilement
          // _errorMessageSingleAsset = "Update error: ${e.toString()}";
          // notifyListeners(); // Si tu veux afficher l'erreur de mise à jour
        }
      });
    } catch (e) {
      // Gérer l'erreur du chargement initial
      _errorMessageSingleAsset =
          "Failed to load initial price for $lowerCaseId: ${e.toString()}";
      _livePrices.remove(
          lowerCaseId); // Assure que l'actif n'est pas affiché s'il y a une erreur initiale
      print(_errorMessageSingleAsset);
    } finally {
      _isLoadingSingleAsset = false; // Le chargement initial est terminé
      notifyListeners(); // Notifie l'état final du chargement initial (succès ou échec)
    }
  }

  // Arrête le polling pour l'actif courant
  void stopFetchingSingleAsset() {
    _pollingTimer?.cancel(); // Annule le timer s'il existe
    _pollingTimer = null; // Réinitialise la variable du timer
    _currentPollingAssetId = null; // Réinitialise l'ID suivi
    print("Stopped polling.");
    // Optionnel: effacer l'actif des _livePrices si tu ne veux plus le garder en mémoire
    // _livePrices.clear(); // Si tu suis un seul actif à la fois
    // notifyListeners(); // Notifie si tu as effacé des données pour que l'UI se mette à jour
  }

  @override
  void dispose() {
    // IMPORTANT : Arrête le timer quand le provider n'est plus utilisé
    stopFetchingSingleAsset();
    print("MarketDataProvider disposed.");
    super.dispose();
  }
}
