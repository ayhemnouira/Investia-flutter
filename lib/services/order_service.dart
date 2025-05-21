import '../models/order_model.dart';

class OrderService {
  Future<List<Order>> getUserOrders() async {

    await Future.delayed(const Duration(seconds: 1));
    return [
      Order(
        id: '1',
        assetId: 'BTC',
        assetName: 'Bitcoin',
        amount: 0.5,
        price: 50000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: OrderType.buy,
        status: OrderStatus.completed,
      ),
    ];
  }

  Future<List<RebalanceRecommendation>> getRebalanceRecommendations() async {
    
    await Future.delayed(const Duration(seconds: 1));
    return [
      RebalanceRecommendation(
        assetId: 'BTC',
        assetName: 'Bitcoin',
        currentPercentage: 45,
        targetPercentage: 50,
        amountToAdjust: 0.1,
      ),
    ];
  }

  Future<Order> placeOrder(Order order) async {
    
    await Future.delayed(const Duration(seconds: 1));
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      assetId: order.assetId,
      assetName: order.assetName,
      amount: order.amount,
      price: order.price,
      date: DateTime.now(),
      type: order.type,
      status: OrderStatus.completed,
    );
  }
}