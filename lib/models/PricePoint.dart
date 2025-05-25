class PricePoint {
  final DateTime date;
  final double price;

  PricePoint({required this.date, required this.price});

  factory PricePoint.fromJson(List<dynamic> json) {
    return PricePoint(
      date: DateTime.fromMillisecondsSinceEpoch(json[0]),
      price: json[1].toDouble(),
    );
  }
}
