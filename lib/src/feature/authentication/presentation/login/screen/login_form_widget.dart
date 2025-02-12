import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vortex/src/core/constants/size.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/widget/forgetpassword/forget-password-modal_bottom_sheet.dart';

import '../../../../../core/constants/strings.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_outlined),
                    labelText: "Email",
                    hintText: "Email",
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.fingerprint),
                    labelText: "Password",
                    hintText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(onPressed: null,
                        icon: Icon(Icons.remove_red_eye))
                ),
              ),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(color: Colors.red),)
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(onPressed: (){},
                    child: Text(tLogin, style: TextStyle(color: Colors.black),)
                ),
              )
            ],
          ),
        ));
  }


}
