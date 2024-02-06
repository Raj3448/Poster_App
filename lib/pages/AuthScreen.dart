import 'package:case_study/bloc/autth_bloc.dart';
import 'package:case_study/pages/rootpage.dart';

import 'package:case_study/widgets/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/authSCreen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _startPosition = -20.0;
  double _endPosition = 7.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: _startPosition, end: _endPosition)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  AuthWidget authWidget = AuthWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 115, 47, 251),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 3),
            ));
          }
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RootPage()),
                (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: GestureDetector(
              onTap: () {
                onTapFunction(authWidget.getFocus1, authWidget.getFocus2,
                    authWidget.getFocus3);
              },
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: const Color.fromARGB(255, 115, 47, 251),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            //width: MediaQuery.of(context).size.width *0.,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Opacity(
                                opacity: _controller.value,
                                child: Transform.translate(
                                  offset: Offset(-_animation.value, 0.0),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome Back !',
                                        style: TextStyle(
                                            fontSize: 26, color: Colors.white),
                                      ),
                                      Text(
                                        'Log into your account',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                        )
                      ],
                    ),
                    Center(
                      child: Container(
                          padding: const EdgeInsets.only(top: 240),
                          child: authWidget),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onTapFunction(
      FocusNode focusNode1, FocusNode focusNode2, FocusNode focusNode3) {
    if (focusNode1.hasFocus) {
      focusNode1.unfocus();
    }

    if (focusNode2.hasFocus) {
      focusNode2.unfocus();
    }

    if (focusNode3.hasFocus) {
      focusNode3.unfocus();
    }
  }
}
