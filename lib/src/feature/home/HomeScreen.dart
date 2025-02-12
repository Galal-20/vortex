import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/LoginScreen.dart';

import '../authentication/presentation/AuthBloc.dart';
import '../authentication/presentation/AuthEvent.dart';
import '../authentication/presentation/AuthState.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginscreen()),
            );
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome, ${state.displayName ?? "User"}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Email: ${state.email ?? "Not available"}",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      child: Text("Logout"),
                    ),
                  ],
                );
              } else if (state is AuthLoading) {
                return CircularProgressIndicator();
              } else if (state is AuthError) {
                return Text("Error: ${state.message}");
              }
              return Text("Not authenticated");
            },
          ),
        ),
      ),
    );
  }
}
