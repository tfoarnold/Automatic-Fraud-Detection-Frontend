import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/providers/categories_provider.dart';
import 'package:automatic_fraud_detection/providers/transactions_provider.dart';
import 'package:automatic_fraud_detection/screens/base_screen.dart';
import 'package:automatic_fraud_detection/screens/categories_screen.dart';
import 'package:automatic_fraud_detection/screens/home_screen.dart';
import 'package:automatic_fraud_detection/screens/login_screen.dart';
import 'package:automatic_fraud_detection/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => TransactionsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fraud Detection App',
        routes: {
          '/LoginScreen': (context) => const LoginScreen(),
          '/RegisterScreen': (context) => const RegisterScreen(),
          '/HomeScreen': (context) => const HomeScreen(),
          // '/CategoriesScreen': (context) => const CategoriesScreen(),
        },
        home: const BaseScreen(),
      ),
    );
  }
}

// Widget de chargement global pour les états d'attente
class LoadingWidget extends StatelessWidget {
  final String message;
  
  const LoadingWidget({super.key, this.message = 'Chargement...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}