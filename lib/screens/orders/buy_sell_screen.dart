import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import 'order_confirmation.dart';

class BuySellScreen extends StatefulWidget {
  const BuySellScreen({super.key});

  @override
  State<BuySellScreen> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  final _formKey = GlobalKey<FormState>();
  OrderType _orderType = OrderType.buy;
  String _assetId = 'BTC';
  double _amount = 0.0;
  double _price = 0.0;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Buy'),
                    selected: _orderType == OrderType.buy,
                    onSelected: (selected) {
                      setState(() {
                        _orderType = OrderType.buy;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Sell'),
                    selected: _orderType == OrderType.sell,
                    onSelected: (selected) {
                      setState(() {
                        _orderType = OrderType.sell;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _assetId,
              items: const [
                DropdownMenuItem(value: 'BTC', child: Text('Bitcoin (BTC)')),
                DropdownMenuItem(value: 'ETH', child: Text('Ethereum (ETH)')),
                DropdownMenuItem(value: 'AAPL', child: Text('Apple (AAPL)')),
              ],
              onChanged: (value) {
                setState(() {
                  _assetId = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Asset'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price per unit'),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
              onSaved: (value) {
                _price = double.parse(value!);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  
                  final order = Order(
                    id: '',
                    assetId: _assetId,
                    assetName: _assetId == 'BTC' ? 'Bitcoin' : 
                              _assetId == 'ETH' ? 'Ethereum' : 'Apple',
                    amount: _amount,
                    price: _price,
                    date: DateTime.now(),
                    type: _orderType,
                  );
                  
                  final success = await orderProvider.placeOrder(order);
                  if (success && mounted) {
                    showOrderConfirmation(context, order);
                  }
                }
              },
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}