import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_patient/presentation/pages/login_page.dart';
import 'package:hms_patient/presentation/pages/new_booking.dart';
import 'package:hms_patient/presentation/pages/paitent_registration_form.dart';
import 'package:hms_patient/presentation/pages/profile_screen.dart';
import 'package:hms_patient/presentation/pages/register_page1.dart';
import 'package:hms_patient/presentation/pages/splash_page.dart';
import 'package:hms_patient/presentation/widgets/bnb.dart';

import '../../presentation/pages/my_booking.dart';
import '../../presentation/pages/paitent_documents.dart';
import '../../presentation/pages/register_page2.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    initialLocation: '/splash_screen',
    routes: [
      GoRoute(
        path: '/splash_screen',
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => RegisterPageScreen1()),
      GoRoute(path: '/register1', builder: (context, state) => RegisterPageScreen2()),
      GoRoute(
        path: '/patient-registration',
        builder: (context, state) => PatientRegistrationForm(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Bnb(navigationShell: navigationShell);
        },
        branches: [
          // 🔹 Home
          StatefulShellBranch(
            initialLocation: '/home',

            routes: [
              GoRoute(path: '/home', builder: (context, state) => MyBooking()),
            ],
          ),

          // 🔹 Docs
          StatefulShellBranch(
            initialLocation: '/docs',
            routes: [
              GoRoute(
                path: '/docs',
                builder: (context, state) => PatientDocumentsScreen(),
              ),
            ],
          ),

          // 🔹 Add
          StatefulShellBranch(
            initialLocation: '/add',

            routes: [
              GoRoute(path: '/add', builder: (context, state) => BookingScreen()),
            ],
          ),

          // 🔹 Profile
          StatefulShellBranch(
            initialLocation: '/profile',

            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => PatientProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
