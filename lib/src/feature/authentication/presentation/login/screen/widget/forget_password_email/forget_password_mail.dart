

import 'package:flutter/material.dart';
import 'package:vortex/src/core/constants/image_strings.dart';
import 'package:vortex/src/core/constants/size.dart';

import '../../login_header_widget.dart';

class ForgetPasswordMail extends StatelessWidget {
  const ForgetPasswordMail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              SizedBox(height: tDefaultSize * 3,),
              FormHeaderWidget(
                title: "Forget Password",
                subtitle: "Enter your email to get verification code",
                image: tWelcomeLogo,
                heightBetween: 30,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              SizedBox(height: tDefaultSize,),
              Form(
                  child:
                  Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                            label: Text("Email"),
                            hintText: "Email",
                            border: OutlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 40,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: (){},
                            child: Text("Send", style: TextStyle(color:
                            Colors.black, fontWeight: FontWeight.bold)
                              ,)),
                      )
                    ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
