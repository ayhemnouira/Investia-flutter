import 'package:flutter/material.dart';
import '../models/wallet.dart';
import '../models/wallet_transaction.dart';
import '../services/api_service.dart';

class WalletProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  Wallet? _wallet;

  Wallet? get wallet => _wallet;

  Future<void> fetchUserWallet() async {
    try {
      _wallet = await _apiService.getUserWallet();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> transfer(int walletId, WalletTransaction transaction) async {
    try {
      _wallet = await _apiService.walletToWalletTransfer(walletId, transaction);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
