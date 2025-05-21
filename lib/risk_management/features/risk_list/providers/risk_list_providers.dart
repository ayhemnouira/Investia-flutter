// Fichier : lib/risk_management/features/risk_list/providers/risk_list_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Nécessaire pour Riverpod

// ====== IMPORTS DES DÉPENDANCES INTERNES DU MODULE DE RISQUE ======
// Tu dois importer ici les fichiers internes du module de risque d'Olsen
// qui sont utilisés dans ce provider.
// Ces chemins sont RELATIFS à la localisation du fichier risk_list_providers.dart
// (qui est dans lib/risk_management/features/risk_list/providers/)

// 1. Importe le modèle Risk. Il se trouve sous core/models/ dans le module de risque.
//    Chemin de : lib/risk_management/features/risk_list/providers/risk_list_providers.dart
//    Vers : lib/risk_management/core/models/risk.dart
//    Il faut remonter 3 niveaux (../../../) puis descendre dans core/models/
import '../../../core/models/risk.dart'; // <-- ASSURE-TOI QUE CE CHEMIN RELATIF EST CORRECT

// 2. Importe le service provider Riverpod pour RiskService. Il se trouve sous core/services/ dans le module de risque.
//    Le service provider lui-même est probablement défini dans un fichier sous core/services/ ou core/providers/.
//    D'après l'analyse précédente, Olsen avait des providers sous core/services/,
//    et il importait 'package:risk_management_app/core/services/risk_service.dart' pour la classe et le provider.
//    Trouve où le 'riskServiceProvider' est défini dans les fichiers core/services/ ou core/providers/ d'Olsen.
//    Supposons pour l'exemple que le provider est défini dans 'risk_service_providers.dart' sous core/services/.
//    Chemin de : lib/risk_management/features/risk_list/providers/risk_list_providers.dart
//    Vers : lib/risk_management/core/services/risk_service_providers.dart (ou le fichier qui définit riskServiceProvider)
//    Il faut remonter 3 niveaux (../../../) puis descendre dans core/services/
import '../../../core/services/risk_service.dart'; // <-- ASSURE-TOI QUE CE CHEMIN RELATIF ET LE NOM DU FICHIER SONT CORRECTS et qu'ils définissent riskServiceProvider

// Tu n'as PAS besoin d'importer la CLASSE RiskService elle-même si tu utilises seulement le provider (ref.watch(riskServiceProvider))
// import 'package:risk_management_app/core/services/risk_service.dart'; // <-- Probablement pas nécessaire ici, sauf si la classe est utilisée pour typer une variable locale.

// ==================================================================


// --- Provider pour récupérer la liste des risques ---

// Définition du FutureProvider global et final (Riverpod)
final riskListProvider = FutureProvider.autoDispose<List<Risk>>((ref) async {
  // On utilise autoDispose pour que le provider soit nettoyé quand il n'est plus écouté.

  // Imprime un message de débogage (optionnel)
  // print('riskListProvider: Exécution du FutureProvider...');

  // ====== OBTENIR LE SERVICE DE RISQUE EN UTILISANT LE PROVIDER RIVERPOD CORRESPONDANT ======
  // ref.watch(riskServiceProvider) va donner l'instance de RiskService configurée par ce provider.
  final riskService = ref.watch(riskServiceProvider); // <-- Utilise le provider Riverpod pour obtenir l'instance du service

  // Ajoutons une vérification explicite au cas où le provider ne soit pas configuré correctement (devrait pas arriver si ProviderScope est bien placé et le provider est défini).
  // if (riskService == null) { // Si riskServiceProvider retourne un Future, riskService peut être null initialement ou dans un état AsyncData/AsyncError.
  //    // Si riskServiceProvider retourne un Future<RiskService>, tu devrais le lire différemment, ex: ref.watch(riskServiceProvider).value
  //    // Mais généralement, un service est exposé comme un Provider simple ou un FutureProvider<Service>.
  //    // Si riskServiceProvider est un Provider<RiskService>, ref.watch(riskServiceProvider) donne directement l'instance.
  //    // Si riskServiceProvider est un FutureProvider<RiskService>, ref.watch(riskServiceProvider) donne un AsyncValue, et tu devrais utiliser ref.watch(riskServiceProvider).value pour obtenir l'instance ou null.
  //    // Basons-nous sur l'hypothèse la plus simple : riskServiceProvider est un Provider<RiskService>.
  //    print("ERREUR DANS riskListProvider: Le service de risque n'est pas disponible via riskServiceProvider.");
  //    throw StateError("Le service de risque n'est pas disponible.");
  // }

  // Imprime un message de débogage (optionnel)
  // print('riskListProvider: Appel de riskService.getRisks()');

  // ====== APPEL À LA MÉTHODE getRisks DU SERVICE ======
  try {
    final risks = await riskService.getRisks(); // Appelle la méthode asynchrone du service
    // print('riskListProvider: Récupération de ${risks.length} risques terminée.');
    return risks; // Retourne la liste des risques (FutureProvider renvoie la valeur du Future)
  } catch (e, s) {
    // En cas d'erreur, imprimer le message et le stack trace
    print('riskListProvider: Erreur lors de l\'appel à getRisks: $e\nStackTrace: $s');
    // Relancer l'erreur. Le .when() dans l'UI (RiskListScreen) traitera cette erreur.
    rethrow;
  }
});