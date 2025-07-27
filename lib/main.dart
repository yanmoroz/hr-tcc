import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'di/app_di.dart';
import 'presentation/cubits/auth/auth_cubit.dart';
import 'presentation/cubits/cubit_factory.dart';
import 'presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  await initDI();
  runApp(MainApp(appRouter: GetIt.I<AppRouter>()));
}

class MainApp extends StatelessWidget {
  final AppRouter appRouter;

  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return _defaultBody();
  }

  Widget _defaultBody() {
    return BlocProvider(
      create: (context) => CubitFactory.createAuthCubit(),
      child: Builder(
        builder: (context) {
          return FutureBuilder(
            future: appRouter.createRouter(context.read<AuthCubit>()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              return MaterialApp.router(
                theme: ThemeData(primaryColor: const Color(0xFF0A3899)),
                routerConfig: snapshot.data!,
              );
            },
          );
        },
      ),
    );
  }
}
