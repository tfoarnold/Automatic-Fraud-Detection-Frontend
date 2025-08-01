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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(builder: (context, auth, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => CategoriesProvider()),
            ChangeNotifierProvider(create: (context) => TransactionsProvider()),
            ChangeNotifierProvider(create: (context) => AuthProvider()),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              routes: {
                '/LoginScreen': (context) => const LoginScreen(),
                '/RegisterScreen': (context) => const RegisterScreen(),
                '/HomeScreen': (context) => const HomeScreen(),
                '/CategoriesScreen': (context) => const CategoriesScreen(),
              },
              home: const BaseScreen()
          ),
        );
      }),
    );
  }
}
