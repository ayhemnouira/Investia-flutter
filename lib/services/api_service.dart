import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_data.dart';

class ApiService {
  static Future<List<MarketData>> fetchMarketData() async {
    final response = await http.get(Uri.parse('https://api.example.com/marketdata'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => MarketData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load market data');
    }
  }
}
