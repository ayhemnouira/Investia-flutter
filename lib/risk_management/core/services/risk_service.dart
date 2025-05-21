import 'dart:async'; // Pour Future.delayed
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importe notre modèle de données Risk
import '../models/risk.dart';

// --- Liste de données statiques ---
// Simule les données qui viendraient normalement du backend.
final List<Risk> _staticRisks = [
  Risk(
    id: 1,
    name: 'Perte de Données Majeure',
    description: 'Risque de perte irrécupérable de données client critiques suite à une panne matérielle ou une cyberattaque.',
    category: 'Cybersécurité',
    impact: 5, // Très élevé
    probability: 2, // Faible
    owner: 'Département IT',
    mitigationPlan: 'Sauvegardes quotidiennes hors site, plan de reprise après sinistre testé trimestriellement.',
  ),
  Risk(
    id: 2,
    name: 'Retard Projet Alpha',
    description: 'Le projet Alpha risque de dépasser les délais prévus en raison de dépendances externes non maîtrisées.',
    category: 'Opérationnel',
    impact: 3, // Modéré
    probability: 4, // Élevée
    owner: 'Chef de Projet Alpha',
    mitigationPlan: 'Suivi hebdomadaire des dépendances, allocation de ressources supplémentaires si nécessaire.',
  ),
  Risk(
    id: 3,
    name: 'Non-conformité RGPD',
    description: 'Risque d\'amendes importantes suite à une mauvaise gestion des données personnelles.',
    category: 'Conformité',
    impact: 4, // Élevé
    probability: 3, // Modérée
    owner: 'Responsable Juridique',
    mitigationPlan: 'Audit RGPD annuel, formation des employés, mise à jour de la politique de confidentialité.',
  ),
  Risk(
    id: 4,
    name: 'Fluctuation Marché Fournisseur Clé',
    description: 'Instabilité financière d\'un fournisseur essentiel pouvant impacter notre chaîne d\'approvisionnement.',
    category: 'Financier',
    impact: 4, // Élevé
    probability: 2, // Faible
    owner: 'Département Achats',
    mitigationPlan: 'Identification et qualification de fournisseurs alternatifs, négociation de contrats long terme.',
  ),
];
// Pour simuler l'auto-incrémentation des ID lors de l'ajout
int _nextId = 5;


// Classe RiskService modifiée pour fonctionner avec des données statiques
class RiskService {

  // Simule une latence réseau pour rendre l'expérience plus réaliste
  final Duration _networkDelay = const Duration(milliseconds: 700);

  // --- Récupérer tous les risques (Read) ---
  Future<List<Risk>> getRisks() async {
    print('RiskService (Static): Récupération des risques...');
    // Attend un peu pour simuler un appel réseau
    await Future.delayed(_networkDelay);
    print('RiskService (Static): Retourne la liste statique (${_staticRisks.length} risques).');
    // Retourne une copie de la liste pour éviter les modifications externes accidentelles
    return List<Risk>.from(_staticRisks);
  }

  // --- Récupérer un risque par ID (Read) ---
  Future<Risk> getRiskById(int id) async {
    print('RiskService (Static): Recherche du risque ID $id...');
    await Future.delayed(_networkDelay);
    try {
      // Trouve le premier risque correspondant à l'ID dans la liste statique
      final risk = _staticRisks.firstWhere((r) => r.id == id);
      print('RiskService (Static): Risque ID $id trouvé.');
      return risk;
    } catch (e) {
      // Si firstWhere ne trouve rien, il lance une exception StateError
      print('RiskService (Static): Risque ID $id non trouvé.');
      throw Exception('Risque non trouvé (ID: $id)');
    }
  }

  // --- Ajouter un nouveau risque (Create) ---
  // Simule l'ajout à la liste statique
  Future<Risk> addRisk(Risk riskToAdd) async {
    print('RiskService (Static): Ajout du risque "${riskToAdd.name}"...');
    await Future.delayed(_networkDelay);

    // Crée une nouvelle instance avec un nouvel ID simulé
    final newRisk = riskToAdd.copyWith(id: _nextId++); // Utilise copyWith pour assigner l'ID

    // Ajoute le nouveau risque à la liste statique en mémoire
    _staticRisks.add(newRisk);

    print('RiskService (Static): Risque ajouté avec ID ${newRisk.id}. Nouvelle taille liste: ${_staticRisks.length}');
    return newRisk; // Retourne le risque avec son nouvel ID
  }

  // --- Mettre à jour un risque existant (Update) ---
  // Simule la mise à jour dans la liste statique
  Future<Risk> updateRisk(int id, Risk riskToUpdate) async {
    print('RiskService (Static): Mise à jour du risque ID $id...');
    await Future.delayed(_networkDelay);

    // Trouve l'index du risque à mettre à jour
    final index = _staticRisks.indexWhere((r) => r.id == id);

    if (index != -1) {
      // Assure que l'ID dans l'objet correspond à l'ID demandé (bonne pratique)
      final updatedRisk = riskToUpdate.copyWith(id: id);
      // Remplace l'ancien risque par le nouveau dans la liste statique
      _staticRisks[index] = updatedRisk;
      print('RiskService (Static): Risque ID $id mis à jour.');
      return updatedRisk;
    } else {
      print('RiskService (Static): Risque ID $id non trouvé pour la mise à jour.');
      throw Exception('Risque non trouvé pour la mise à jour (ID: $id)');
    }
  }

  // --- Supprimer un risque (Delete) ---
  // Simule la suppression de la liste statique
  Future<void> deleteRisk(int id) async {
    print('RiskService (Static): Suppression du risque ID $id...');
    await Future.delayed(_networkDelay);

    // Supprime le risque de la liste statique en mémoire
    final initialLength = _staticRisks.length;
    _staticRisks.removeWhere((r) => r.id == id);

    if (_staticRisks.length < initialLength) {
      print('RiskService (Static): Risque ID $id supprimé. Nouvelle taille liste: ${_staticRisks.length}');
      // Succès, retourne void (implicitement null)
    } else {
      print('RiskService (Static): Risque ID $id non trouvé pour la suppression.');
      // On pourrait lancer une exception, mais pour la simulation,
      // on peut aussi juste ne rien faire ou retourner un succès silencieux.
      // throw Exception('Risque non trouvé pour la suppression (ID: $id)');
    }
  }

  // --- Récupérer les recommandations (Read) ---
  // Retourne des recommandations statiques basées sur le niveau de risque
  Future<List<String>> getRecommendations(String riskLevel) async {
    print('RiskService (Static): Récupération des recommandations pour le niveau "$riskLevel"...');
    await Future.delayed(const Duration(milliseconds: 300)); // Délai plus court

    // Simule des recommandations différentes selon le niveau
    switch (riskLevel.toLowerCase()) {
      case 'élevé':
      case 'eleve': // Accepter variations
        return [
          "Réduire l'exposition immédiatement.",
          "Envisager des stratégies de couverture (hedging).",
          "Diversifier le portefeuille vers des actifs moins corrélés.",
          "Consulter un conseiller financier spécialisé.",
        ];
      case 'modéré':
      case 'modere':
        return [
          "Surveiller attentivement l'actif.",
          "Ne pas augmenter l'exposition actuelle.",
          "Renforcer les analyses techniques et fondamentales.",
          "Préparer des ordres stop-loss.",
        ];
      case 'faible':
        return [
          "Actif potentiellement intéressant pour un achat.",
          "Maintenir la position si déjà détenue.",
          "Continuer la surveillance régulière.",
        ];
      default:
        return [
          "Niveau de risque non reconnu. Analyse approfondie requise.",
        ];
    }
  }

} // Fin de la classe RiskService

// --- Configuration Riverpod ---
// Le provider reste le même, il fournira une instance de ce RiskService statique.
final riskServiceProvider = Provider<RiskService>((ref) {
  return RiskService();
});