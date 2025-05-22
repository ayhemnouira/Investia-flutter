import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investia/screens/payment/One_Time_Payment_Page.dart';
import 'package:investia/screens/withdrawal_screen.dart';
import 'package:provider/provider.dart' as provider_pkg;

// --- Écrans de l'application principale ---
import 'package:investia/screens/auth/login_screen.dart';
import 'package:investia/screens/auth/signup_screen.dart';
import 'package:investia/screens/home_screen.dart';
import 'package:investia/screens/news_screen.dart';
import 'package:investia/screens/asset_list_screen.dart';
import 'package:investia/screens/asset_detail_screen.dart';
import 'package:investia/screens/payment/payment_selection_screen.dart';
import 'package:investia/screens/payment/subscription_page.dart';
import 'package:investia/screens/orders/order_screen.dart';
import 'package:investia/screens/main_screen.dart';
import 'package:investia/screens/watchlist_screen.dart';
import 'package:investia/screens/wallet_screen.dart';

// --- Écrans du module Risk Management ---
import 'package:investia/risk_management/features/risk_analysis/views/risk_analysis_screen.dart';
import 'package:investia/risk_management/features/risk_list/views/risk_list_screen.dart';
import 'package:investia/risk_management/features/risk_form/views/risk_form_screen.dart';
import 'package:investia/risk_management/features/recommendations/views/recommendations_screen.dart';

// --- Providers & Services ---
import 'package:investia/providers/auth_provider.dart';

// GlobalKey pour le Navigator racine
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// GlobalKeys pour les navigateurs des branches du Shell
final GlobalKey<NavigatorState> _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorMarketKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellMarket');
final GlobalKey<NavigatorState> _shellNavigatorNewsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellNews');
final GlobalKey<NavigatorState> _shellNavigatorOrdersKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellOrders');
final GlobalKey<NavigatorState> _shellNavigatorRiskKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellRisk');
final GlobalKey<NavigatorState> _shellNavigatorWatchlistKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellWatchlist');
final GlobalKey<NavigatorState> _shellNavigatorWalletKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellWallet');
final GlobalKey<NavigatorState> _shellNavigatorWithdrawKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellWithdraw');

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String marketList = '/market';
  static const String news = '/news';
  static const String orders = '/orders';
  static const String riskManagementList = '/risk-module/list';
  static const String watchlist = '/watchlist';
  static const String wallet = '/wallet';
  static const String withdraw = '/withdraw';
  static const String assetDetail = '/asset-detail/:assetId';
  static String assetDetailPath(String assetId) => '/asset-detail/$assetId';
  static const String paymentServices = '/payment-services';
  static const String oneTimePayment = 'one-time';
  static const String subscriptionPayment = 'subscription';
  static const String riskAnalysis = '/risk-module/analysis';
  static const String addRisk = '/risk-module/list/add';
  static const String editRisk = '/risk-module/list/edit/:riskId';
  static String editRiskPath(int riskId) => '/risk-module/list/edit/$riskId';
  static const String recommendations = '/risk-module/recommendations';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final authProvider =
          provider_pkg.Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isInitialized) {
        try {
          print("Router Redirect: Initializing AuthProvider...");
          await authProvider.initialize();
          print(
              "Router Redirect: AuthProvider initialized. Username: ${authProvider.username}");
        } catch (e) {
          print("Router Redirect: Error initializing AuthProvider: $e");
          if (state.matchedLocation != AppRoutes.login) {
            return AppRoutes.login;
          }
        }
      }
      final isAuthenticated = authProvider.username != null;
      final onAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;
      print(
          "Router Redirect: Path: ${state.matchedLocation}, Authenticated: $isAuthenticated, OnAuthRoute: $onAuthRoute");
      if (!isAuthenticated && !onAuthRoute) {
        print(
            "Router Redirect: Not authenticated and not on auth route. Redirecting to login.");
        return AppRoutes.login;
      }
      if (isAuthenticated && onAuthRoute) {
        print(
            "Router Redirect: Authenticated but on auth route. Redirecting to home.");
        return AppRoutes.home;
      }
      if (isAuthenticated && state.matchedLocation == '/') {
        print(
            "Router Redirect: Authenticated and on root. Redirecting to home.");
        return AppRoutes.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMarketKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.marketList,
                name: AppRoutes.marketList,
                builder: (BuildContext context, GoRouterState state) =>
                    const AssetListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorNewsKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.news,
                name: AppRoutes.news,
                builder: (BuildContext context, GoRouterState state) =>
                    const NewsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorOrdersKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.orders,
                name: AppRoutes.orders,
                builder: (BuildContext context, GoRouterState state) =>
                    const OrderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorRiskKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.riskManagementList,
                name: AppRoutes.riskManagementList,
                builder: (BuildContext context, GoRouterState state) =>
                    const RiskListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWatchlistKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.watchlist,
                name: AppRoutes.watchlist,
                builder: (BuildContext context, GoRouterState state) =>
                    const WatchlistScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWalletKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.wallet,
                name: AppRoutes.wallet,
                builder: (BuildContext context, GoRouterState state) =>
                    const WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWithdrawKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.withdraw,
                name: AppRoutes.withdraw,
                builder: (BuildContext context, GoRouterState state) =>
                    const WithdrawalScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.assetDetail,
        name: AppRoutes.assetDetail,
        builder: (context, state) {
          final assetId = state.pathParameters['assetId'];
          if (assetId == null) {
            return _ErrorScreen(message: "Asset ID manquant pour ${state.uri}");
          }
          return AssetDetailScreen(assetId: assetId);
        },
      ),
      GoRoute(
        path: AppRoutes.paymentServices,
        name: AppRoutes.paymentServices,
        builder: (context, state) => const PaymentSelectionScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.oneTimePayment,
            name: AppRoutes.oneTimePayment,
            builder: (context, state) => OneTimePaymentPage(),
          ),
          GoRoute(
            path: AppRoutes.subscriptionPayment,
            name: AppRoutes.subscriptionPayment,
            builder: (context, state) => SubscriptionPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.riskAnalysis,
        name: AppRoutes.riskAnalysis,
        builder: (context, state) => const RiskAnalysisScreen(),
      ),
      GoRoute(
        path: AppRoutes.addRisk,
        name: AppRoutes.addRisk,
        builder: (context, state) => const RiskFormScreen(riskId: null),
      ),
      GoRoute(
        path: AppRoutes.editRisk,
        name: AppRoutes.editRisk,
        builder: (context, state) {
          final idString = state.pathParameters['riskId'];
          final int? riskId = idString != null ? int.tryParse(idString) : null;
          if (riskId == null) {
            return _ErrorScreen(
                message:
                    "ID de risque invalide pour ${state.uri}: '$idString'");
          }
          return RiskFormScreen(riskId: riskId);
        },
      ),
      GoRoute(
        path: AppRoutes.recommendations,
        name: AppRoutes.recommendations,
        builder: (context, state) {
          final riskLevel = state.extra as String?;
          return RecommendationsScreen(riskLevel: riskLevel);
        },
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(
        message: 'Page non trouvée : ${state.uri}\nErreur: ${state.error}'),
  );
});

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
