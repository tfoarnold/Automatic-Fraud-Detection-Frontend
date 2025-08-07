import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedFilter = 0; // 0=Toutes, 1=Frauduleuses, 2=Normales
  final List<Map<String, dynamic>> _allTransactions = [
    {
      'id': 'TX1001',
      'amount': 1250.00,
      'recipient': 'John Smith',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'isFraud': true,
      'type': 'Transfert',
      'account': '••••7890'
    },
    {
      'id': 'TX1002',
      'amount': 320.50,
      'recipient': 'Sarah Johnson',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'isFraud': false,
      'type': 'Dépôt',
      'account': '••••3456'
    },
    {
      'id': 'TX1003',
      'amount': 875.00,
      'recipient': 'Unknown',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'isFraud': true,
      'type': 'Retrait',
      'account': '••••9012'
    },
    {
      'id': 'TX1004',
      'amount': 42.30,
      'recipient': 'Amazon Market',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'isFraud': false,
      'type': 'Paiement',
      'account': '••••5678'
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    switch (_selectedFilter) {
      case 1:
        return _allTransactions.where((txn) => txn['isFraud'] == true).toList();
      case 2:
        return _allTransactions.where((txn) => txn['isFraud'] == false).toList();
      default:
        return _allTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse des Transactions'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterButton('Toutes', 0),
          _buildFilterButton('Frauduleuses', 1),
          _buildFilterButton('Normales', 2),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, int index) {
    final isSelected = _selectedFilter == index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected
                ? index == 1
                ? Colors.red[50]
                : Colors.green[50]
                : Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected
                    ? index == 1
                    ? Colors.red[200]!
                    : Colors.green[200]!
                    : Colors.grey[200]!,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            setState(() {
              _selectedFilter = index;
            });
          },
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? index == 1
                  ? Colors.red[800]
                  : Colors.green[800]
                  : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 50,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 1
                  ? 'Aucune transaction frauduleuse'
                  : 'Aucune transaction normale',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: _filteredTransactions.length,
      itemBuilder: (context, index) {
        final txn = _filteredTransactions[index];
        return _buildTransactionCard(txn);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isFraud = transaction['isFraud'] as bool;
    final amount = transaction['amount'] as double;
    final date = transaction['date'] as DateTime;
    final type = transaction['type'] as String;
    final recipient = transaction['recipient'] as String;
    final account = transaction['account'] as String;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Action lorsqu'on clique sur une transaction
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isFraud ? Colors.red[50] : Colors.green[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFraud ? Icons.warning : Icons.verified,
                          color: isFraud ? Colors.red : Colors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        type,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${amount >= 0 ? '+' : ''}\$${amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isFraud ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 12),
              _buildDetailRow('Destinataire', recipient),
              _buildDetailRow('Compte', account),
              _buildDetailRow(
                'Date',
                DateFormat('dd MMM yyyy - HH:mm').format(date),
              ),
              if (isFraud) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.red[800]),
                      const SizedBox(width: 6),
                      Text(
                        'Transaction suspecte',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}