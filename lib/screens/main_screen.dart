// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Importez AppRoutes pour les chemins des onglets
import 'package:investia/risk_management/navigation/app_router.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

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
    print(
        'MainScreen build, current index: ${navigationShell.currentIndex}, branches: ${navigationShell.route.branches.length}');
    return Scaffold(
      appBar: AppBar(
        title: _getTitleForIndex(navigationShell.currentIndex),
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield_rounded),
            label: 'Risques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outlined),
            activeIcon: Icon(Icons.star_rounded),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off_outlined),
            activeIcon: Icon(Icons.money_off_rounded),
            label: 'Withdrawal',
          ),
        ],
      ),
    );
  }

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
      case 5:
        return const Text('Liste de Suivi');
      case 6:
        return const Text('Portefeuille');
      case 7:
        return const Text('Retraits');
      default:
        return const Text('InvestIA');
    }
  }
}
