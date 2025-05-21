import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importe le service (qui a la logique statique maintenant)
import '../../../core/services/risk_service.dart'; // Modifié pour importer les deux

// --- Provider pour récupérer les recommandations basées sur le niveau de risque ---

// FutureProvider.family<List<String>, String>
// - Retourne une List<String> (les recommandations).
// - Prend un paramètre de type String (le niveau de risque).
final recommendationsProvider =
FutureProvider.autoDispose.family<List<String>, String>((ref, riskLevel) async {

  print('recommendationsProvider: Exécution pour riskLevel "$riskLevel"');

  // Lire l'instance de RiskService
  final riskService = ref.watch(riskServiceProvider);

  if (riskService == null) {
    print("ERREUR DANS recommendationsProvider: ref.watch(riskServiceProvider) a retourné null!");
    throw StateError("Le service de risque n'est pas disponible.");
  }

  // Appeler la méthode getRecommendations du service (statique)
  try {
    final recommendations = await riskService.getRecommendations(riskLevel);
    print('recommendationsProvider: ${recommendations.length} recommandations récupérées pour "$riskLevel".');
    return recommendations;
  } catch (e, s) {
    print('recommendationsProvider: Erreur lors de l\'appel à getRecommendations pour "$riskLevel": $e\nStackTrace: $s');
    rethrow; // Relance l'erreur pour que l'UI la gère
  }
});