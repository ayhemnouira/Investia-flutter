import 'dart:convert'; // Pour décoder les réponses JSON (jsonDecode)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http; // Importe le package http et lui donne un alias 'http'

// Classe responsable des appels à l'API Twelve Data
class ApiService {
  // Clé API Twelve Data (IMPORTANT: Ne jamais mettre de clés sensibles directement dans le code source pour un vrai projet !)
  // Préférez les variables d'environnement ou une configuration sécurisée.
  final String _apiKey = '35a225d6ccfd4c6bbb1a4b409e863406'; // Votre clé API
  final String _baseUrl = 'https://api.twelvedata.com';

  // --- Méthode pour récupérer les données de prix (Time Series) ---
  // Retourne un Future<Map<String, dynamic>>, car l'opération est asynchrone
  // et la réponse attendue est un objet JSON (Map en Dart).
  Future<Map<String, dynamic>> getPriceData(String symbol) async {
    // Construit l'URL de l'API
    final url = Uri.parse('$_baseUrl/time_series?symbol=$symbol&interval=1day&apikey=$_apiKey');
    print('ApiService: Appel GET vers $url'); // Pour le débogage

    try {
      // Effectue la requête GET de manière asynchrone
      final response = await http.get(url);

      // Vérifie si la requête a réussi (code 200 OK)
      if (response.statusCode == 200) {
        // Décode le corps de la réponse JSON en une Map Dart
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // Vérification simple si la réponse contient bien les 'values' attendues
        if (data.containsKey('values')) {
          print('ApiService: Données de prix reçues pour $symbol');
          return data;
        } else {
          print('ApiService: Réponse reçue mais clé "values" manquante pour $symbol. Réponse: ${response.body}');
          throw Exception('Réponse API invalide pour les données de prix (clé "values" manquante).');
        }
      } else {
        // Si le statut n'est pas 200, lance une exception avec le code d'erreur
        print('ApiService: Erreur API (Prix) - Statut ${response.statusCode}, Réponse: ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération des prix: ${response.body}');
      }
    } catch (e) {
      // Capture toute autre erreur (réseau, décodage JSON, etc.)
      print('ApiService: Exception lors de la récupération des prix pour $symbol: $e');
      // Relance l'exception pour que l'appelant puisse la gérer
      throw Exception('Impossible de récupérer les données de prix pour $symbol: $e');
    }
  }

  // --- Méthode pour récupérer la volatilité (ATR) ---
  Future<Map<String, dynamic>> getVolatilityData(String symbol) async {
    final url = Uri.parse('$_baseUrl/atr?symbol=$symbol&interval=1day&apikey=$_apiKey&period=14');
    print('ApiService: Appel GET vers $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey('values')) {
          print('ApiService: Données ATR reçues pour $symbol');
          return data;
        } else {
          print('ApiService: Réponse reçue mais clé "values" manquante pour ATR $symbol. Réponse: ${response.body}');
          throw Exception('Réponse API invalide pour les données ATR (clé "values" manquante).');
        }
      } else {
        print('ApiService: Erreur API (ATR) - Statut ${response.statusCode}, Réponse: ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération de l\'ATR: ${response.body}');
      }
    } catch (e) {
      print('ApiService: Exception lors de la récupération de l\'ATR pour $symbol: $e');
      throw Exception('Impossible de récupérer les données ATR pour $symbol: $e');
    }
  }

  // --- Méthode pour récupérer le RSI ---
  Future<Map<String, dynamic>> getRsiData(String symbol) async {
    final url = Uri.parse('$_baseUrl/rsi?symbol=$symbol&interval=1day&apikey=$_apiKey&period=14');
    print('ApiService: Appel GET vers $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey('values')) {
          print('ApiService: Données RSI reçues pour $symbol');
          return data;
        } else {
          print('ApiService: Réponse reçue mais clé "values" manquante pour RSI $symbol. Réponse: ${response.body}');
          throw Exception('Réponse API invalide pour les données RSI (clé "values" manquante).');
        }
      } else {
        print('ApiService: Erreur API (RSI) - Statut ${response.statusCode}, Réponse: ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération du RSI: ${response.body}');
      }
    } catch (e) {
      print('ApiService: Exception lors de la récupération du RSI pour $symbol: $e');
      throw Exception('Impossible de récupérer les données RSI pour $symbol: $e');
    }
  }


  // --- Méthode pour récupérer la SMA ---
  Future<Map<String, dynamic>> getSmaData(String symbol) async {
    final url = Uri.parse('$_baseUrl/sma?symbol=$symbol&interval=1day&apikey=$_apiKey&period=20');
    print('ApiService: Appel GET vers $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey('values')) {
          print('ApiService: Données SMA reçues pour $symbol');
          return data;
        } else {
          print('ApiService: Réponse reçue mais clé "values" manquante pour SMA $symbol. Réponse: ${response.body}');
          throw Exception('Réponse API invalide pour les données SMA (clé "values" manquante).');
        }
      } else {
        print('ApiService: Erreur API (SMA) - Statut ${response.statusCode}, Réponse: ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération de la SMA: ${response.body}');
      }
    } catch (e) {
      print('ApiService: Exception lors de la récupération de la SMA pour $symbol: $e');
      throw Exception('Impossible de récupérer les données SMA pour $symbol: $e');
    }
  }

  // --- Méthode pour récupérer l'EMA ---
  Future<Map<String, dynamic>> getEmaData(String symbol) async {
    final url = Uri.parse('$_baseUrl/ema?symbol=$symbol&interval=1day&apikey=$_apiKey&period=20');
    print('ApiService: Appel GET vers $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey('values')) {
          print('ApiService: Données EMA reçues pour $symbol');
          return data;
        } else {
          print('ApiService: Réponse reçue mais clé "values" manquante pour EMA $symbol. Réponse: ${response.body}');
          throw Exception('Réponse API invalide pour les données EMA (clé "values" manquante).');
        }
      } else {
        print('ApiService: Erreur API (EMA) - Statut ${response.statusCode}, Réponse: ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération de l\'EMA: ${response.body}');
      }
    } catch (e) {
      print('ApiService: Exception lors de la récupération de l\'EMA pour $symbol: $e');
      throw Exception('Impossible de récupérer les données EMA pour $symbol: $e');
    }
  }

  // --- Méthode pour récupérer le MACD ---
  Future<Map<String, dynamic>> getMacdData(String symbol) async {
    final url = Uri.parse('$_baseUrl/macd?symbol=$symbol&interval=1day&apikey=$_apiKey&series_type=close');
    print('ApiService: Appel GET vers $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // Pour MACD, la structure peut être différente, vérifions les clés attendues
        if (data.containsKey('values') && data['values'] is List && (data['values'] as List).isNotEmpty) {
          // On pourrait vérifier plus en détail si les objets dans 'values' ont bien 'macd', 'macd_signal', 'macd_hist'
          print('ApiService: Données MACD reçues pour $symbol');
          return data;
        } else {
          print('ApiService: Réponse reçue mais structure invalide pour MACD $symbol. Réponse: ${response.body}');
          throw Exception('Réponse API invalide pour les données MACD.');
        }
      } else {
        print('ApiService: Erreur API (MACD) - Statut ${response.statusCode}, Réponse: ${response.body}');
        throw Exception('Erreur API (${response.statusCode}) lors de la récupération du MACD: ${response.body}');
      }
    } catch (e) {
      print('ApiService: Exception lors de la récupération du MACD pour $symbol: $e');
      throw Exception('Impossible de récupérer les données MACD pour $symbol: $e');
    }
  }

} // Fin de la classe ApiService

// --- Configuration Riverpod ---
// Crée un Provider global pour notre ApiService.
// Cela nous permettra d'accéder facilement à une instance unique (singleton)
// de ApiService depuis n'importe où dans l'application via Riverpod.
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});