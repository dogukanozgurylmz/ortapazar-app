import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/feature/ortapazar/presentation/base_page/base_view.dart';
import 'package:ortapazar/feature/ortapazar/presentation/signin/cubit/signin_cubit.dart';
import 'package:ortapazar/main.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignInCubit>(),
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          final cubit = context.read<SignInCubit>();
          return state.isSignIn
              ? const BaseView()
              : Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Ortapazar",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          "Giriş",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 100),
                        InkWell(
                          onTap: () async {
                            await cubit.signInWithGoogle();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xffD9D9D9)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/googleicon.png"),
                                const SizedBox(width: 20),
                                const Text(
                                  "Google İle Giriş Yap",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(height: 20),
                        // InkWell(
                        //   onTap: () async {
                        //     await cubit.signInWithFacebook();
                        //   },
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * 0.8,
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(
                        //           width: 1, color: const Color(0xffD9D9D9)),
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(10)),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Image.asset("assets/images/facebookicon.png"),
                        //         const SizedBox(width: 20),
                        //         const Text(
                        //           "Facebook İle Giriş Yap",
                        //           style: TextStyle(fontSize: 22),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
