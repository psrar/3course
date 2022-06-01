import 'package:diary/adminPanel/moderator_panel.dart';
import 'package:diary/database/database_interface.dart';
import 'package:diary/widgets/layout.dart';
import 'package:flutter/material.dart';

import 'admin_panel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Авторизация',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: loginController,
                validator: (value) {
                  if (value!.contains(RegExp(r'[*();\-\\/]'))) {
                    return 'Логин содержит недопустимые символы';
                  }
                  if (value.isEmpty) {
                    return 'Необходимо ввести логин';
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Логин',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade700, fontSize: 20),
                  prefixIcon: Icon(Icons.person_rounded,
                      color: Colors.grey.shade600, size: 20),
                  contentPadding: const EdgeInsets.all(6),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue)),
                ),
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) return 'Необходимо ввести пароль';
                },
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade700, fontSize: 20),
                  prefixIcon: Icon(Icons.vpn_key_rounded,
                      color: Colors.grey.shade600, size: 20),
                  contentPadding: const EdgeInsets.all(6),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue)),
                ),
                cursorColor: Colors.black,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.green.shade50,
                    onSurface: Colors.green.shade100,
                    primary: Colors.black),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final db = DatabaseWorker();
                    db
                        .requestLogin(
                            loginController.text, passwordController.text)
                        .then((value) {
                      if (value is User) {
                        showTextSnackBar(context,
                            'Авторизация успешна, ${value.login}', 2000);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => value.role < 2
                                ? const AdminPanel()
                                : const ModeratorPanel()));
                      } else {
                        showTextSnackBar(
                            context, 'Неверный логин или пароль', 2000);
                      }
                    });
                  }
                },
                child: const Text('Войти'),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
