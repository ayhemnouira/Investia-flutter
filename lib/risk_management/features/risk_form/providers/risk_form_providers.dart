import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importe le modèle et le service
import '../../../core/models/risk.dart';
import '../../../core/services/risk_service.dart';

// --- Provider pour charger un risque spécifique pour l'édition ---

// FutureProvider.family<TypeRetour, TypeParametre>
// Prend un 'riskId' (int?) en paramètre.
// Si riskId est null, on retourne Future.value(null) (mode ajout).
// Si riskId a une valeur, on appelle le service pour récupérer le risque.
final riskFormProvider = FutureProvider.family<Risk?, int?>((ref, riskId) async {
  print('riskFormProvider: Exécution pour ID $riskId');
  // Si l'ID est null, nous sommes en mode ajout, pas besoin de charger de données.
  if (riskId == null) {
    print('riskFormProvider: Mode ajout (ID null), retourne null.');
    return null; // Indique qu'il n'y a pas de risque initial à charger
  }

  // Si l'ID existe, lire le service et appeler getRiskById
  final riskService = ref.watch(riskServiceProvider);
  print('riskFormProvider: Mode édition (ID $riskId), appel de getRiskById...');
  try {
    final risk = await riskService.getRiskById(riskId);
    print('riskFormProvider: Risque ID $riskId chargé.');
    return risk;
  } catch (e) {
    print('riskFormProvider: Erreur chargement risque ID $riskId: $e');
    // Relancer l'erreur pour que l'UI puisse l'afficher
    rethrow;
  }
});