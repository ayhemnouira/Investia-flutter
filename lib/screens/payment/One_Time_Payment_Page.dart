import 'package:flutter/material.dart';

class OneTimePaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
        child: Column(
          children: [
            Center(child: Image.asset('assets/images/aa.jpg', width: 200)),
            SizedBox(height: 30),
            Text("Stripe One-Time Charge",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Please fill the form below to complete the payment",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Container(
              height: 100,
              child: TextField(
                controller: TextEditingController(text: "Action ID9378267290 USD 1000000"),
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Détails de l'action",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TextField(decoration: InputDecoration(labelText: "Email Address")),
            TextField(decoration: InputDecoration(labelText: "Credit card number")),
            TextField(decoration: InputDecoration(labelText: "MM/AA")),
            TextField(decoration: InputDecoration(labelText: "CVC")),
            SizedBox(height: 20),
            Container(
              height: 50,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Text("Stripe Card Element Placeholder"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Succès"),
                    content: Text("Paiement effectué avec succès."),
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
              child: Text("Pay Now"),
            ),
            SizedBox(height: 10),
            Text(
              "Pay securely with Stripe. By clicking the button above, you agree to our Terms of Service, Privacy and Refund policies.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("An example project by IKentreprise", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
