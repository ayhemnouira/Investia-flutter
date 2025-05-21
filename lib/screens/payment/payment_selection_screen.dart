// lib/screens/payment/payment_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Importer AppRoutes depuis le fichier centralisé pour les NOMS de routes
import 'package:investia/risk_management/navigation/app_router.dart';

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({super.key});

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Options de Paiement"),
        // Le bouton retour est géré par GoRouter si la page est "pushed"
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 150,
                height: 75,
                margin: const EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/images/aa.jpg', fit: BoxFit.contain),
              ),
              Text(
                "Options de Paiement",
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Que souhaitez-vous faire ?",
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.credit_card),
                label: const Text("Paiement Unique"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // **CORRECTION ICI : Utiliser context.pushNamed avec le nom de la sous-route**
                  print("Navigating to one-time payment using pushNamed('${AppRoutes.oneTimePaymentRouteName}')...");
                  context.pushNamed(AppRoutes.oneTimePaymentRouteName);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.subscriptions_outlined),
                label: const Text("S'abonner (Récurrent)"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // **CORRECTION ICI : Utiliser context.pushNamed avec le nom de la sous-route**
                  print("Navigating to subscription payment using pushNamed('${AppRoutes.subscriptionPaymentRouteName}')...");
                  context.pushNamed(AppRoutes.subscriptionPaymentRouteName);
                },
              ),
              const SizedBox(height: 50),
              Text(
                "Un exemple de projet par IKentreprise",
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}