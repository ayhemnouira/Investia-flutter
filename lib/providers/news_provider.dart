import 'package:flutter/foundation.dart';
import 'package:investia/models/news_article.dart';
import 'package:investia/services/data_service.dart';

class NewsProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<NewsArticle> _allArticles = []; // Stocke toutes les actualités non filtrées
  String _searchText = ''; // Le texte de recherche actuel

  bool _isLoading = false;
  String? _errorMessage;

  // Getter pour la liste filtrée des actualités
  List<NewsArticle> get articles {
    if (_searchText.isEmpty) {
      return _allArticles; // Si pas de recherche, renvoie tout
    } else {
      // Filtrer la liste basée sur le titre ou le résumé (insensible à la casse)
      return _allArticles.where((article) =>
        article.title.toLowerCase().contains(_searchText.toLowerCase()) ||
        article.summary.toLowerCase().contains(_searchText.toLowerCase())
      ).toList();
    }
  }

  String get searchText => _searchText; // Getter pour le texte de recherche
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Méthode pour charger les actualités (utilise la méthode avec cache)
  Future<void> fetchNews() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners(); // Commenté si tu veux une approche "cache d'abord" rapide

    try {
      // Appelle la méthode du service qui gère le cache et l'API
      final fetchedArticles = await _dataService.fetchNewsArticlesWithCache(); // Utilise la nouvelle méthode
      _allArticles = fetchedArticles; // Met à jour la liste complète
      // Pas besoin de mettre à jour _articles car le getter la calcule dynamiquement
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load news articles: ${e.toString()}";
       // Si le service retourne le cache en cas d'échec API, _allArticles ne sera pas vide.
       // Si le service lève une exception et vide _allArticles, la liste sera vide.
       // Adapte la gestion de _allArticles = [] ici en fonction de la logique de ton service.
    } finally {
      _isLoading = false;
       // Notifie pour reconstruire l'UI avec les données (fraîches ou cache) ou l'erreur
      notifyListeners();
    }
  }

  // Méthode pour mettre à jour le texte de recherche
  void setSearchText(String text) {
    _searchText = text;
    notifyListeners(); // Notifie pour recalculer la liste filtrée et mettre à jour l'UI
  }
}