import 'package:flutter/material.dart';

class DepositScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépôt'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Montant à déposer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Méthode de dépôt',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPaymentMethod(
              icon: Icons.account_balance,
              title: 'Virement bancaire',
              subtitle: '2-3 jours ouvrables',
            ),
            _buildPaymentMethod(
              icon: Icons.credit_card,
              title: 'Carte de crédit',
              subtitle: 'Instantané',
            ),
            _buildPaymentMethod(
              icon: Icons.mobile_friendly,
              title: 'Mobile Money',
              subtitle: 'Instantané',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Logique de dépôt
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirmer le dépôt',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.blue[800]),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio(
        value: title,
        groupValue: title,
        onChanged: (value) {},
      ),
    );
  }
}