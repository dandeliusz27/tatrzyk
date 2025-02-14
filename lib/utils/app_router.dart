import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hikehub/pages/auth_page.dart';
import 'package:hikehub/pages/friends_page.dart';
import 'package:hikehub/pages/home_page.dart';
import 'package:hikehub/pages/profile_page.dart';
import 'package:hikehub/pages/register_page.dart';
import 'package:hikehub/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRouter {
  final router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isLoggingIn = state.fullPath?.startsWith("/auth") == true;
        final isAuthenticated =
            RepositoryProvider.of<AuthRepository>(context).isAuthenticated();
        if (!isAuthenticated && !isLoggingIn) {
          return '/auth';
        }

        return null;
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), label: 'Wall'),
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: 'Szukaj'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: 'Znajomi'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Profil'),
                ],
                currentIndex: navigationShell.currentIndex,
                onTap: (int index) => navigationShell.goBranch(index),
              ),
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/',
                builder: (context, state) {
                  return HomePage();
                },
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("Mapa"),
                    ),
                  );
                },
              )
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("Szukaj"),
                    ),
                  );
                },
              )
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/people',
                builder: (context, state) {
                  return FriendsPage();
                },
              )
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) {
                  return ProfilePage();
                },
              )
            ])
          ],
        ),
        GoRoute(
            path: '/auth',
            builder: (context, state) => AuthPage(),
            routes: [
              GoRoute(
                path: 'register',
                builder: (context, state) => RegisterPage(),
              )
            ])
      ]);
}
