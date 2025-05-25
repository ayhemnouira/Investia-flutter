// Fichier : lib/risk_management/features/risk_list/views/risk_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ====== IMPORTS INTERNES DU MODULE DE RISQUE ======
// Assure-toi que ces chemins RELATIFS sont corrects par rapport à la position de ce fichier.

// 1. Importe RiskListItem (même dossier parent /risk_list/)
import '../widgets/risk_list_item.dart'; // Chemin : ../widgets/risk_list_item.dart

// 2. Importe le modèle Risk (sous core/models/)
// Chemin : lib/risk_management/features/risk_list/views/  --> ../../ (risk_list/features) --> ../../../ (risk_management) --> core/models/
import '../../../core/models/risk.dart'; // Chemin : ../../../core/models/risk.dart

// 3. Importe le provider de liste (sous providers/ du même dossier parent /risk_list/)
import '../providers/risk_list_providers.dart'; // Chemin : ../providers/risk_list_providers.dart

// 4. Importe le service provider (sous core/services/)
// Chemin : lib/risk_management/features/risk_list/views/  --> ../../ (risk_list/features) --> ../../../ (risk_management) --> core/services/
import '../../../core/services/risk_service.dart'; // Chemin : ../../../core/services/risk_service.dart (Contient riskServiceProvider)

// 5. Importe les noms de routes internes (AppRoutes) (sous navigation/)
// Chemin : lib/risk_management/features/risk_list/views/  --> ../../ (risk_list/features) --> ../../../ (risk_management) --> navigation/
import '../../../navigation/app_router.dart'; // Chemin : ../../../navigation/app_router.dart (Contient AppRoutes)

// 6. Importe RiskFormScreen (sous risk_form/views/)
// Chemin : lib/risk_management/features/risk_list/views/  --> ../../ (risk_list/features) --> risk_form/views/
import '../../risk_form/views/risk_form_screen.dart'; // Chemin : ../../risk_form/views/risk_form_screen.dart

// 7. Importe RecommendationsScreen (sous recommendations/views/)
// Chemin : lib/risk_management/features/risk_list/views/  --> ../../ (risk_list/features) --> recommendations/views/
import '../../recommendations/views/recommendations_screen.dart'; // Chemin : ../../recommendations/views/recommendations_screen.dart

// =================================================================

// RiskListScreen est un ConsumerWidget
class RiskListScreen extends ConsumerWidget {
  const RiskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Risk>> risksAsyncValue = ref.watch(riskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Risques'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Ajouter un risque',
            onPressed: () {
              context.push(AppRoutes.addRisk);
            },
          ),
        ],
      ),
      body: risksAsyncValue.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Erreur lors du chargement des risques:\n$error',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                    onPressed: () => ref.invalidate(riskListProvider),
                  ),
                ],
              ),
            ),
          );
        },
        data: (risks) {
          if (risks.isEmpty) {
            return const Center(
                child: Text('Aucun risque enregistré pour le moment.'));
          }
          return ListView.builder(
            itemCount: risks.length,
            itemBuilder: (context, index) {
              final risk = risks[index];
              return RiskListItem(
                risk: risk,
                onDelete: () {
                  _showDeleteConfirmationDialog(context, ref, risk);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter un risque',
        onPressed: () {
          context.push(AppRoutes.addRisk);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- MÉTHODE POUR AFFICHER LE DIALOGUE DE CONFIRMATION DE SUPPRESSION ---
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, Risk risk) async {
    final int? riskId = risk.id;
    if (riskId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Impossible de supprimer : ID du risque manquant.')));
      return;
    }
    final String riskName = risk.name ?? 'Risque sans nom';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Consumer(builder: (context, dialogRef, child) {
          return AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
              Text(
                  'Êtes-vous sûr de vouloir supprimer le risque "$riskName" (ID: $riskId) ?'),
              const Text('Cette action est irréversible.',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ])),
            actions: <Widget>[
              TextButton(
                  child: const Text('Annuler'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  }),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Supprimer'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  try {
                    // Appelle le service via son provider Riverpod
                    await dialogRef
                        .read(riskServiceProvider)
                        .deleteRisk(riskId);

                    print('Suppression réussie via service pour ID: $riskId');

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Risque "$riskName" (ID: $riskId) supprimé.')),
                    );

                    // Invalide le provider de la liste pour rafraîchir
                    dialogRef.invalidate(riskListProvider);
                  } catch (e) {
                    print(
                        'Erreur lors de la tentative de suppression pour ID $riskId: $e');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Erreur lors de la suppression du risque ID $riskId: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error));
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }
}
