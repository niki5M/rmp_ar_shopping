import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testik2/core/utils/show_snackbar.dart';
import 'package:testik2/features/auth/presentation/bloc/auth_state.dart';
import 'package:testik2/features/auth/presentation/pages/login_page.dart';
import 'package:testik2/features/auth/presentation/widgets/auth_button.dart';
import 'package:testik2/features/auth/presentation/widgets/auth_field.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/screens/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static route() => MaterialPageRoute(
      builder: (context) => SignUpPage());

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                } else if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }
                return Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Регистрация',
                        style: TextStyle(
                            color: Palete.lightPrimaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 70),
                      AuthField(hintText: "Name", controller: nameController),
                      const SizedBox(height: 20),
                      AuthField(
                          hintText: "Email", controller: emailController),
                      const SizedBox(height: 20),
                      AuthField(
                          hintText: "Password",
                          controller: passwordController,
                          isObscureText: true),
                      const SizedBox(height: 20),
                      AuthButton(
                        buttonText: 'Sign up',
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthSignUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim()));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, LoginPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Уже есть аккаунт? ",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Palete.blackColor),
                              children: [
                                TextSpan(
                                  text: 'Войти',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                      color: Palete.lightPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}