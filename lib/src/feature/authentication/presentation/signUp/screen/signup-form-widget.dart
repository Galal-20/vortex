import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthBloc.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthEvent.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthState.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/LoginScreen.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String fullName =" ", email =" ", phone =" ", password =" " ;
  bool isLoading = false;

  
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
        listener: (context, state){
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );
          }
          else if (state is AuthError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          else if (state is Authenticated) {
            context.read<AuthBloc>().emit(AuthInitial());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                  child:
                  AlertDialog(
                    title: Text("Congratulation", style: TextStyle(color: Colors
                        .black),),
                    content: Text("Sign Up successfully, Let's go to login."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Loginscreen()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: Text("Login"),
                      ),
                    ],
                  )
              ),
            );
          }

        },
      child: Form(
        key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (value) =>fullName = value,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                      labelText: "Full Name ",
                      hintText: "Full Name",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: "E-mail",
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  onChanged: (value) => phone = value,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.numbers_outlined),
                      labelText: "Phone Number ",
                      hintText: "Phone Number",
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  onChanged: (value) => password = value,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      labelText: "Password",
                      hintText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(onPressed: null,
                          icon: Icon(Icons.remove_red_eye))
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          SignUpRequested(
                            fullName: fullName,
                            email: email,
                            phone: phone,
                            password: password,
                          ),
                        );
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign Up", style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

