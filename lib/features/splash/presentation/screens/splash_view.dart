import 'package:expense_management/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/splash_bloc.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is NavigateToAuth) {
            context.replace("/login");
            return;
          } else if (state is NavigateToHome) {
            context.replace("/home");
            return;
          }
        },
        builder: (context, state) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
