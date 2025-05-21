import 'dart:async'; // Pour Completer et Future
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importe l'état et le service API
import '../../../core/api/api_service.dart';
import 'risk_analysis_state.dart';
import '../../../core/services/api_service.dart'; // Service qui appelle Twelve Data

// StateNotifier gère un état immuable (ici, RiskAnalysisState)
class RiskAnalysisNotifier extends StateNotifier<RiskAnalysisState> {
  // Référence au lecteur de provider Riverpod et à l'ApiService
  final Ref _ref;
  final ApiService _apiService;

  // Constructeur : initialise l'état initial et reçoit les dépendances
  RiskAnalysisNotifier(this._ref)
      : _apiService = _ref.read(apiServiceProvider), // Lit l'instance d'ApiService
        super(const RiskAnalysisState()); // État initial vide (ou avec défauts)

  // --- Méthodes pour mettre à jour les entrées utilisateur ---

  void setSymbol(String newSymbol) {
    // Crée une nouvelle copie de l'état avec le symbole mis à jour
    state = state.copyWith(symbol: newSymbol.toUpperCase()); // Met en majuscules
  }

  void setSelectedDomains(List<String> domains) {
    state = state.copyWith(selectedDomains: domains);
  }

  void setSelectedIndicators(List<String> indicators) {
    state = state.copyWith(selectedIndicators: indicators);
    print("Indicateurs sélectionnés: $indicators");
  }


  // --- Méthode principale pour charger et analyser les données ---
  Future<void> loadAndAnalyzeData() async {
    // Vérifie si le symbole est vide
    if (state.symbol.trim().isEmpty) {
      state = state.copyWith(errorMessage: "Veuillez entrer un symbole boursier.");
      return;
    }
    // Vérifie si au moins un indicateur est sélectionné (ou adapter la logique)
    if (state.selectedIndicators.isEmpty) {
      state = state.copyWith(errorMessage: "Veuillez sélectionner au moins un indicateur.");
      return;
    }


    print('RiskAnalysisNotifier: Début loadAndAnalyzeData pour ${state.symbol}');
    // Met à jour l'état pour indiquer le chargement et réinitialiser les erreurs/résultats
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      apiLimitExceeded: false,
      analysisPerformed: false,
      riskLevel: null,
      riskFactors: [],
      // Réinitialiser aussi les données précédentes ? Oui, c'est plus sûr.
      priceData: null,
      volatilityData: null,
      rsiData: null,
      smaData: null,
      emaData: null,
      macdData: null,
    );

    try {
      // Prépare les appels API nécessaires en parallèle
      final Map<String, Future<Map<String, dynamic>>> apiCalls = {};

      // Appel pour les prix (toujours ?) - À adapter si ce n'est pas le cas
      apiCalls['price'] = _apiService.getPriceData(state.symbol);


      // Ajoute les appels pour les indicateurs sélectionnés
      if (state.selectedIndicators.contains('volatility')) {
        apiCalls['volatility'] = _apiService.getVolatilityData(state.symbol);
      }
      if (state.selectedIndicators.contains('rsi')) {
        apiCalls['rsi'] = _apiService.getRsiData(state.symbol);
      }
      if (state.selectedIndicators.contains('sma')) {
        apiCalls['sma'] = _apiService.getSmaData(state.symbol);
      }
      if (state.selectedIndicators.contains('ema')) {
        apiCalls['ema'] = _apiService.getEmaData(state.symbol);
      }
      if (state.selectedIndicators.contains('macd')) {
        apiCalls['macd'] = _apiService.getMacdData(state.symbol);
      }

      // Attend que tous les appels API se terminent
      final results = await Future.wait(apiCalls.values);

      // Crée une map pour accéder facilement aux résultats par clé
      final Map<String, dynamic> apiResults = {};
      final keys = apiCalls.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        apiResults[keys[i]] = results[i];
      }

      print('RiskAnalysisNotifier: Tous les appels API terminés pour ${state.symbol}');

      // Mettre à jour l'état avec les données reçues
      state = state.copyWith(
        priceData: apiResults['price'],
        volatilityData: apiResults['volatility'],
        rsiData: apiResults['rsi'],
        smaData: apiResults['sma'],
        emaData: apiResults['ema'],
        macdData: apiResults['macd'],
        // Indicateur de chargement passe à false car les données sont là
        // isLoading: false, // Fait dans le finally
        analysisPerformed: true, // Indique que l'analyse peut commencer
      );

      // Effectuer l'analyse des risques (méthode séparée pour la clarté)
      _performRiskAnalysis();

    } catch (e) {
      print('RiskAnalysisNotifier: Erreur lors du chargement des données API: $e');
      // Gérer les erreurs spécifiques (ex: limite API)
      bool limitExceeded = false;
      String errorMsg = e.toString();
      if (e is Exception && e.toString().toLowerCase().contains('api key daily rate limit reached')) {
        limitExceeded = true;
        errorMsg = "Limite d'utilisation de l'API atteinte. Veuillez réessayer plus tard.";
      } else if (e is Exception && e.toString().contains('response.statusCode == 404')) {
        errorMsg = "Symbole '${state.symbol}' non trouvé ou données indisponibles.";
      }
      // ... autres gestions d'erreurs possibles ...


      state = state.copyWith(
        errorMessage: errorMsg,
        apiLimitExceeded: limitExceeded,
        // isLoading: false, // Fait dans le finally
      );
    } finally {
      // Assure que l'indicateur de chargement est désactivé à la fin
      print('RiskAnalysisNotifier: Fin loadAndAnalyzeData (finally).');
      state = state.copyWith(isLoading: false);
    }
  }


  // --- Méthode privée pour analyser les données reçues ---
  void _performRiskAnalysis() {
    print('RiskAnalysisNotifier: Début _performRiskAnalysis');
    String calculatedRiskLevel = 'Non disponible'; // Défaut
    List<String> factors = [];

    // --- Analyse RSI ---
    final rsiValues = state.rsiData?['values'] as List?;
    if (rsiValues != null && rsiValues.isNotEmpty) {
      try {
        // Attention: L'API retourne les plus récents en premier
        final lastRsiValue = rsiValues.first['rsi'];
        if (lastRsiValue is num) { // Vérifie si c'est un nombre
          if (lastRsiValue > 70) {
            calculatedRiskLevel = 'Élevé';
            factors.add('RSI élevé (> 70) indiquant une possible surachat.');
          } else if (lastRsiValue < 30) {
            calculatedRiskLevel = 'Faible';
            factors.add('RSI faible (< 30) indiquant une possible survente.');
          } else {
            // Si le niveau n'est pas déjà Élevé/Faible, on le met à Modéré
            if (calculatedRiskLevel == 'Non disponible') calculatedRiskLevel = 'Modéré';
            factors.add('RSI dans la zone neutre (30-70).');
          }
        } else {
          factors.add('Donnée RSI invalide reçue.');
          print('RiskAnalysisNotifier: Donnée RSI invalide: ${lastRsiValue}');
        }

      } catch (e) {
        factors.add('Erreur analyse RSI: $e');
        print('RiskAnalysisNotifier: Erreur analyse RSI: $e');
      }
    } else if (state.selectedIndicators.contains('rsi')) {
      factors.add('Données RSI non disponibles.');
    }


    // --- Analyse Volatilité (ATR) ---
    final atrValues = state.volatilityData?['values'] as List?;
    if (atrValues != null && atrValues.isNotEmpty) {
      try {
        // Calculer une moyenne ou regarder la dernière valeur ? Prenons la dernière pour simplifier.
        final lastAtrValue = atrValues.first['atr'];
        if (lastAtrValue is num) {
          // Définir des seuils (ces seuils sont arbitraires, à ajuster)
          // Note: L'échelle de l'ATR dépend de l'actif, une comparaison directe est difficile.
          // On pourrait comparer à la moyenne mobile du prix pour normaliser ?
          // Pour l'instant, gardons une logique simple comme dans Angular.
          // Seuil de 0.02 arbitraire (signifierait 2% du prix ? Non, unité absolue)
          // Adapter la logique de seuil si nécessaire.
          // Considérons un ATR "élevé" s'il est significatif (ex > 1$) ?
          // Ou changeons la logique : si ATR augmente, risque augmente ?
          // Simplifions : utilisons les mêmes catégories que pour RSI pour l'instant.
          // (Cette partie nécessiterait une vraie analyse financière)

          // Exemple simple : si l'ATR est > X (ex: 1 pour une action à 100$), risque élevé
          // if (lastAtrValue > 1.0) { // Seuil arbitraire
          //    if (calculatedRiskLevel != 'Élevé') calculatedRiskLevel = 'Modéré'; // Ne pas écraser 'Élevé'
          //    factors.add('Volatilité (ATR) élevée.');
          // }

          // Simplifions encore : on se base QUE sur RSI pour le niveau global pour l'instant
          factors.add('Volatilité (ATR) présente.');


        } else {
          factors.add('Donnée ATR invalide reçue.');
          print('RiskAnalysisNotifier: Donnée ATR invalide: ${lastAtrValue}');
        }
      } catch (e) {
        factors.add('Erreur analyse Volatilité: $e');
        print('RiskAnalysisNotifier: Erreur analyse ATR: $e');
      }
    } else if (state.selectedIndicators.contains('volatility')) {
      factors.add('Données de volatilité (ATR) non disponibles.');
    }

    // --- Autres analyses (SMA, EMA, MACD) ---
    // Ajouter ici la logique si nécessaire, basée sur les croisements, niveaux, etc.
    // Ex: Si MACD < Ligne Signal, facteur de risque baissier, etc.
    if (state.selectedIndicators.contains('sma') && state.smaData != null) factors.add('SMA présente.');
    if (state.selectedIndicators.contains('ema') && state.emaData != null) factors.add('EMA présente.');
    if (state.selectedIndicators.contains('macd') && state.macdData != null) factors.add('MACD présent.');


    // Met à jour l'état final avec les résultats de l'analyse
    state = state.copyWith(
      riskLevel: calculatedRiskLevel,
      riskFactors: factors,
    );
    print('RiskAnalysisNotifier: Fin _performRiskAnalysis. Niveau: $calculatedRiskLevel, Facteurs: $factors');
  }

} // Fin RiskAnalysisNotifier


// --- Configuration Riverpod ---
// StateNotifierProvider gère une instance de notre RiskAnalysisNotifier
// et expose son état (RiskAnalysisState).
final riskAnalysisNotifierProvider = StateNotifierProvider.autoDispose<RiskAnalysisNotifier, RiskAnalysisState>((ref) {
  // Crée l'instance du Notifier en lui passant la référence Riverpod
  return RiskAnalysisNotifier(ref);
});