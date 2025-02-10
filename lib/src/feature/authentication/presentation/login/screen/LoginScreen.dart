import 'package:flutter/material.dart';
import 'package:vortex/src/core/constants/size.dart';

import 'login_footer_widget.dart';
import 'login_form_widget.dart';
import 'login_header_widget.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
         padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              LoginHeaderWidget(size: size),
              const LoginForm(),
              LoginFooterWidget()
            ],
          ),
        ),
      ),
    );
  }
}



