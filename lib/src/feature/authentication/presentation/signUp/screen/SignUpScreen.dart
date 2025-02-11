
import 'package:flutter/material.dart';
import 'package:vortex/src/core/constants/strings.dart';
import 'package:vortex/src/feature/authentication/presentation/signUp/screen/signup-footer-widget.dart';

import '../../../../../core/constants/image_strings.dart';
import '../../../../../core/constants/size.dart';
import 'header-signup-widget.dart';
import 'signup-form-widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              HeaderSignUpWidget(size: size),
              SignUpFormWidget(),
              SignUpFooterWidget()
            ],
          ),
        ),
      ),
    );
  }
}

