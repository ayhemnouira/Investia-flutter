import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assure-toi que ces chemins d'imports sont corrects dans ton projet !
import '../../models/order_model.dart'; // <-- ASSURE-TOI DE CE CHEMIN (Exemple si OrderModel est dans lib/models/orders/)
import '../../providers/order_provider.dart'; // <-- ASSURE-TOI DE CE CHEMIN (Exemple si OrderProvider est dans lib/providers/orders/)
import '../../services/notification_service.dart'; // <-- ASSURE-TOI DE CE CHEMIN (Exemple si NotificationService est dans lib/services/notifications/)

// Si OrderModel ou d'autres modèles du module d'Amira utilisent Hive,
// assure-toi d'avoir copié les fichiers .g.dart et d'enregistrer les adapters dans main.dart.

// Importe la classe Order (si elle est définie séparément et utilisée ici, comme dans le code copié)
// D'après le code, Order est utilisé dans le map() avant executeRebalance.
// Vraisemblablement, la classe Order se trouve dans order_model.dart, ou dans un fichier séparé.
// Si elle n'est pas définie dans order_model.dart, tu devras trouver son fichier source et l'importer ici.
// Sinon, assure-toi qu'elle est définie DANS order_model.dart.
// class Order { ... } // <-- Si Order est défini ici, le chemin d'import de order_model.dart est correct.

// Ajoute l'import nécessaire pour SocketException et FormatException si tu les gères dans les try/catch
// import 'dart:io'; // Pour SocketException
// import 'dart:async'; // Peut être utile pour des opérations asynchrones

// ====== CORRECTION ICI : Déclare RebalanceScreen comme un StatefulWidget ======
class RebalanceScreen extends StatefulWidget {
  const RebalanceScreen({super.key});

  @override
  _RebalanceScreenState createState() =>
      _RebalanceScreenState(); // Crée l'état associé
}

// ====== NOUVELLE CLASSE STATE ASSOCIÉE ======
class _RebalanceScreenState extends State<RebalanceScreen> {
  // Optionnel: Déclare des variables d'état spécifiques à l'écran ici si nécessaire.
  // Les données (rebalanceRecommendations) et l'état de chargement sont gérés par le Provider, donc pas besoin de les dupliquer ici.

  @override
  void initState() {
    super.initState();
    // ====== LOGIQUE DE CHARGEMENT INITIAL ICI DANS initState ======
    // Obtient le provider avec listen: false car nous ne voulons pas déclencher de rebuild ici.
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Déclenche le fetch si les données ne sont pas déjà chargées et qu'il n'y a pas d'erreur précédente
    // (ajustement basé sur ta logique build d'origine)
    // Une meilleure approche est de toujours déclencher le fetch ici et laisser le provider gérer s'il doit re-fetcher (ex: s'il est déjà isLoading ou a des données)
    // ou simplement appeler fetchRebalanceRecommendations qui vérifie si un chargement est déjà en cours.
    // Simplifions pour l'instant en appelant fetch si la liste est vide au démarrage.
    if (orderProvider.rebalanceRecommendations.isEmpty) {
      // Utilise WidgetsBinding.instance.addPostFrameCallback si le fetch dépend du contexte (rare pour un simple fetch)
      orderProvider
          .fetchRebalanceRecommendations(); // Appelle la méthode du Provider pour charger les données
    } else {
      // Si les données sont déjà là (ex: écran revisité, hot reload), tu peux choisir de rafraîchir ou non.
      // Pour ce cas, on ne fait rien si la liste n'est pas vide, on affiche les données actuelles.
    }
    // ==========================================================
  }

  // La méthode build est déplacée ici dans la classe State
  @override
  Widget build(BuildContext context) {
    // Obtient le provider AVEC listen: true (ou context.watch) pour que le widget rebuild lorsque l'état change (isLoading, rebalanceRecommendations).
    final orderProvider = Provider.of<OrderProvider>(
        context); // Écoute le provider pour les changements

    return Padding(
      // Garde le padding comme conteneur racine
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // Colonne principale
        crossAxisAlignment: CrossAxisAlignment
            .stretch, // Étire les enfants (texte, liste, bouton)
        children: [
          const Text(
            'AI Portfolio Rebalancing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Centre le titre
          ),
          const SizedBox(height: 20), // Espacement

          // Contenu principal : Indicateur de chargement, message vide, ou liste de recommandations
          Expanded(
            // Permet à la liste de prendre l'espace restant
            child: orderProvider.isLoading &&
                    orderProvider.rebalanceRecommendations
                        .isEmpty // Affiche spinner si chargement ET liste vide (pour ne pas cacher le cache)
                ? const Center(child: CircularProgressIndicator())
                : orderProvider.errorMessage != null &&
                        orderProvider.rebalanceRecommendations
                            .isEmpty // Affiche erreur si erreur ET liste vide
                    ? Center(
                        child: Column(
                          // Centre le contenu de l'erreur
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 50),
                            const SizedBox(height: 10),
                            Text(
                              orderProvider
                                  .errorMessage!, // Affiche le message d'erreur du provider
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => orderProvider
                                  .fetchRebalanceRecommendations(), // Bouton Retry
                              child: const Text("Réessayer"),
                            ),
                          ],
                        ),
                      )
                    : orderProvider.rebalanceRecommendations
                            .isEmpty // Affiche message vide si liste vide (et pas en chargement ou erreur gérée)
                        ? const Center(
                            child: Text(
                                "Aucune recommandation de rééquilibrage disponible pour l'instant."))
                        : ListView.builder(
                            // Affiche la liste si des recommandations sont présentes
                            itemCount:
                                orderProvider.rebalanceRecommendations.length,
                            itemBuilder: (context, index) {
                              final recommendation =
                                  orderProvider.rebalanceRecommendations[index];
                              // Widget Card pour chaque recommandation
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical:
                                        4.0), // Marge verticale entre les cartes
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recommendation.assetName ??
                                            'N/A', // Utilise N/A si le nom est null
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Current: ${recommendation.currentPercentage ?? 'N/A'}%'), // Gère null
                                          Text(
                                              'Target: ${recommendation.targetPercentage ?? 'N/A'}%'), // Gère null
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Gère les valeurs nulles pour amountToAdjust et assure le formatage
                                      Text(
                                        'Action: ${recommendation.amountToAdjust != null ? (recommendation.amountToAdjust > 0 ? 'BUY' : 'SELL') : 'N/A'} ${recommendation.amountToAdjust != null ? recommendation.amountToAdjust.abs() : ''}',
                                        style: TextStyle(
                                          color: recommendation
                                                      .amountToAdjust !=
                                                  null
                                              ? (recommendation.amountToAdjust >
                                                      0
                                                  ? Colors.green
                                                  : Colors.red)
                                              : Colors
                                                  .grey, // Couleur grise si la valeur est null
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),

          const SizedBox(height: 20), // Espacement avant le bouton

          // Bouton d'exécution du rééquilibrage
          ElevatedButton(
            // Optionnel: Désactiver le bouton si le chargement est en cours ou s'il n'y a pas de recommandations
            // onPressed: (orderProvider.isLoading || orderProvider.rebalanceRecommendations.isEmpty) ? null : () async { ... }
            onPressed: () async {
              // Récupère à nouveau le provider ici si tu utilises context dans une async gap
              // ou passe context si NotificationService en a besoin et que c'est un service statique
              // final orderProvider = Provider.of<OrderProvider>(context, listen: false); // Obtient le provider sans écouter
              // final success = await orderProvider.executeRebalance(orders);
              // if (success && mounted) { // <-- 'mounted' est disponible dans l'état
              //   NotificationService.showRebalanceNotification(context, orders.length); // Passe context si nécessaire
              // }

              // Ton code existant utilisant mounted et OrderProvider
              final orders = orderProvider.rebalanceRecommendations.map((rec) {
                // Assure-toi que Order a un constructeur compatible ou une méthode fromRecommendation
                // Vérifie que les champs assetId, amountToAdjust, assetName, etc. sont disponibles dans recommendation
                // et correspondent aux champs requis par Order.
                // L'ID de l'ordre est probablement généré côté backend ou par le service, pas en dur ici.
                return Order(
                  // <-- Assure-toi que Order est importé/défini
                  id: '', // L'ID devrait probablement être généré ou non requis ici
                  assetId: rec.assetId ??
                      '', // Gère les valeurs nulles si elles peuvent l'être
                  assetName: rec.assetName ?? 'N/A',
                  amount: rec.amountToAdjust != null
                      ? rec.amountToAdjust.abs()
                      : 0, // Gère null
                  price: 0, // Le prix au moment de l'ordre est important
                  date: DateTime.now(),
                  type: rec.amountToAdjust != null
                      ? (rec.amountToAdjust > 0
                          ? OrderType.buy
                          : OrderType.sell)
                      : OrderType.buy, // Gère null, type par défaut si null
                );
              }).toList();

              // Exécute le rééquilibrage via le provider
              // La méthode executeRebalance doit être implémentée dans OrderProvider
              // et elle doit appeler le OrderService pour envoyer les ordres au backend.
              final success = await orderProvider.executeRebalance(orders);

              // Vérifie 'mounted' avant d'afficher une notification ou un SnackBar
              // 'mounted' est disponible car nous sommes dans une méthode de _RebalanceScreenState
              if (success && mounted) {
                // <-- 'mounted' est maintenant valide !
                // Assure-toi que NotificationService.showRebalanceNotification existe
                // et qu'il prend un BuildContext s'il a besoin d'afficher un SnackBar/Dialog
                NotificationService.showRebalanceNotification(
                  context, // Passe le contexte ici si nécessaire
                  orders.length,
                );
                // Optionnel: Rafraîchir la liste ou afficher un message de succès
                // orderProvider.fetchRebalanceRecommendations(); // Pour recharger après exécution
              } else if (!success && mounted) {
                // Gérer l'échec de l'exécution (afficher un message d'erreur par exemple)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Échec de l\'exécution du rééquilibrage.')),
                );
              }
            },
            child: const Text('Execute Rebalance'),
          ),
        ],
      ),
    );
  }

  // N'oublie pas la méthode dispose() si des TextEditingController ou autres sont utilisés et doivent être nettoyés
  // @override
  // void dispose() {
  //   // myController.dispose(); // Exemple de nettoyage
  //   super.dispose();
  // }
}

// Assure-toi que tes modèles Order et RebalanceRecommendation sont définis et importés correctement.
// Par exemple, si RebalanceRecommendation est un modèle séparé dans order_model.dart :
/*
class RebalanceRecommendation {
  final String assetId;
  final String assetName;
  final double currentPercentage;
  final double targetPercentage;
  final double amountToAdjust; // Montant positif pour BUY, négatif pour SELL

  RebalanceRecommendation({...});

  // Assure-toi d'avoir un fromJson ou une logique de création
}

// Assure-toi que OrderType est un enum ou une classe définie
enum OrderType { buy, sell }
*/
