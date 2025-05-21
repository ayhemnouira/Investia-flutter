import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importe le provider
import '../providers/recommendations_providers.dart';

class RecommendationsScreen extends ConsumerWidget {
  final String? riskLevel;

  const RecommendationsScreen({super.key, required this.riskLevel});

  // --- Helper pour l'icône (peut être affiné) ---
  IconData _getRecommendationIcon(String recommendation) {
    final lowerCaseRec = recommendation.toLowerCase();
    if (lowerCaseRec.contains('diversifi')) return Icons.pie_chart_outline_rounded; // Icône arrondie
    if (lowerCaseRec.contains('réduire') || lowerCaseRec.contains('couverture')) return Icons.trending_down_rounded;
    if (lowerCaseRec.contains('actif moins risqué') || lowerCaseRec.contains('épargne')) return Icons.savings_outlined;
    if (lowerCaseRec.contains('conseiller') || lowerCaseRec.contains('consultation')) return Icons.support_agent_rounded; // Icône agent
    if (lowerCaseRec.contains('surveiller')) return Icons.visibility_outlined;
    if (lowerCaseRec.contains('achat')) return Icons.add_shopping_cart_rounded; // Icône différente
    if (lowerCaseRec.contains('stop-loss')) return Icons.shield_outlined;
    return Icons.lightbulb_outline_rounded; // Icône ampoule par défaut
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context); // Accès au thème

    if (riskLevel == null || riskLevel!.trim().isEmpty) {
      print("RecommendationsScreen: Erreur - riskLevel est null ou vide.");
      return Scaffold( /* ... Erreur si riskLevel manquant ... */
        appBar: AppBar(title: const Text('Erreur')), body: const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Niveau de risque non fourni ou invalide.\nImpossible d\'afficher les recommandations.', textAlign: TextAlign.center))),
      );
    }

    final asyncRecommendations = ref.watch(recommendationsProvider(riskLevel!));
    print("RecommendationsScreen: Build pour riskLevel '$riskLevel' - État Async: $asyncRecommendations");

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommandations ($riskLevel)'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      // Ajout d'un fond légèrement différent pour la page
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: asyncRecommendations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) { /* ... Affichage Erreur avec bouton Réessayer ... */
          print("RecommendationsScreen: Erreur chargement recommandations: $error\n$stack");
          return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text('Erreur lors du chargement des recommandations pour "$riskLevel":\n$error', style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center), const SizedBox(height: 20), ElevatedButton.icon(icon: const Icon(Icons.refresh), label: const Text('Réessayer'), onPressed: () => ref.invalidate(recommendationsProvider(riskLevel!))) ])));
        },
        data: (recommendations) {
          print("RecommendationsScreen: Affichage de ${recommendations.length} recommandations.");
          if (recommendations.isEmpty) {
            return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Aucune recommandation spécifique disponible pour ce niveau de risque.', textAlign: TextAlign.center)));
          }

          // === ListView avec Padding et potentiellement Header/Footer ===
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0), // Padding global
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              final iconData = _getRecommendationIcon(recommendation);

              // --- Carte Améliorée ---
              return Card(
                elevation: 3, // Légère ombre plus marquée
                margin: const EdgeInsets.only(bottom: 12.0), // Espace seulement en bas
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Coins plus arrondis
                ),
                child: InkWell( // Effet au clic
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () { // Action au clic sur la carte (similaire au bouton)
                    print('Carte cliquée: "$recommendation"');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Action pour "$recommendation" déclenchée (Simulation).'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Padding interne augmenté
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alignement vertical
                      children: [
                        // Icône plus grande et colorée
                        Icon(
                          iconData,
                          color: theme.colorScheme.primary,
                          size: 32, // Taille augmentée
                        ),
                        const SizedBox(width: 16),
                        // Texte de la recommandation
                        Expanded(
                          child: Text(
                            recommendation,
                            style: theme.textTheme.bodyLarge, // Taille de texte légèrement augmentée
                          ),
                        ),
                        // Optionnel: Garder une action discrète (ex: info)
                        // IconButton(
                        //   icon: Icon(Icons.info_outline, color: Colors.grey),
                        //   tooltip: 'Plus d'infos (non implémenté)',
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}