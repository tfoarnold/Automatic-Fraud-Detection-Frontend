import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/widgets/custom_text_field.dart';
import 'package:automatic_fraud_detection/widgets/resgister_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phone = TextEditingController();
  final  _name = TextEditingController();
  final  _password = TextEditingController();
  bool obscurePass = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Card(
          elevation: 20,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.7,
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Transaction App ',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 30),
                ),
                CustomTextField(
                  controller:_name,
                  hint: 'Name',
                  label: 'Name',
                  prefixIcon: const Icon(
                    Icons.account_circle_sharp,
                    color: Colors.blueAccent,
                  ),
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
                RegisterButton(name: _name,phone: _phone,password: _password),
              ],
            ),
          ),
        ),
      ),
    );
  }
}