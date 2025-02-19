
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vortex/src/feature/authentication/presentation/signUp/screen/SignUpScreen.dart';

import '../../../../../core/constants/image_strings.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Or",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
              icon: Image(
                image: AssetImage(tGoogleLogo), width: 25.0,),
              onPressed: (){},
              label: Text("Sign-in with Google",
                style: TextStyle(color: Colors.black),)),
        ),
        const SizedBox(height: 20,),
        TextButton(
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignUpScreen()),
                    (route) => false,
              );
            },
            child: Text.rich(
                TextSpan(
                    text: "Don't have an Account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: const[
                      TextSpan(
                          text: "Sign-Up",
                          style: TextStyle(color: Colors.blueAccent)
                      )
                    ]
                )
            )
        ),

      ],
    );
  }
}
