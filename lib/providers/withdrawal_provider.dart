import 'package:flutter/material.dart';
import '../models/withdrawal.dart';
import '../services/api_service.dart';

class WithdrawalProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Withdrawal> _withdrawals = [];

  List<Withdrawal> get withdrawals => _withdrawals;

  Future<void> fetchUserWithdrawalHistory() async {
    try {
      _withdrawals = await _apiService.getUserWithdrawalHistory();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestWithdrawal(double amount) async {
    try {
      await _apiService.requestWithdrawal(amount);
      await fetchUserWithdrawalHistory();
    } catch (e) {
      print(e);
    }
  }
}
