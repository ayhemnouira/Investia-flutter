import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/withdrawal_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<WithdrawalProvider>(context, listen: false)
        .fetchUserWithdrawalHistory();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _requestWithdrawal() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<WithdrawalProvider>(context, listen: false)
          .requestWithdrawal(double.parse(_amountController.text.trim()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdrawal requested')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Withdrawal failed: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<WithdrawalProvider>(
        builder: (context, provider, child) {
          if (provider.withdrawals.isEmpty) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Withdrawal History',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...provider.withdrawals.map((withdrawal) => Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text('Amount: \$${withdrawal.amount}'),
                        subtitle: Text(
                            'Status: ${withdrawal.accepted ? 'Accepted' : 'Pending'}'),
                      ),
                    )),
                const SizedBox(height: 16),
                const Text('Request Withdrawal',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Request Withdrawal',
                  onPressed: _requestWithdrawal,
                  isLoading: _isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
