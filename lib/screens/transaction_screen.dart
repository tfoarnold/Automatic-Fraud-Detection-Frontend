import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/providers/transactions_provider.dart';
import '../models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _selectedFilter = 0; // 0=Toutes, 1=Frauduleuses, 2=Normales

  @override
  void initState() {
    super.initState();
    // Charger les transactions au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions();
    });
  }

  void _loadTransactions() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    
    if (authProvider.token.isNotEmpty) {
      transactionsProvider.getTransactions(authProvider.token);
    }
  }

  List<LocalTransaction> _getFilteredTransactions(List<LocalTransaction> allTransactions) {
    switch (_selectedFilter) {
      case 1:
        return allTransactions.where((txn) => txn.isFraudulent).toList();
      case 2:
        return allTransactions.where((txn) => !txn.isFraudulent).toList();
      default:
        return allTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse des Transactions'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTransactions,
          ),
        ],
      ),
      body: Consumer<TransactionsProvider>(
        builder: (context, transactionsProvider, child) {
          if (transactionsProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des transactions...'),
                ],
              ),
            );
          }

          if (transactionsProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    transactionsProvider.error,
                    style: TextStyle(color: Colors.red[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTransactions,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final filteredTransactions = _getFilteredTransactions(
            transactionsProvider.transactions
          );

          return Column(
            children: [
              _buildFilterBar(transactionsProvider.transactions),
              Expanded(
                child: _buildTransactionList(filteredTransactions),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(List<LocalTransaction> allTransactions) {
    final fraudCount = allTransactions.where((txn) => txn.isFraudulent).length;
    final normalCount = allTransactions.where((txn) => !txn.isFraudulent).length;
    
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
          _buildFilterButton('Toutes (${allTransactions.length})', 0),
          _buildFilterButton('Frauduleuses ($fraudCount)', 1),
          _buildFilterButton('Normales ($normalCount)', 2),
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
                : index == 2 
                ? Colors.green[50]
                : Colors.blue[50]
                : Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isSelected
                    ? index == 1
                    ? Colors.red[200]!
                    : index == 2
                    ? Colors.green[200]!
                    : Colors.blue[200]!
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
                  : index == 2
                  ? Colors.green[800]
                  : Colors.blue[800]
                  : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<LocalTransaction> filteredTransactions) {
    if (filteredTransactions.isEmpty) {
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
                  : _selectedFilter == 2
                  ? 'Aucune transaction normale'
                  : 'Aucune transaction trouvée',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadTransactions();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final txn = filteredTransactions[index];
          return _buildTransactionCard(txn);
        },
      ),
    );
  }

  Widget _buildTransactionCard(LocalTransaction transaction) {
    final isFraud = transaction.isFraudulent;
    final amount = double.tryParse(transaction.amount ?? '0') ?? 0.0;
    
    // Parser la date
    DateTime date;
    try {
      date = transaction.transactionDate ?? DateTime.now();
    } catch (e) {
      date = DateTime.now();
    }

    final type = transaction.typeDisplay; // Utilise le getter du nouveau modèle
    final recipient = transaction.description ?? transaction.reference ?? 'Description non disponible';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showTransactionDetails(transaction);
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
                      color: isFraud ? Colors.red : (amount >= 0 ? Colors.green : Colors.orange),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 12),
              _buildDetailRow('Description', recipient),
              _buildDetailRow('Référence', transaction.reference ?? 'N/A'),
              _buildDetailRow('Type', transaction.typeDisplay),
              _buildDetailRow(
                'Date',
                DateFormat('dd MMM yyyy - HH:mm').format(date),
              ),
              if (transaction.confidenceScore != null)
                _buildDetailRow('Score de confiance', '${(transaction.confidenceScore! * 100).toStringAsFixed(1)}%'),
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
                        transaction.isSuspicious ? 'Transaction suspecte' : 'Transaction frauduleuse détectée',
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

  String _getTransactionType(LocalTransaction transaction) {
    return transaction.typeDisplay; // Utilise le getter du nouveau modèle
  }

  void _showTransactionDetails(LocalTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction ${transaction.reference ?? transaction.id}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Montant', '\$${transaction.amount ?? '0.00'}'),
              _buildDetailRow('Type', transaction.typeDisplay),
              _buildDetailRow('Statut', transaction.statusDisplay),
              _buildDetailRow('Description', transaction.description ?? 'N/A'),
              _buildDetailRow('Référence', transaction.reference ?? 'N/A'),
              _buildDetailRow('Date', transaction.dateEnregistrement ?? 'N/A'),
              if (transaction.confidenceScore != null)
                _buildDetailRow('Score de confiance', '${(transaction.confidenceScore! * 100).toStringAsFixed(1)}%'),
              if (transaction.fraudFlagReason?.isNotEmpty == true)
                _buildDetailRow('Raison de fraude', transaction.fraudFlagReason!),
              if (transaction.isVerified == true)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, color: Colors.blue[800], size: 16),
                      const SizedBox(width: 8),
                      const Text('Transaction vérifiée', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
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
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}