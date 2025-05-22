import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final _coinIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<WatchlistProvider>(context, listen: false).fetchUserWatchlist();
  }

  @override
  void dispose() {
    _coinIdController.dispose();
    super.dispose();
  }

  void _addCoin() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<WatchlistProvider>(context, listen: false)
          .addCoin(_coinIdController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coin added to watchlist')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add coin: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<WatchlistProvider>(
        builder: (context, provider, child) {
          if (provider.watchlist == null) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Watchlist',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...provider.watchlist!.coins.map((coin) => Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(coin.name),
                        subtitle: Text(
                            'Symbol: ${coin.symbol}\nPrice: \$${coin.currentPrice}'),
                      ),
                    )),
                const SizedBox(height: 16),
                TextField(
                  controller: _coinIdController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Coin ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Add Coin',
                  onPressed: _addCoin,
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
