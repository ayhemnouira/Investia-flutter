// lib/screens/risk_module_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// IMPORTANT: Adaptez ce chemin pour qu'il pointe vers le app_router.dart
// à l'intérieur du module d'Olsen que vous avez copié.
// Si Olsen a mis son code dans lib/risk_management, alors:
import '../risk_management/navigation/app_router.dart'; // Chemin vers le goRouterProvider d'Olsen

// IMPORTANT: Si le module d'Olsen a son propre thème ou d'autres initialisations
// qui étaient dans son RiskManagementApp, vous devrez les inclure ici.
// Pour l'instant, nous nous concentrons sur le routeur.

class RiskModuleEntryScreen extends ConsumerWidget {
  const RiskModuleEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupère le GoRouter spécifique au module d'Olsen.
    // Note: Ce goRouterProvider est celui DÉFINI DANS LE FICHIER app_router.dart D'OLSEN.
    final riskModuleGoRouter = ref.watch(goRouterProvider as ProviderListenable);

    // Le ProviderScope est déjà fourni par votre main.dart principal,
    // donc le module d'Olsen devrait pouvoir utiliser Riverpod.
    // Nous retournons directement MaterialApp.router configuré avec le routeur d'Olsen.
    // Cela remplacera la pile de navigation actuelle de votre MaterialApp principal
    // par celle du module d'Olsen. Lorsque l'utilisateur quittera ce module
    // (par exemple, avec un bouton "Retour à l'application principale" que vous devrez ajouter
    // dans le module d'Olsen, ou via le bouton retour physique/geste), il reviendra
    // à l'écran précédent de votre application principale.
    //
    // Alternativement, si vous voulez que le module d'Olsen s'exécute "dans" une route
    // de votre application principale (conservant l'AppBar principale, etc.),
    // l'intégration est plus complexe et nécessiterait qu'Olsen n'utilise PAS
    // son propre MaterialApp.router.
    // Vu qu'il utilise MaterialApp.router, nous le lançons comme une "sous-application".

    return MaterialApp.router(
      // Key unique pour éviter les conflits si plusieurs MaterialApp.router sont dans l'arbre.
      // Peu probable dans ce scénario de lancement simple, mais bonne pratique.
      key: const ValueKey('RiskModuleApp'),
      routerConfig: riskModuleGoRouter,
      title: 'Gestion des Risques', // Titre pour ce module spécifique
      debugShowCheckedModeBanner: false, // Vous pouvez contrôler cela
      theme: ThemeData( // Vous pouvez définir un thème spécifique pour ce module ou laisser Olsen le gérer
        primarySwatch: Colors.teal, // Exemple de thème différent
        // Ou, si Olsen a une classe RiskManagementApp qui définit un thème,
        // vous pourriez essayer d'appliquer ce thème ici.
      ),
      // Il est important que le goRouter d'Olsen gère sa propre page d'erreur.
    );
  }
}