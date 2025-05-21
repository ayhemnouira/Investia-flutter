import 'package:flutter/foundation.dart'; // Pour @immutable
import 'package:freezed_annotation/freezed_annotation.dart'; // Pour Freezed

// Importe les modèles si nécessaire (ici, on stocke les données brutes)
// import '../../../core/models/stock_data.dart'; // Si on avait un modèle typé

part 'risk_analysis_state.freezed.dart'; // Généré par Freezed

// Utilisation de Freezed pour générer automatiquement le code rébarbatif
// (constructeur, copyWith, ==, hashCode, toString) pour les classes d'état.
// C'est une pratique très courante et recommandée en Flutter/Riverpod.
@freezed
class RiskAnalysisState with _$RiskAnalysisState {
  const factory RiskAnalysisState({
    // --- Entrées utilisateur ---
    @Default('AAPL') String symbol, // Symbole boursier saisi
    @Default([]) List<String> selectedDomains, // Domaines sélectionnés
    @Default([]) List<String> selectedIndicators, // Indicateurs sélectionnés

    // --- État de chargement et erreurs ---
    @Default(false) bool isLoading, // Indicateur de chargement global
    String? errorMessage, // Message d'erreur général
    @Default(false) bool apiLimitExceeded, // Flag spécifique pour l'erreur 429

    // --- Données reçues de l'API ---
    // Stocke les données JSON brutes (Map) ou des objets de modèle typés
    Map<String, dynamic>? priceData,
    Map<String, dynamic>? volatilityData, // ATR
    Map<String, dynamic>? rsiData,
    Map<String, dynamic>? smaData,
    Map<String, dynamic>? emaData,
    Map<String, dynamic>? macdData,

    // --- Résultats de l'analyse ---
    @Default(false) bool analysisPerformed, // Indique si une analyse a eu lieu
    String? riskLevel, // 'Élevé', 'Modéré', 'Faible', 'Non disponible'
    @Default([]) List<String> riskFactors, // Facteurs identifiés

  }) = _RiskAnalysisState; // Classe privée générée par Freezed

// Optionnel: ajouter un constructeur initial si besoin
// const RiskAnalysisState.initial() : this(symbol: 'AAPL');
}