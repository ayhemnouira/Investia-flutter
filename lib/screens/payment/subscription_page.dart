import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String selectedPlan = "annual-subscription";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/aa.jpg', width: 200)),
            SizedBox(height: 30),
            Text("Stripe Recurring Subscription",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Please fill the form below to complete the payment",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Text("Choose your payment plan", style: TextStyle(fontSize: 18)),
            Text("60% OFF when you upgrade to annual plan.",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            RadioListTile(
              value: "monthly-subscription",
              groupValue: selectedPlan,
              onChanged: (value) {
                setState(() {
                  selectedPlan = value.toString();
                });
              },
              title: Text("Monthly \$100.00"),
              subtitle: Text(
                  "Pay \$100.00 every month and get access to all premium features."),
            ),
            RadioListTile(
              value: "annual-subscription",
              groupValue: selectedPlan,
              onChanged: (value) {
                setState(() {
                  selectedPlan = value.toString();
                });
              },
              title: Row(
                children: [
                  Text("Yearly \$800.00"),
                  SizedBox(width: 8),
                  Chip(
                      label: Text("60% OFF"),
                      backgroundColor: Colors.blue,
                      labelStyle: TextStyle(color: Colors.white))
                ],
              ),
              subtitle: Text(
                  "Pay \$800.00 every year and get access to all premium features."),
            ),
            TextField(
                decoration: InputDecoration(labelText: "Credit card number")),
            TextField(decoration: InputDecoration(labelText: "MM/AA")),
            TextField(decoration: InputDecoration(labelText: "CVC")),
            TextField(decoration: InputDecoration(labelText: "Email Address")),
            TextField(
                decoration:
                    InputDecoration(labelText: "Coupon code (optional)")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Succès"),
                    content: Text("Abonnement effectué avec succès."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("OK"),
                      )
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Pay With Your Card"),
            ),
            SizedBox(height: 10),
            Text(
              "Pay securely with Stripe. By clicking the button above, you agree to our Terms of Service, Privacy and Refund policies.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("An example project by IKentreprise",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
