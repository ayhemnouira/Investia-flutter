// watchlist_provider.dart
import 'package:flutter/material.dart';

class WatchlistProvider with ChangeNotifier {
  List<Map<String, dynamic>> _watchlist = [
    {
      'id': 'bitcoin',
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'currentPrice': 65000.00,
      'imageUrl': 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
    },
    {
      'id': 'ethereum',
      'name': 'Ethereum',
      'symbol': 'ETH',
      'currentPrice': 3500.00,
      'imageUrl': 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
    },
  ];
  bool _isLoading = false;
  String? _error;
  String? _message;

  List<Map<String, dynamic>> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get message => _message;

  void addCoin(String coinId) {
    if (coinId.isEmpty) {
      _error = 'Coin ID cannot be empty';
      _message = 'Please enter a valid Coin ID';
      notifyListeners();
      return;
    }
    if (_watchlist.any((coin) => coin['id'] == coinId)) {
      _error = 'Coin already in watchlist';
      _message = 'Coin already in watchlist';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    _message = null;
    notifyListeners();

    final mockCoins = {
      'bitcoin': {
        'id': 'bitcoin',
        'name': 'Bitcoin',
        'symbol': 'BTC',
        'currentPrice': 65000.00,
        'imageUrl': 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
      },
      'ethereum': {
        'id': 'ethereum',
        'name': 'Ethereum',
        'symbol': 'ETH',
        'currentPrice': 3500.00,
        'imageUrl': 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
      },
      'litecoin': {
        'id': 'litecoin',
        'name': 'Litecoin',
        'symbol': 'LTC',
        'currentPrice': 150.00,
        'imageUrl': 'https://cryptologos.cc/logos/litecoin-ltc-logo.png',
      },
    };

    Future.delayed(const Duration(seconds: 1), () {
      if (mockCoins.containsKey(coinId)) {
        _watchlist = [..._watchlist, mockCoins[coinId]!];
        _message = 'Coin added to watchlist';
      } else {
        _error = 'Coin not found';
        _message = 'Coin not found';
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  void removeCoin(String coinId) {
    _watchlist = _watchlist.where((coin) => coin['id'] != coinId).toList();
    _message = 'Coin removed from watchlist';
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    _error = null;
    notifyListeners();
  }
}
