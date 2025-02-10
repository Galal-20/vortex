import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){},
                    child: Text("Forget Password?")
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){}, child: Text(tLogin)),
              )
            ],
          ),
        ));
  }
}
