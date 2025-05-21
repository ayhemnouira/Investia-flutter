import 'package:flutter/material.dart';
import '../models/market_data.dart';

class PriceCard extends StatelessWidget {
  final MarketData marketData;

  const PriceCard({Key? key, required this.marketData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      child: ListTile(
        title: Text(marketData.symbol, style: TextStyle(fontSize: 18)),
        subtitle: Text('\$${marketData.price.toStringAsFixed(2)}'),
      ),
    );
  }
}
