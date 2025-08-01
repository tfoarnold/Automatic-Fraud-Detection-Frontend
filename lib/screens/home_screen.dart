import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/screens/categories_screen.dart';
import 'package:automatic_fraud_detection/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget>? screens = [
    const CategoriesScreen(),
    const TransactionsScreen(),
    Container(),
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: screens!.elementAt(selectedIndex),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: BottomNavigationBar(
          fixedColor: Colors.blueAccent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.paid),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: (index){
            if(index == 2){
              authProvider.logout(context);
            }
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
