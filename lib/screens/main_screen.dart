// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Importez AppRoutes pour les chemins des onglets
import 'package:investia/risk_management/navigation/app_router.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  void _onTap(BuildContext context, int index) {
    // Utilise navigationShell.goBranch pour naviguer vers la branche correspondante
    // L'index doit correspondre à l'ordre des StatefulShellBranch dans la configuration de GoRouter
    navigationShell.goBranch(
      index,
      // Si la branche est déjà active, on peut choisir de revenir à la première page de cette branche
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Les écrans sont maintenant gérés par le navigationShell
    // final List<Widget> _screens = [
    //   const HomeScreen(),
    //   const AssetListScreen(), // Votre ancien MarketScreen
    //   const NewsScreen(),
    //   const OrderScreen(),
    //   // Ajoutez ici l'écran pour la liste des risques si vous voulez un onglet dédié
    //   // const RiskListScreen(), // Exemple
    // ];

    return Scaffold(
      appBar: AppBar(
        title: _getTitleForIndex(navigationShell.currentIndex),
        // Vous pouvez ajouter des actions globales à l'AppBar ici si nécessaire
      ),
      body: navigationShell, // Affiche le contenu de la branche active
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Pour plus de 3 items
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory_outlined),
            activeIcon: Icon(Icons.store_mall_directory_rounded),
            label: 'Marché',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article_rounded),
            label: 'Actualités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Ordres',
          ),
          BottomNavigationBarItem( // Nouvel onglet pour la Gestion des Risques (Liste)
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield_rounded),
            label: 'Risques',
          ),
        ],
      ),
    );
  }

  // Helper pour obtenir le titre de l'AppBar en fonction de l'onglet actif
  Widget _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return const Text('InvestIA Dashboard');
      case 1:
        return const Text('Marché des Actifs');
      case 2:
        return const Text('Actualités Financières');
      case 3:
        return const Text('Gestion des Ordres');
      case 4:
        return const Text('Gestion des Risques');
      default:
        return const Text('InvestIA');
    }
  }
}