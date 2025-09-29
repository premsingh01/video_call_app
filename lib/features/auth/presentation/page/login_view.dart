import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:video_call_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:video_call_app/features/auth/domain/usecase/auth_usecase.dart';
import 'package:video_call_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:video_call_app/features/auth/presentation/bloc/auth_state.dart';

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
      create: (_) => AuthCubit(authUsecase: AuthUsecase(authRepository: AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasourceImpl()))),
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
                  throw UnimplementedError();
                case AuthLoadingState():
                  // TODO: Handle this case.
                  throw UnimplementedError();
                case AuthSuccessState():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("AUTHENTICATION SUCCESS")),
                );
                //  Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (_) => const VideoCallScreen()),
                // );
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
                      autovalidateMode: AutovalidateMode.always,
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
