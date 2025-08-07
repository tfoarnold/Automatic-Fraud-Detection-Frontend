import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController phone;
  final TextEditingController password;
  const LoginButton({super.key, required this.phone, required this.password});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        SizedBox(
          width: size.width * 0.3,
          height: size.height * 0.035,
          child: MaterialButton(
              color: Colors.blueAccent,
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                authProvider.login( phone.text.toString(),password.text.toString(),context);
              }),
        ),
      ],
    );
  }
}
