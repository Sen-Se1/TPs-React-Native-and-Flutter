import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notes_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Show loading indicator while checking auth status
    if (authProvider.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Choose screen based on auth status
    return authProvider.isAuthenticated ? const HomeScreen() : const AuthScreen();
  }
}