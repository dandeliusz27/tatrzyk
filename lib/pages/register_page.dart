import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hikehub/models/profile.dart';
import 'package:hikehub/repositories/auth_repository.dart';
import 'package:hikehub/utils/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final PageController _pageController = PageController();

  void register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final lastName = _lastNameController.text;
    final firstName = _firstNameController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Podane hasła nie są jednakowe!")));
      return;
    }

    await RepositoryProvider.of<AuthRepository>(context).registerUser(
        email, password, Profile(firstName: firstName, lastName: lastName));

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rejestracja"),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            ListView(
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
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: "Imię"),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: "Nazwisko"),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      _pageController.jumpToPage(1);
                    },
                    child: const Text("Dalej")),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                const SizedBox(
                  height: 160,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Hasło"),
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: "Powtórz hasło"),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        _pageController.jumpToPage(0);
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                SizedBox(
                  height: 80,
                ),
                ElevatedButton(
                    onPressed: register, child: const Text("Zarejestruj")),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
