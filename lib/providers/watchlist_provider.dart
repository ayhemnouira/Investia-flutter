import 'package:flutter/material.dart';
import '../models/watchlist.dart';
import '../services/api_service.dart';

class WatchlistProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Watchlist? _watchlist;

  Watchlist? get watchlist => _watchlist;

  Future<void> fetchUserWatchlist() async {
    try {
      _watchlist = await _apiService.getUserWatchList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCoin(String coinId) async {
    try {
      await _apiService.addItemToWatchList(coinId);
      await fetchUserWatchlist();
    } catch (e) {
      print(e);
    }
  }
}
