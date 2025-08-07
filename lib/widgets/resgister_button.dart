import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class RegisterButton extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController password;
  const RegisterButton({super.key, required this.name, required this.phone, required this.password});

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
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                authProvider.register(
                    name.text, phone.text as int, password.text);
              }),
        ),
      ],
    );
  }
}
