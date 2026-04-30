import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/network/token_storage.dart';
import 'package:hms_patient/app_helpers/routes/app_router.dart';

import 'app_helpers/network/api_base_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => TokenStorage()),
        RepositoryProvider(create: (_) => ApiBaseHelper()),
      ],
      child: MaterialApp.router(
        title: 'HMS Paitent',
        debugShowCheckedModeBanner: false ,
        routerConfig: AppRouter.router,
      ),
    );
  }
}