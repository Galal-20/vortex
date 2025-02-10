
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        const Text("Or"),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
              icon: Image(image: AssetImage(tGoogleLogo), width: 20.0,),
              onPressed: (){},
              label: Text("Sign-in with Google")),
        ),
        const SizedBox(height: 20,),
        TextButton(
            onPressed: (){},
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
