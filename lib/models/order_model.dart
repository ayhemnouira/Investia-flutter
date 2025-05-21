class Order {
  final String id;
  final String assetId;
  final String assetName;
  final double amount;
  final double price;
  final DateTime date;
  final OrderType type;
  final OrderStatus status;

  Order({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.amount,
    required this.price,
    required this.date,
    required this.type,
    this.status = OrderStatus.pending,
  });
}

class RebalanceRecommendation {
  final String assetId;
  final String assetName;
  final double currentPercentage;
  final double targetPercentage;
  final double amountToAdjust;

  RebalanceRecommendation({
    required this.assetId,
    required this.assetName,
    required this.currentPercentage,
    required this.targetPercentage,
    required this.amountToAdjust,
  });
}

enum OrderType { buy, sell }
enum OrderStatus { pending, completed, cancelled, failed }