import 'package:flutter/material.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/LoginScreen.dart';

import '../../../../../core/constants/image_strings.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
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
              label: Text("SIGN-IN WITH GOOGLE",
                style: TextStyle(color: Colors.black),)),
        ),
        const SizedBox(height: 20,),
        TextButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Loginscreen())
              );
            },
            child: Text.rich(
                TextSpan(
                    text: "Already have an Account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: const[
                      TextSpan(
                          text: "Login",
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

