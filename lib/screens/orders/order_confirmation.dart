import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/notification_service.dart';

void showOrderConfirmation(BuildContext context, Order order) {
  NotificationService.showOrderConfirmation(context, order);
}