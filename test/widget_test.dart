// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investia/screens/auth/login_screen.dart';
import 'package:investia/screens/home_screen.dart';
import 'package:provider/provider.dart' as provider_pkg;

import 'package:investia/main.dart';
import 'package:investia/providers/auth_provider.dart';
import 'package:investia/risk_management/navigation/app_router.dart';
import 'package:go_router/go_router.dart';

// Mock pour AuthProvider
class MockAuthProvider extends AuthProvider {
  String? _mockUsername;
  bool _mockIsInitialized = false;
  bool _mockIsAuthenticated; // Pour stocker l'état d'authentification simulé

  @override
  String? get username => _mockUsername;

  @override
  bool get isInitialized => _mockIsInitialized;

  // Un getter pour savoir si l'utilisateur est authentifié dans le mock
  bool get isAuthenticated => _mockUsername != null;

  MockAuthProvider({bool initiallyAuthenticated = false, String? initialUsername})
      : _mockIsAuthenticated = initiallyAuthenticated { // Initialiser _mockIsAuthenticated
    if (initiallyAuthenticated && initialUsername != null) {
      _mockUsername = initialUsername;
    }
    // Initialiser l'état d'initialisation tout de suite pour les tests
    _mockIsInitialized = true;
  }

  @override
  Future<void> initialize() async {
    // Dans le mock, on peut considérer l'initialisation comme instantanée
    // L'état est déjà défini dans le constructeur.
    _mockIsInitialized = true;
    // Inutile d'appeler super.isInitializedForTesting car on surcharge les getters
    print("MockAuthProvider: Initialized. Username: $_mockUsername, IsInitialized: $_mockIsInitialized");
    notifyListeners(); // Notifier si des tests dépendent de cet appel
  }

  @override
  Future<bool> login(String username, String password) async {
    // Simuler un login réussi
    _mockUsername = username;
    _mockIsInitialized = true;
    _mockIsAuthenticated = true;
    print("MockAuthProvider: Logged in as $username. Notifying listeners.");
    notifyListeners();
    return true;
  }

  @override
  Future<void> logout() async {
    _mockUsername = null;
    _mockIsAuthenticated = false;
    // _mockIsInitialized reste true car l'application a été initialisée
    print("MockAuthProvider: Logged out. Notifying listeners.");
    notifyListeners();
  }

  // Méthode pour simuler un état spécifique dans les tests
  void simulateAuthenticationState({
    required bool isAuthenticated,
    String? username,
    required bool isInitialized,
  }) {
    _mockIsAuthenticated = isAuthenticated;
    _mockUsername = isAuthenticated ? (username ?? "testuser") : null;
    _mockIsInitialized = isInitialized;
    print(
        "MockAuthProvider: Simulated state - isAuthenticated: $_mockIsAuthenticated, username: $_mockUsername, isInitialized: $_mockIsInitialized. Notifying listeners.");
    notifyListeners();
  }
}


void main() {
  // Test helper pour envelopper les widgets avec les providers nécessaires
  Future<void> pumpApp(
      WidgetTester tester, {
        required AuthProvider authProvider,
        Widget? child,
      }) async {
    final GoRouter testRouter = createGoRouter(authProvider);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goRouterProvider.overrideWithValue(testRouter),
        ],
        child: provider_pkg.MultiProvider(
          providers: [
            provider_pkg.ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            // Ajoutez d'autres mocks de providers si nécessaire pour le widget testé
          ],
          child: child ?? MyApp(authProviderInstance: authProvider),
        ),
      ),
    );
    // Attendre que toutes les redirections et frames soient traitées
    await tester.pumpAndSettle();
  }

  testWidgets('App starts with LoginScreen if not authenticated and initialized', (WidgetTester tester) async {
    final mockAuthProvider = MockAuthProvider(initiallyAuthenticated: false);
    // L'initialisation est gérée dans le constructeur du mock ou on peut l'appeler explicitement si besoin
    // await mockAuthProvider.initialize(); // Déjà fait dans le constructeur ou on peut le forcer ici

    await pumpApp(tester, authProvider: mockAuthProvider);

    expect(find.byType(LoginScreen), findsOneWidget, reason: "Should display LoginScreen when not authenticated.");
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('App navigates to HomeScreen if authenticated and initialized', (WidgetTester tester) async {
    final mockAuthProvider = MockAuthProvider(initiallyAuthenticated: true, initialUsername: "testuser");
    // await mockAuthProvider.initialize(); // Déjà fait

    await pumpApp(tester, authProvider: mockAuthProvider);

    // GoRouter a besoin de temps pour traiter la redirection après le premier build
    await tester.pumpAndSettle();


    expect(find.byType(HomeScreen), findsOneWidget, reason: "Should display HomeScreen when authenticated.");
    expect(find.byType(LoginScreen), findsNothing);
  });


  // L'ancien test "Counter increments smoke test" n'est plus pertinent.
  // Vous devriez le supprimer ou l'adapter pour tester une fonctionnalité réelle de votre application.
  /*
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final mockAuthProvider = MockAuthProvider();
    await mockAuthProvider.initialize(); // Assurez-vous qu'il est initialisé

    final GoRouter testRouter = createGoRouter(mockAuthProvider);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goRouterProvider.overrideWithValue(testRouter),
        ],
        child: provider_pkg.MultiProvider(
          providers: [
            provider_pkg.ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ],
          child: MyApp(authProviderInstance: mockAuthProvider),
        ),
      ),
    );
    await tester.pumpAndSettle(); // Attendre les redirections

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  */
}

// L'extension n'est plus strictement nécessaire si vous utilisez un MockAuthProvider bien conçu.
// extension AuthProviderTestExtension on AuthProvider {
//   void setInitializedForTest(bool value) {
//      (this as dynamic)._isInitialized = value; // Mauvaise pratique, utiliser un mock
//   }
//   void simulateLogin(String username) {
//      (this as dynamic)._username = username;
//      (this as dynamic)._isInitialized = true;
//      (this as dynamic).notifyListeners();
//   }
// }