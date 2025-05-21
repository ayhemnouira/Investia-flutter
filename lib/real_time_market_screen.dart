import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class RealTimeMarketScreen extends StatefulWidget {
  const RealTimeMarketScreen({super.key});

  @override
  _RealTimeMarketScreenState createState() => _RealTimeMarketScreenState();
}

class _RealTimeMarketScreenState extends State<RealTimeMarketScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> marketData = [];
  List<Map<String, dynamic>> previousMarketData = [];
  Timer? _timer;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchMarketData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchMarketData();
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> fetchMarketData() async {
    setState(() {
      isLoading = true;
    });

    final symbols = ['BTCUSDT', 'ETHUSDT', 'BNBUSDT'];
    List<Map<String, dynamic>> updatedData = [];

    for (String symbol in symbols) {
      final response = await http.get(
        Uri.parse('https://api.binance.com/api/v3/ticker/price?symbol=$symbol'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        updatedData.add({
          'symbol': data['symbol'],
          'price': double.parse(data['price']),
        });
      } else {
        updatedData.add({
          'symbol': symbol,
          'price': null,
        });
      }
    }

    // Vérifier si un prix a changé
    bool priceChanged = false;
    if (previousMarketData.isNotEmpty) {
      for (int i = 0; i < updatedData.length; i++) {
        if (updatedData[i]['price'] != previousMarketData[i]['price']) {
          priceChanged = true;
          break;
        }
      }
    }

    setState(() {
      previousMarketData = List.from(marketData); // sauvegarde ancienne version
      marketData = updatedData;
      isLoading = false;
    });

    if (priceChanged) {
      // Jouer un petit son discret
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    }

    _animationController.forward(from: 0);
  }

  Color getPriceColor(double? oldPrice, double? newPrice) {
    if (oldPrice == null || newPrice == null) return Colors.black;
    if (newPrice > oldPrice) {
      return Colors.green;
    } else if (newPrice < oldPrice) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marché en Temps Réel'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: ListView.builder(
                  itemCount: marketData.length,
                  itemBuilder: (context, index) {
                    final item = marketData[index];
                    final oldItem = previousMarketData.isNotEmpty ? previousMarketData[index] : null;
                    final color = oldItem != null ? getPriceColor(oldItem['price'], item['price']) : Colors.black;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.trending_up),
                        title: Text(item['symbol'] ?? 'Inconnu'),
                        subtitle: Text(
                          item['price'] != null
                              ? 'Prix : ${item['price']} USD'
                              : 'Erreur de chargement',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
