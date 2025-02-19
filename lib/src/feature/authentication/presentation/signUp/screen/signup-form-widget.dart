import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vortex/src/core/utils/validations.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthBloc.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthEvent.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthState.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/LoginScreen.dart';

import '../../text_form_field.dart';

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
  bool _isPasswordHidden = true;



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
                // full name
                TextFieldClass.buildTextFormField(
                  "Full Name",
                  "Full Name",
                    (value){
                      if(value == null || value.trim().isEmpty){
                        return "Full name is required";
                      } else if (value.trim().length < 3) {
                        return "Full Name must be at least 3 characters";
                      }
                      return null;
                    },
                      (value) => fullName = value,
                  Icon(Icons.person_outline_outlined),
                ),
                SizedBox(height: 20,),
                // Email
                TextFieldClass.buildTextFormField(
                  "Email",
                  "Enter your email",
                      (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    } else if (!Validation.isValidateEmail(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                    (value) => email = value,
                    Icon(Icons.mail_outline_rounded)
                ),
                SizedBox(height: 20,),
                // Phone Number
                TextFieldClass.buildTextFormField(
                    "Phone Number",
                    "Phone Number",
                        (value){
                      if (value == null || value.trim().isEmpty) {
                        return "Phone number is required";
                      } else if (!Validation.isValidPhone(value)) {
                        return "Enter a valid phone number (11 digits)";
                      }
                      return null;
                    },
                        (value) => phone = value,
                    Icon(Icons.phone)
                ),
                SizedBox(height: 20,),
                // password
                TextFieldClass.buildTextFormField(
                    "Password", 
                    "Password",
                        (value){
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else if (!Validation.isValidatePassword(value)) {
                            return "Password must contain uppercase, lowercase, number, and special character";
                          }
                          return null;
                    },
                        (value) => password = value,
                  Icon(Icons.fingerprint),
                  suffixIcon:
                  IconButton(
                      onPressed: ()
                      {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility)
                  ),
                  obscureText: _isPasswordHidden
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

