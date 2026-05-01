import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_patient/app_helpers/assets/app_assets.dart';
import 'package:hms_patient/app_helpers/network/token_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _navigate();
      }
    });
  }

  Future<void> _navigate() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();

    if (!mounted) return;

    if (tokenStorage.isLoggedIn && tokenStorage.hasToken) {
      context.go('/home');
    } else {
      context.go('/register1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff16618c),
      body: Center(child: AppAssets.appIcon),
    );
  }
}
