import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    if (orderProvider.isLoading && orderProvider.orders.isEmpty) {
      orderProvider.fetchOrders();
    }

    return orderProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    order.type == OrderType.buy ? Icons.arrow_upward : Icons.arrow_downward,
                    color: order.type == OrderType.buy ? Colors.green : Colors.red,
                  ),
                  title: Text('${order.assetName} (${order.assetId})'),
                  subtitle: Text(
                    '${order.amount} @ \$${order.price.toStringAsFixed(2)}\n'
                    '${order.date.toString().substring(0, 16)}',
                  ),
                  trailing: Chip(
                    label: Text(
                      order.status.toString().split('.').last,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: order.status == OrderStatus.completed
                        ? Colors.green[100]
                        : order.status == OrderStatus.failed
                            ? Colors.red[100]
                            : Colors.blue[100],
                  ),
                ),
              );
            },
          );
  }
}