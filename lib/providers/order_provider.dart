import 'package:flutter/material.dart'; // Nécessaire pour ChangeNotifier
import 'package:flutter/foundation.dart'; // Utile pour debugPrint (ou 'dart:developer')

// Assure-toi que ces chemins d'imports sont corrects dans ton projet !
// Ces fichiers doivent exister dans ton projet après les avoir copiés depuis Amira's.
import '../models/order_model.dart'; // <-- ASSURE-TOI QUE CE CHEMIN ET NOM DE FICHIER SONT CORRECTS
// Ce fichier doit contenir les définitions des classes/enums comme Order, RebalanceRecommendation, OrderType.

import '../services/order_service.dart'; // <-- ASSURE-TOI QUE CE CHEMIN ET NOM DE FICHIER SONT CORRECTS
// Ce fichier DOIT contenir la définition de OrderService, avec les méthodes comme getUserOrders, getRebalanceRecommendations, placeOrder.


class OrderProvider with ChangeNotifier {
  // ====== ÉTAT DU PROVIDER ======
  List<Order> _orders = []; // Liste des commandes de l'utilisateur
  List<RebalanceRecommendation> _rebalanceRecommendations = []; // Recommandations IA
  bool _isLoading = false; // Indique si un chargement est en cours
  String? _errorMessage; // <-- NOUVEAU : Stocke un message d'erreur

  // ====== GETTERS POUR ACCÉDER À L'ÉTAT ======
  List<Order> get orders => _orders;
  List<RebalanceRecommendation> get rebalanceRecommendations => _rebalanceRecommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage; // <-- NOUVEAU : Getter pour le message d'erreur

  // Instance du service pour interagir avec le backend/API
  final OrderService _orderService; // <-- Initialisé dans le constructeur

  // ====== CONSTRUCTEUR ======
  // Le service est généralement injecté ou créé ici.
  // On peut le passer en paramètre si on utilise un Provider pour AuthService aussi.
  OrderProvider() : _orderService = OrderService(); // Crée une instance de OrderService


  // ====== MÉTHODES POUR MODIFIER L'ÉTAT ET INTERAGIR AVEC LE SERVICE ======

  // Récupère les commandes de l'utilisateur
  Future<void> fetchOrders() async {
    // Ne fait rien si un chargement est déjà en cours
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null; // Réinitialise l'erreur au début du chargement
    notifyListeners(); // Notifie le début du chargement

    try {
      _orders = await _orderService.getUserOrders();
      _errorMessage = null; // Assure que l'erreur est nulle en cas de succès
      debugPrint('Successfully fetched orders (${_orders.length} items)');
    } catch (e) {
      _errorMessage = 'Failed to fetch orders: ${e.toString()}'; // <-- NOUVEAU : Stocke l'erreur
      _orders = []; // Optionnel: Vide la liste en cas d'erreur (ou garde les anciennes données)
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false; // Le chargement est terminé
      notifyListeners(); // Notifie la fin du chargement (succès ou échec)
    }
  }

  // Récupère les recommandations de rééquilibrage IA
  Future<void> fetchRebalanceRecommendations() async {
    // Ne fait rien si un chargement est déjà en cours
     if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null; // Réinitialise l'erreur
    notifyListeners(); // Notifie le début du chargement

    try {
      _rebalanceRecommendations = await _orderService.getRebalanceRecommendations();
      _errorMessage = null; // Assure que l'erreur est nulle en cas de succès
      debugPrint('Successfully fetched rebalance recommendations (${_rebalanceRecommendations.length} items)');
    } catch (e) {
      _errorMessage = 'Failed to fetch rebalance recommendations: ${e.toString()}'; // <-- NOUVEAU : Stocke l'erreur
      _rebalanceRecommendations = []; // Optionnel: Vide la liste en cas d'erreur
      debugPrint('Error fetching rebalance recommendations: $e');
    } finally {
      _isLoading = false; // Le chargement est terminé
      notifyListeners(); // Notifie la fin du chargement
    }
  }

  // Place un seul ordre (achat ou vente)
  Future<bool> placeOrder(Order order) async {
     // On peut ajouter un état de chargement spécifique ou utiliser _isLoading si on ne fait qu'une opération à la fois.
     // Pour l'exemple, on va utiliser _isLoading.
     if (_isLoading) return false;

     _isLoading = true;
     _errorMessage = null;
     notifyListeners(); // Notifie le début

    try {
      final newOrder = await _orderService.placeOrder(order);
      _orders.insert(0, newOrder); // Ajoute le nouvel ordre en haut de la liste
      _errorMessage = null;
      debugPrint('Successfully placed order: ${newOrder.id}');
      notifyListeners(); // Notifie en cas de succès
      return true; // Indique le succès
    } catch (e) {
      _errorMessage = 'Failed to place order: ${e.toString()}'; // <-- NOUVEAU : Stocke l'erreur
      debugPrint('Error placing order: $e');
      notifyListeners(); // Notifie en cas d'échec
      return false; // Indique l'échec
    } finally {
       _isLoading = false; // Le chargement est terminé
       // notifyListeners(); // Déjà appelé en cas de succès ou d'échec, peut être redondant ici
    }
  }

  // Exécute une liste d'ordres (pour le rééquilibrage)
  Future<bool> executeRebalance(List<Order> rebalanceOrders) async {
     // On peut ajouter un état de chargement spécifique ou utiliser _isLoading.
     // Pour l'exemple, on va utiliser _isLoading.
     if (_isLoading) return false; // Ne fait rien si déjà en chargement

     _isLoading = true;
     _errorMessage = null;
     notifyListeners(); // Notifie le début

    try {
      // Exécute tous les ordres en parallèle
      final results = await Future.wait(
        rebalanceOrders.map((order) => _orderService.placeOrder(order))
      );
      // Ajoute les ordres exécutés à la liste des commandes (si OrderService retourne les ordres complets)
      _orders.insertAll(0, results);
      _errorMessage = null;
       debugPrint('Successfully executed rebalance orders (${results.length} items)');
      notifyListeners(); // Notifie en cas de succès
      return true; // Indique le succès
    } catch (e) {
      _errorMessage = 'Failed to execute rebalance: ${e.toString()}'; // <-- NOUVEAU : Stocke l'erreur
      debugPrint('Error executing rebalance: $e');
      notifyListeners(); // Notifie en cas d'échec
      return false; // Indique l'échec
    } finally {
      _isLoading = false; // Le chargement est terminé
      // notifyListeners(); // Déjà appelé en cas de succès ou d'échec
    }
  }

  // Optionnel: Méthode dispose si des ressources doivent être nettoyées (pas courant pour un simple provider)
  // @override
  // void dispose() {
  //   // Nettoyer les ressources si nécessaire
  //   super.dispose();
  // }
}

// ====== ASSURE-TOI QUE TES MODÈLES ET ENUMS SONT DÉFINIS ET IMPORTÉS CORRECTEMENT ======
// Les classes Order, RebalanceRecommendation, OrderType doivent être définies et importées via order_model.dart ou d'autres fichiers modèles.
// Ex: Dans lib/models/orders/order_model.dart

/*
// Dans le fichier lib/models/orders/order_model.dart (ou similaire)

// Modèle pour une recommandation de rééquilibrage
class RebalanceRecommendation {
  final String? assetId;
  final String? assetName;
  final double? currentPercentage;
  final double? targetPercentage;
  final double? amountToAdjust; // Montant positif pour BUY, négatif pour SELL

  RebalanceRecommendation({
    this.assetId,
    this.assetName,
    this.currentPercentage,
    this.targetPercentage,
    this.amountToAdjust,
  });

  // Tu auras besoin d'une méthode fromJson dans OrderProvider ou OrderService pour mapper les données de l'API
  // Ou le OrderService retourne déjà des objets RebalanceRecommendation.
}

// Modèle pour un ordre
class Order {
  final String id; // L'ID de l'ordre (probablement généré par backend)
  final String assetId;
  final String assetName;
  final double amount;
  final double price;
  final DateTime date;
  final OrderType type;

  Order({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.amount,
    required this.price,
    required this.date,
    required this.type,
  });

  // Tu auras probablement besoin d'une méthode fromJson (si service retourne Order)
  // et d'une méthode toJson (si service envoie Order au backend)
}

// Enum pour le type d'ordre
enum OrderType { buy, sell }
*/