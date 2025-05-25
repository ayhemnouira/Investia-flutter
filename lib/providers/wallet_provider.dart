import 'package:flutter/material.dart';

class WalletProvider with ChangeNotifier {
  Map<String, dynamic> _wallet = {'id': '123456', 'balance': 1000.00};
  String? _message;

  Map<String, dynamic> get wallet => _wallet;
  String? get message => _message;

  void transfer(String recipientId, double amount, String purpose) {
    if (recipientId.isEmpty || amount <= 0) {
      _message = 'Invalid input';
      notifyListeners();
      return;
    }
    if (amount > _wallet['balance']) {
      _message = 'Insufficient balance';
      notifyListeners();
      return;
    }
    _wallet = {..._wallet, 'balance': _wallet['balance'] - amount};
    _message = 'Transfer successful';
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }
}
