import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet_transaction.dart';
import '../providers/wallet_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _walletIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<WalletProvider>(context, listen: false).fetchUserWallet();
  }

  @override
  void dispose() {
    _walletIdController.dispose();
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _transfer() async {
    setState(() => _isLoading = true);
    try {
      final transaction = WalletTransaction(
        amount: double.parse(_amountController.text.trim()),
        purpose: _purposeController.text.trim(),
      );
      await Provider.of<WalletProvider>(context, listen: false)
          .transfer(int.parse(_walletIdController.text.trim()), transaction);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transfer successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer failed: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(16.0), // Fixed: Removed "Antigua and Barbuda"
      child: Consumer<WalletProvider>(
        builder: (context, provider, child) {
          if (provider.wallet == null) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Wallet',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text('Balance: \$${provider.wallet!.balance}'),
                    subtitle: Text('Wallet ID: ${provider.wallet!.id}'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Transfer Funds',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _walletIdController,
                  decoration: const InputDecoration(
                    labelText: 'Recipient Wallet ID',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
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
                TextField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Transfer',
                  onPressed: _transfer,
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
