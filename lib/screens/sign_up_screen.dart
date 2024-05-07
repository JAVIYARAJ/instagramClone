import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/screens/auth/bloc/auth_bloc.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_filed_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  height: 64,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 34,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        state.selectedFile != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    MemoryImage(state.selectedFile!))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child:
                                    Image.asset("assets/ic_profile_icon.png"),
                              ),
                        GestureDetector(
                          onTap: () async{
                            Uint8List? imagePath =
                                await pickImage(ImageSource.gallery);
                            if (context.mounted && imagePath != null) {
                              context
                                  .read<AuthBloc>()
                                  .add(PickImageEvent(imagePath));
                            }
                          },
                          child: Text(
                            "Choose image",
                            style: GoogleFonts.roboto()
                                .copyWith(fontSize: 18, color: primaryColor,fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormWidget(
                  controller: _emailController,
                  hintText: "Enter your email",
                  prefixIcon: Icons.email,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormWidget(
                  controller: _usernameController,
                  hintText: "Enter your username",
                  prefixIcon: Icons.person,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormWidget(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  prefixIcon: Icons.security,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormWidget(
                  controller: _bioController,
                  hintText: "Enter your bio",
                  prefixIcon: Icons.closed_caption,
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () {
                    if (isValidData(mainContext)) {
                      context.read<AuthBloc>().add(AuthRegisterEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          bio: _bioController.text));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: blueColor,
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.roboto().copyWith(
                          fontSize: 18,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text("Already have an account? ",
                          style: GoogleFonts.roboto().copyWith(
                              fontSize: 18,
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.login,
                          (route) => route.settings.name == Routes.login,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Sign in",
                          style: GoogleFonts.roboto().copyWith(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.normal),
                        ),
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
                        Navigator.pushNamed(mainContext, Routes.main);
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
      ),
    );
  }

  bool isValidData(BuildContext context) {
    String error = "";

    if (_emailController.text.isEmpty) {
      error = "please enter email";
    } else if (_usernameController.text.isEmpty) {
      error = "please enter username";
    } else if (_passwordController.text.isEmpty) {
      error = "please enter password";
    } else if (_bioController.text.isEmpty) {
      error = "please enter bio";
    }

    if (error.isNotEmpty) {
      showSnackBar(error, context, Colors.red);
      return false;
    } else {
      return true;
    }
  }
}
