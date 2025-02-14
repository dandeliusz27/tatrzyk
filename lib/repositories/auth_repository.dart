import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hikehub/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserAuthenticated { authenticated, unAuthenticated }

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;
  User? _currentUser;
  Profile? _userProfile;
  late GoRouter _appRouter;

  AuthRepository({required GoRouter approuter}) {
    _appRouter = approuter;
  }

  void initAuth() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _currentUser = data.session!.user;
        refreshProfile();
      } else {
        _currentUser = null;
        _userProfile = null;
      }
      _appRouter.refresh();
    });
  }

  void disposeAuth() {
    _authSubscription.cancel();
  }

  Future refreshProfile() async {
    var map = await _supabase
        .from("profile")
        .select()
        .eq('id', _currentUser!.id)
        .single();
    _userProfile = Profile.fromMap(map);
  }

  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<bool> registerUser(
      String email, String password, Profile profile) async {
    try {
      AuthResponse response = await signUpWithEmailPassword(email, password);
      if (response.user != null) {
        await Supabase.instance.client.from("profile").update({
          "first_name": profile.firstName,
          "last_name": profile.lastName,
          "birthdate": null,
          "avatar": null
        }).eq('id', response.user!.id);
        signInWithEmailPassword(email, password);
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  Profile? getUserProfile() {
    return _userProfile;
  }

  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }
}
