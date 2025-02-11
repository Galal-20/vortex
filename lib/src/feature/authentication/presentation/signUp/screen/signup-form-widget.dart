import 'package:flutter/material.dart';

import '../../../../../core/constants/strings.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
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
                    labelText: "Full Name ",
                    hintText: "Full Name",
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.fingerprint),
                  labelText: "E-mail",
                  hintText: "Email",
                  border: OutlineInputBorder(),
                  /*suffixIcon: IconButton(onPressed: null,
                        icon: Icon(Icons.remove_red_eye))*/
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers_outlined),
                    labelText: "Phone Number ",
                    hintText: "Phone Number",
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
              SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: (){},
                    child: Text(tSignUp, style: TextStyle(color: Colors.black),)
                ),
              )
            ],
          ),
        ));
  }
}

