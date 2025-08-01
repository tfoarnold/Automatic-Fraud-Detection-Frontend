import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/widgets/custom_text_field.dart';
import 'package:automatic_fraud_detection/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          width: size.width * 0.9,
          height: size.height * 0.5,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Transaction App',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.blueAccent, fontSize: 30),
              ),

              CustomTextField(
                controller: _phone,
                hint: 'Phone',
                label: 'Phone',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_enabled_outlined,
                  color: Colors.blueAccent,
                ),
              ),

              CustomTextField(
                controller: _password,
                hint: 'Password',
                label: 'Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscurePass,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.blueAccent,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePass = !obscurePass;
                    });
                  },
                ),
              ),

              LoginButton(phone: _phone, password: _password),
            ],
          ),
        ),
      ),
    );
  }
}