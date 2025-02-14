import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikehub/repositories/auth_repository.dart';
import 'package:hikehub/utils/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtcGxlcnhsaXFhaGludXlxZ25mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3ODU5OTIsImV4cCI6MjA1NDM2MTk5Mn0.kj7bGScGODKJ6CtV0u-JULnH8JqoMT5bgvXqQfmbPzM",
      url: "https://tmplerxliqahinuyqgnf.supabase.co");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final _appRouter = AppRouter();
  late final AuthRepository _authRepository;
  @override
  void initState() {
    _authRepository = AuthRepository(approuter: _appRouter.router);

    _authRepository.initAuth();
    super.initState();
  }

  @override
  void dispose() {
    _authRepository.disposeAuth();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => _authRepository)],
      child: MaterialApp.router(
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 231, 97, 255),
            scaffoldBackgroundColor: const Color.fromARGB(255, 226, 226, 226),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              backgroundColor: WidgetStatePropertyAll(Colors.purple[300]),
            )),
            appBarTheme: const AppBarTheme(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color.fromARGB(255, 223, 223, 223),
                selectedItemColor: Colors.purple,
                unselectedItemColor: Colors.black54)),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
