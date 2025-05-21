import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import 'buy_sell_screen.dart';
import 'rebalance_screen.dart';
import 'order_history.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders & Rebalancing'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Buy/Sell'),
              Tab(text: 'Rebalance'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BuySellScreen(),
            RebalanceScreen(),
            OrderHistoryScreen(),
          ],
        ),
      ),
    );
  }
}