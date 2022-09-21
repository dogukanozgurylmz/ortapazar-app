import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/constants/text_style_constant.dart';
import 'package:ortapazar/feature/ortapazar/presentation/signin/signin_view.dart';

import '../../../../main.dart';
import 'cubit/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 1500),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashCubit>(),
      child: BlocBuilder<SplashCubit, SplashState>(
        builder: (context, state) {
          _controller.forward();
          return state.isFirebaseInitialize
              ? const SignInView()
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Hero(
                      tag: "heroLogo",
                      child: FadeTransition(
                        opacity: _controller,
                        child: Image.asset("assets/images/ortapazar_icon.png"),
                        // Text(
                        //   "ORTAPAZAR",
                        //   style: TextStyle(
                        //     fontSize: 40,
                        //     color: Colors.grey[850],
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
