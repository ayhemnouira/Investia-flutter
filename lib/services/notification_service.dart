import 'package:flutter/material.dart';
import '../models/order_model.dart';

class NotificationService {
  static void showOrderConfirmation(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${order.type.toString().split('.').last.toUpperCase()} Order Placed'),
            const SizedBox(height: 10),
            Text('Asset: ${order.assetName}'),
            Text('Amount: ${order.amount}'),
            Text('Price: \$${order.price.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showRebalanceNotification(BuildContext context, int ordersExecuted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rebalance completed: $ordersExecuted orders executed'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}