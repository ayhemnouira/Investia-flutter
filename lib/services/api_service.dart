import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:investia/models/asset.dart';
import 'package:investia/models/coin.dart';
import 'package:investia/models/wallet.dart';
import 'package:investia/models/wallet_transaction.dart';
import 'package:investia/models/watchlist.dart';
import 'package:investia/models/withdrawal.dart';
import '../models/market_data.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator; replace with host machine IP for physical devices
  static const String baseUrl = 'http://10.0.2.2:8089/investiaMVC/api';
  static const String coingeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  final storage = const FlutterSecureStorage();

  Future<String?> getEmail() async {
    return await storage.read(key: 'email');
  }

  Future<Asset> getAssetById(int assetId) async {
    final email = await getEmail();
    final response = await http.get(
      Uri.parse('$baseUrl/asset/$assetId'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 200) {
      return Asset.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load asset');
  }

  Future<Asset> getAssetByUserIdAndCoinId(String coinId) async {
    final email = await getEmail();
    final response = await http.get(
      Uri.parse('$baseUrl/asset/coin/$coinId/user'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 200) {
      return Asset.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load asset');
  }

  Future<List<Asset>> getUsersAssets() async {
    final email = await getEmail();
    final response = await http.get(
      Uri.parse('$baseUrl/asset'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Asset>.from(l.map((model) => Asset.fromJson(model)));
    }
    throw Exception('Failed to load assets');
  }

  Future<Wallet> getUserWallet() async {
    final email = await getEmail();
    final response = await http.get(
      Uri.parse('$baseUrl/wallet'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 202) {
      return Wallet.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load wallet');
  }

  Future<Wallet> walletToWalletTransfer(
      int walletId, WalletTransaction transaction) async {
    final email = await getEmail();
    final response = await http.put(
      Uri.parse('$baseUrl/wallet/$walletId/transfer'),
      headers: {
        'Authorization': email ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transaction.toJson()),
    );
    if (response.statusCode == 202) {
      return Wallet.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to transfer');
  }

  Future<Watchlist> getUserWatchList() async {
    final email = await getEmail();
    final response = await http.get(
      Uri.parse('$baseUrl/watchlist/user'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 200) {
      return Watchlist.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load watchlist');
  }

  Future<void> addItemToWatchList(String coinId) async {
    final email = await getEmail();
    final response = await http.patch(
      Uri.parse('$baseUrl/watchlist/add/coin/$coinId'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add coin to watchlist');
    }
  }

  Future<Withdrawal> requestWithdrawal(double amount) async {
    final email = await getEmail();
    final response = await http.post(
      Uri.parse('$baseUrl/withdrawal/$amount'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 202) {
      return Withdrawal.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to request withdrawal');
  }

  Future<List<Withdrawal>> getUserWithdrawalHistory() async {
    final email = await getEmail();
    final response = await http.get(
      Uri.parse('$baseUrl/withdrawal'), // Fixed typo: was /wallet
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Withdrawal>.from(
          l.map((model) => Withdrawal.fromJson(model)));
    }
    throw Exception('Failed to load withdrawal history');
  }

  Future<Wallet> addBalanceToWallet(int orderId, String paymentId) async {
    final email = await getEmail();
    final response = await http.put(
      Uri.parse(
          '$baseUrl/wallet/deposit?order_id=$orderId&payment_id=$paymentId'),
      headers: {'Authorization': email ?? ''},
    );
    if (response.statusCode == 202) {
      return Wallet.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add balance');
  }

  Future<Coin> getCoinPrice(String coinId) async {
    final response = await http.get(
      Uri.parse('$coingeckoBaseUrl/coins/$coinId'),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Coin(
        id: coinId,
        name: json['name'] ?? '',
        symbol: json['symbol'] ?? '',
        currentPrice:
            (json['market_data']['current_price']['usd'] ?? 0).toDouble(),
      );
    }
    throw Exception('Failed to load coin price');
  }

  static Future<List<MarketData>> fetchMarketData() async {
    final response =
        await http.get(Uri.parse('https://api.example.com/marketdata'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => MarketData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load market data');
    }
  }
}
