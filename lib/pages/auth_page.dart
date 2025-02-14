import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hikehub/repositories/auth_repository.dart';
import 'package:hikehub/utils/app_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    await RepositoryProvider.of<AuthRepository>(context)
        .signInWithEmailPassword(email, password);
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [
            const SizedBox(
              height: 160,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Hasło"),
              obscureText: true,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(onPressed: login, child: const Text("Zaloguj")),
            const SizedBox(
              height: 100,
            ),
            TextButton(
                onPressed: () {
                  context.push("/auth/register");
                },
                child: const Text("Nie masz konta? Zarejestruj się!"))
          ],
        ),
      ),
    );
  }
}
