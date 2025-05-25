// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
// Assurez-vous que ce chemin est correct

class AuthProvider with ChangeNotifier {
  String? _username;
  bool _isLoading = false;
  bool _isInitialized = false;

  String? get username => _username;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
//
  final storage = const FlutterSecureStorage();
  String? _email;

  String? get email => _email;
  //
  // Setter pour les tests afin de contrôler _isInitialized
  // L'annotation @visibleForTesting indique que ce membre est principalement destiné aux tests.
  @visibleForTesting
  set isInitializedForTesting(bool value) {
    _isInitialized = value;
    // En général, on ne notifie pas les listeners dans un setter de test direct,
    // sauf si le test spécifique a besoin de déclencher une réaction.
    // Si vous modifiez cela dans un test et que vous voulez que GoRouter réagisse,
    // vous devrez appeler notifyListeners() manuellement après avoir défini cette valeur.
    // Ou, pour plus de contrôle, vous pourriez avoir une méthode séparée dans votre
    // mock/test qui définit la valeur ET appelle notifyListeners().
  }

  final AuthService _authService;

  AuthProvider() : _authService = AuthService();

  Future<void> initialize() async {
    // Si déjà initialisé ET que nous avons un nom d'utilisateur, on peut éviter de refaire le travail.
    // Cependant, si _isInitialized est true mais _username est null (ex: après un logout puis redémarrage à chaud sans full restart),
    // on pourrait vouloir retenter. La logique actuelle est simple : si _isInitialized est true, on ne fait rien.
    if (_isInitialized) {
      print("AuthProvider: Already initialized. Username: $_username");
      // Si vous voulez forcer une ré-initialisation dans certains cas, ajustez cette condition.
      // Par exemple, si l'application est relancée après un long moment.
      // Pour l'instant, on garde le comportement simple.
      return;
    }

    print("AuthProvider: Initializing...");
    _isLoading = true;
    // Pas de notifyListeners() ici pour éviter des rebuilds inutiles si l'état est géré par `refreshListenable`

    try {
      _username = await _authService.getCurrentUser();
      print("AuthProvider: Current user from service: $_username");
    } catch (e) {
      print("AuthProvider: Error during initialize fetching user: $e");
      _username = null;
    } finally {
      _isInitialized =
          true; // Marquer comme initialisé après la tentative, succès ou échec
      _isLoading = false;
      print(
          "AuthProvider: Initialization complete. isInitialized: $_isInitialized, username: $_username. Notifying listeners.");
      notifyListeners(); // Notifier APRÈS que l'initialisation est terminée et l'état est mis à jour
    }
  }

  Future<bool> login(String username, String password) async {
    print("AuthProvider: Attempting login for $username...");
    _isLoading = true;
    _isInitialized =
        false; // Lors d'une tentative de login, on est dans un processus d' "initialisation" de session
    notifyListeners();
    try {
      final success = await _authService.login(username, password);
      if (success) {
        _username = username;
        _isInitialized = true; // Login réussi, la session est initialisée
        print(
            "AuthProvider: Login successful for $username. Notifying listeners.");
        notifyListeners(); // Notifier le changement d'état d'authentification
      } else {
        _username = null;
        _isInitialized =
            true; // Même en cas d'échec de login (ex: mauvais mdp), l'état d'init est résolu
        print(
            "AuthProvider: Login failed for $username (credentials?). Notifying listeners.");
        notifyListeners();
      }
      return success;
    } catch (e) {
      _username = null;
      _isInitialized =
          true; // L'opération de login est terminée (même avec erreur réseau)
      print(
          "AuthProvider: Error during login for $username: $e. Notifying listeners.");
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      // notifyListeners(); // Déjà notifié dans les blocs try/catch
    }
  }

  Future<bool> register(String username, String email, String password) async {
    print("AuthProvider: Attempting registration for $username...");
    _isLoading = true;
    _isInitialized = false;
    notifyListeners();
    try {
      final success = await _authService.register(username, email, password);
      if (success) {
        _username = username;
        _isInitialized = true;
        print(
            "AuthProvider: Registration successful for $username. Notifying listeners.");
        notifyListeners();
      } else {
        _username = null;
        _isInitialized = true;
        print(
            "AuthProvider: Registration failed for $username. Notifying listeners.");
        notifyListeners();
      }
      return success;
    } catch (e) {
      _username = null;
      _isInitialized = true;
      print(
          "AuthProvider: Error during registration for $username: $e. Notifying listeners.");
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      // notifyListeners();
    }
  }

  Future<void> logout() async {
    print("AuthProvider: Logging out...");
    await _authService.logout();
    _username = null;
    // _isInitialized = false; // On pourrait vouloir le remettre à false pour forcer une réinitialisation complète
    // si l'utilisateur se reloggue. Ou le garder à true car l'app a été initialisée une fois.
    // Pour la redirection, il est souvent plus simple de le considérer comme "non initialisé" pour la nouvelle session potentielle.
    // Cependant, si `refreshListenable` réagit à `_username == null`, alors `_isInitialized` peut rester `true`.
    // Testons en gardant `_isInitialized` à true pour voir si le redirect fonctionne bien.
    // Si non, on pourra le mettre à false ici.
    print("AuthProvider: Logout complete. Notifying listeners.");
    notifyListeners();
  }
}
