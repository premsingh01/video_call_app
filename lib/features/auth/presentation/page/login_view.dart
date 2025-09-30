import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:video_call_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:video_call_app/features/dashboard/presentation/page/dashboard_view.dart';
import 'package:video_call_app/service_locator.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>  sl<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              switch (state) {
                case AuthInitialState():
                  // TODO: Handle this case.
                  return;
                case AuthLoadingState():
                  // TODO: Handle this case.
                  return;
                case AuthSuccessState():
                 Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardView()),
                );
                case AuthFailureState():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: "test@example.com" ,
                        ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter email';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: "password123" ,
                        ),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      obscureText: true,
                      validator: (value) => (value == null || value.isEmpty) ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 24),
                    state is AuthLoadingState
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
