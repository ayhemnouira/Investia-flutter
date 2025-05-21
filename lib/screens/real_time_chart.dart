import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart'; // Ajout pour le son

class RealTimeMarketScreen extends StatefulWidget {
  @override
  _RealTimeMarketScreenState createState() => _RealTimeMarketScreenState();
}

class _RealTimeMarketScreenState extends State<RealTimeMarketScreen> {
  List<Map<String, dynamic>> marketData = [];
  Timer? _timer;
  final player = AudioPlayer(); // Initialiser le lecteur audio

  @override
  void initState() {
    super.initState();
    fetchMarketData();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchMarketData();
    });
  }

  Future<void> fetchMarketData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.binance.com/api/v3/ticker/price?symbols=[%22BTCUSDT%22,%22ETHUSDT%22,%22BNBUSDT%22]'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          marketData = data.map((item) {
            return {
              'symbol': item['symbol'],
              'price': double.parse(item['price']),
            };
          }).toList();
        });

        // 🎶 Jouer un son après mise à jour des données
        await player.play(AssetSource('sounds/notification.mp3'));
      } else {
        print('Erreur lors du chargement des données : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose(); // Libérer le lecteur audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marché en Temps Réel'),
      ),
      body: ListView.builder(
        itemCount: marketData.length,
        itemBuilder: (context, index) {
          final item = marketData[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.show_chart),
              title: Text(item['symbol']),
              subtitle: Text('Prix : ${item['price'].toStringAsFixed(2)} USD'),
            ),
          );
        },
      ),
    );
  }
}
