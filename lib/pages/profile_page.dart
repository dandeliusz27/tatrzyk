import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikehub/repositories/auth_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void logout() async {
    await RepositoryProvider.of<AuthRepository>(context).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        RepositoryProvider.of<AuthRepository>(context).getUserProfile();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cześć ${user!.firstName}"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: Container()),
          ElevatedButton(onPressed: logout, child: const Text("Wyloguj")),
          SizedBox(
            height: 40,
          )
        ],
      )),
    );
  }
}
