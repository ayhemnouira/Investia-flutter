import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Pour la navigation

// Importe le modèle et les routes
import '../../../core/models/risk.dart';
import '../../../navigation/app_router.dart';

// Widget StatelessWidget pour afficher un seul risque dans la liste
class RiskListItem extends StatelessWidget {
  final Risk risk;
  final VoidCallback onDelete; // Callback pour déclencher la suppression

  const RiskListItem({
    super.key,
    required this.risk,
    required this.onDelete,
  });

  // Helper pour obtenir une couleur basée sur l'impact et la probabilité (simple)
  Color _getRiskSeverityColor(BuildContext context) {
    final int severity = risk.impact * risk.probability; // Calcul simple du niveau de sévérité
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (severity >= 16) { // 4x4, 5x4, 4x5, 5x5 -> Très Élevé
      return isDarkMode ? Colors.red.shade300 : Colors.red.shade700;
    } else if (severity >= 9) { // 3x3, 4x3, 3x4, 5x2, ... -> Élevé
      return isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700;
    } else if (severity >= 4) { // 2x2, 3x2, 2x3, 4x1, 1x4 -> Modéré
      return isDarkMode ? Colors.yellow.shade400 : Colors.yellow.shade800;
    } else { // Faible
      return isDarkMode ? Colors.green.shade300 : Colors.green.shade700;
    }
  }

  // Helper pour obtenir une icône basée sur la catégorie (exemple)
  IconData _getCategoryIcon() {
    switch (risk.category.toLowerCase()) {
      case 'financier': return Icons.account_balance_wallet_outlined;
      case 'opérationnel': return Icons.settings_outlined;
      case 'stratégique': return Icons.assessment_outlined;
      case 'conformité': return Icons.gavel_rounded;
      case 'cybersécurité': return Icons.security_outlined;
      case 'ressources humaines': return Icons.people_alt_outlined;
      default: return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final severityColor = _getRiskSeverityColor(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      shape: RoundedRectangleBorder( // Ajoute une bordure latérale colorée
        side: BorderSide(color: severityColor, width: 4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell( // Pour l'effet de "ripple" au clic
        borderRadius: BorderRadius.circular(8), // Doit correspondre au Card
        onTap: () {
          // Navigation vers l'édition au clic sur toute la carte
          if (risk.id != null) {
            context.push(AppRoutes.editRiskPath(risk.id!));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impossible d\'ouvrir les détails : ID du risque manquant.'))
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row( // Utilise Row pour mieux contrôler la disposition
            children: [
              // --- Indicateur Visuel (Cercle + Icône Catégorie) ---
              CircleAvatar(
                backgroundColor: severityColor.withOpacity(0.15),
                foregroundColor: severityColor,
                child: Icon(_getCategoryIcon(), size: 20),
              ),
              const SizedBox(width: 16),

              // --- Contenu Principal (Nom, Catégorie, Impact/Proba) ---
              Expanded( // Prend l'espace restant
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      risk.name ?? 'Nom manquant',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Gère les noms longs
                    ),
                    const SizedBox(height: 4),
                    Text(
                      risk.category ?? 'Catégorie manquante',
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    // Afficher Impact et Probabilité
                    Text(
                      'Impact: ${risk.impact} / Probabilité: ${risk.probability}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // --- Boutons d'Action ---
              // On garde les IconButton pour la compacité
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: Colors.orange.shade700,
                iconSize: 20, // Taille réduite
                tooltip: 'Modifier',
                onPressed: () {
                  if (risk.id != null) {
                    context.push(AppRoutes.editRiskPath(risk.id!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Modifier impossible : ID du risque manquant.'))
                    );
                  }
                },
                // Contraintes pour éviter que l'IconButton ne prenne trop de place
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8), // Ajuster le padding
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: colorScheme.error,
                iconSize: 20,
                tooltip: 'Supprimer',
                onPressed: onDelete, // Appelle la callback fournie
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}