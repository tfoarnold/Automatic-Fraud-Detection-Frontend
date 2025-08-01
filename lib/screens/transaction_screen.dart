import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/providers/transactions_provider.dart';
import 'package:automatic_fraud_detection/widgets/add_transaction.dart';
import 'package:automatic_fraud_detection/widgets/screens_header.dart';
import 'package:automatic_fraud_detection/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final trans = Provider.of<TransactionsProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return const AddTransaction();
              });
        },
      ),
      // backgroundColor: Colors.purple,
      body: Column(
        children: [
         const ScreenHeader(text: 'Your Transactions'),
          Expanded(
            child: FutureBuilder(
                future: trans.getTransactions(auth.token),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: trans.transactions.length,
                      itemBuilder: (context, index) {
                        DateTime? now = trans.transactions[index].transactionDate;
                        // String formattedDate = DateFormat('yyyy/MM/dd, kk:mm')
                        //     .format(now ?? DateTime.now());

                        return TransactionItem(
                          transaction: trans.transactions[index],
                          isEven: index % 2 != 0 ? false : true,
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
