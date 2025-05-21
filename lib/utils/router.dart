// lib/risk_management/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Pour la définition du goRouterProvider
import 'package:provider/provider.dart' as provider_pkg; // Pour AuthProvider

// --- Écrans de l'application principale ---
import 'package:investia/screens/auth/login_screen.dart';
import 'package:investia/screens/auth/signup_screen.dart';
import 'package:investia/screens/home_screen.dart';
import 'package:investia/screens/news_screen.dart';
import 'package:investia/screens/asset_list_screen.dart';
import 'package:investia/screens/asset_detail_screen.dart';
import 'package:investia/screens/payment/payment_selection_screen.dart';
import 'package:investia/screens/payment/one_time_payment_page.dart';
import 'package:investia/screens/payment/subscription_page.dart';
import 'package:investia/screens/orders/order_screen.dart';
import 'package:investia/screens/main_screen.dart';

// --- Écrans du module Risk Management ---
import 'package:investia/risk_management/features/risk_analysis/views/risk_analysis_screen.dart';
import 'package:investia/risk_management/features/risk_list/views/risk_list_screen.dart';
import 'package:investia/risk_management/features/risk_form/views/risk_form_screen.dart';
import 'package:investia/risk_management/features/recommendations/views/recommendations_screen.dart';

// --- Providers & Services ---
import 'package:investia/providers/auth_provider.dart';

// GlobalKey pour le Navigator racine (peut toujours être utile pour d'autres usages, mais pas pour obtenir le contexte dans redirect initial)
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

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String marketList = '/market';
  static const String news = '/news';
  static const String orders = '/orders';
  static const String riskManagementList = '/risk-module/list';
  static const String assetDetail = '/asset-detail/:assetId';
  static String assetDetailPath(String assetId) => '/asset-detail/$assetId';
  static const String paymentServices = '/payment-services';
  static const String oneTimePayment = 'one-time'; // Relatif à paymentServices
  static const String subscriptionPayment = 'subscription'; // Relatif à paymentServices
  static const String riskAnalysis = '/risk-module/analysis';
  static const String addRisk = '/risk-module/list/add';
  static const String editRisk = '/risk-module/list/edit/:riskId';
  static String editRiskPath(int riskId) => '/risk-module/list/edit/$riskId';
  static const String recommendations = '/risk-module/recommendations';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  // Le `ref` ici vient de Riverpod, pour la création du GoRouter lui-même.
  // Il n'est pas directement utilisé pour obtenir AuthProvider dans redirect.

  // Obtenir une référence à AuthProvider de manière sûre.
  // Nous ne pouvons pas utiliser `ref.watch` directement ici car goRouterProvider est un Provider,
  // pas un ConsumerWidget ou un autre type de provider Riverpod qui reconstruit.
  // AuthProvider est fourni par package:provider.
  // La solution est d'utiliser le `BuildContext` fourni par la fonction `redirect`.

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login, // IMPORTANT: Commencer par login pour forcer le redirect si nécessaire
    debugLogDiagnostics: true,

    redirect: (BuildContext context, GoRouterState state) async {
      // ---- MODIFICATION IMPORTANTE ICI ----
      // Utiliser le `context` fourni par la fonction `redirect`
      // pour accéder à `AuthProvider` de `package:provider`.
      final authProvider = provider_pkg.Provider.of<AuthProvider>(context, listen: false);

      // Assurer l'initialisation de AuthProvider
      if (!authProvider.isInitialized) {
        try {
          print("Router Redirect: Initializing AuthProvider...");
          await authProvider.initialize();
          print("Router Redirect: AuthProvider initialized. Username: ${authProvider.username}");
        } catch (e) {
          print("Router Redirect: Error initializing AuthProvider: $e");
          // En cas d'erreur, on pourrait vouloir explicitement aller à login
          if (state.matchedLocation != AppRoutes.login) {
            return AppRoutes.login;
          }
        }
      }

      final isAuthenticated = authProvider.username != null;
      final onAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      print("Router Redirect: Path: ${state.matchedLocation}, Authenticated: $isAuthenticated, OnAuthRoute: $onAuthRoute");

      // Si l'utilisateur n'est pas authentifié ET n'est pas sur une page d'authentification
      if (!isAuthenticated && !onAuthRoute) {
        print("Router Redirect: Not authenticated and not on auth route. Redirecting to login.");
        return AppRoutes.login; // Rediriger vers login
      }

      // Si l'utilisateur est authentifié ET est sur une page d'authentification (login/signup)
      if (isAuthenticated && onAuthRoute) {
        print("Router Redirect: Authenticated but on auth route. Redirecting to home.");
        return AppRoutes.home; // Rediriger vers home
      }

      // Si l'utilisateur est authentifié et tente d'accéder à la racine "/",
      // rediriger vers home s'il n'y est pas déjà.
      // Utile si initialLocation était "/" et que l'utilisateur est déjà loggué.
      if (isAuthenticated && state.matchedLocation == '/') {
        print("Router Redirect: Authenticated and on root. Redirecting to home.");
        return AppRoutes.home;
      }


      return null; // Pas de redirection, continuer vers la destination demandée
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
                path: AppRoutes.home, // Sera /home
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
                path: AppRoutes.marketList, // Sera /market
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
                path: AppRoutes.news, // Sera /news
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
                path: AppRoutes.orders, // Sera /orders
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
                path: AppRoutes.riskManagementList, // Sera /risk-module/list
                name: AppRoutes.riskManagementList,
                builder: (BuildContext context, GoRouterState state) =>
                const RiskListScreen(),
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
            path: AppRoutes.oneTimePayment, //  'one-time' -> /payment-services/one-time
            name: AppRoutes.oneTimePayment,
            builder: (context, state) => OneTimePaymentPage(),
          ),
          GoRoute(
            path: AppRoutes.subscriptionPayment, // 'subscription' -> /payment-services/subscription
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
            return _ErrorScreen(message: "ID de risque invalide pour ${state.uri}: '$idString'");
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