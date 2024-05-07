import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/screens/auth/bloc/auth_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_filed_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 64,
                color: primaryColor,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFormWidget(
                  controller: _emailController,
                  hintText: "Enter your email",
                  prefixIcon: Icons.email),
              const SizedBox(
                height: 24,
              ),
              TextFormWidget(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  prefixIcon: Icons.security),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  if (isValidData(mainContext)) {
                    context.read<AuthBloc>().add(AuthLoginEvent(
                        email: _emailController.text,
                        password: _passwordController.text));
                  }
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: blueColor,
                    ),
                    child: Text('Log In',
                        style: GoogleFonts.roboto().copyWith(
                            fontSize: 18,
                            color: secondaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Don't have an account? ",
                      style: GoogleFonts.roboto().copyWith(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(mainContext, Routes.register);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text("Sign Up",
                          style: GoogleFonts.roboto()
                              .copyWith(fontSize: 16, color: primaryColor)),
                    ),
                  )
                ],
              ),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  return const SizedBox();
                },
                listener: (context, state) {
                  if (state is AuthLoaded) {
                    context.loaderOverlay.hide();
                    if (state.isRedirect) {
                      Navigator.pushNamed(context, Routes.main);
                    }
                  } else if (state is AuthLoading) {
                    context.loaderOverlay.show();
                  } else if (state is AuthError) {
                    showSnackBar(state.error, mainContext, Colors.red);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValidData(BuildContext context) {
    String error = "";

    if (_emailController.text.isEmpty) {
      error = "please enter email";
    } else if (_passwordController.text.isEmpty) {
      error = "please enter password";
    }

    if (error.isNotEmpty) {
      showSnackBar(error, context, Colors.red);
      return false;
    } else {
      return true;
    }
  }
}
