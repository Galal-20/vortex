import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthBloc.dart';
import 'package:vortex/src/feature/authentication/presentation/AuthState.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/widget/forgetpassword/forget-password-modal_bottom_sheet.dart';
import 'package:vortex/src/feature/home/HomeScreen.dart';

import '../../../../../core/constants/image_strings.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/utils/validations.dart';
import '../../AuthEvent.dart';
import '../../text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "", password = "";
  bool isLoading = false;
  bool _isPasswordHidden = true;

  void _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is Authenticated) {
          _saveAuthState();
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Homescreen()),
                (Route<dynamic> route) => false,
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
                  Icon(Icons.person_outline_outlined)
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
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: Text("Forget Password?", style: TextStyle(color: Colors.red)),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      //setState(() => isLoading = true);
                      context.read<AuthBloc>().add(LoginRequested(
                        email: email,
                        password: password,
                      ));
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.black)
                      : Text(tLogin, style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
