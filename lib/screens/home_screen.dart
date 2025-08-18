import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/screens/profil_screen.dart';
import 'package:automatic_fraud_detection/screens/transaction_screen.dart';
import 'deposit_screen.dart';
import 'transfer_screen.dart';
import 'withdraw_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final currentTime = DateFormat('h:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          currentTime,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildHomeContent(),
          const TransactionsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildWelcomeSection(),
          const SizedBox(height: 25),
          _buildBalanceAndBankCard(context),
          const SizedBox(height: 30),
          _buildQuickActions(),
          const SizedBox(height: 30),
          _buildTransactionsHeader(),
          const SizedBox(height: 15),
          _buildTransactionList(),
        ],
      ),
    );
  }

    Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Extraire juste le prénom du nom complet
        String displayName = authProvider.userName;
        if (displayName.contains(' ')) {
          displayName = displayName.split(' ').first;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $displayName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'How are you today?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBalanceAndBankCard(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        String balance = authProvider.userBalance; // <-- récupération du solde

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.credit_card,
                                color: Colors.white.withOpacity(0.7)),
                            const SizedBox(width: 3),
                            const Text(
                              'Current Balance',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '\$ ${balance}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Exp',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '02/25',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          icon: Icons.add,
          label: 'Deposit',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DepositScreen()),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.send,
          label: 'Transfer',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransferScreen()),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.monetization_on_sharp,
          label: 'Withdraw',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WithdrawScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.blue[800], size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'See All',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final transactions = [
      {'type': 'Top up', 'time': 'Today 1:53 PM', 'amount': '+100.00', 'icon': Icons.add},
      {'type': 'Transfer', 'time': 'Today 2:33 PM', 'amount': '-500.00', 'icon': Icons.send},
      {'type': 'Received', 'time': 'Today 3:32 PM', 'amount': '+50.00', 'icon': Icons.receipt},
      {'type': 'Top up', 'time': 'Jan 15, 5:15 AM', 'amount': '+20.00', 'icon': Icons.add},
    ];

    return Column(
      children: transactions.map((txn) {
        final amount = txn['amount'] as String;
        final isPositive = amount.startsWith('+');
        final color = isPositive ? Colors.green : Colors.red;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              txn['icon'] as IconData,
              color: color,
              size: 20,
            ),
          ),
          title: Text(
            txn['type'] as String,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            txn['time'] as String,
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}