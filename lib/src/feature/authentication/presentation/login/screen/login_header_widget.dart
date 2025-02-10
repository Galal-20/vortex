import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/image_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(tWelcomeLogo), height: size.height * 0.2,),
        SizedBox(height: 20,),
        Text("Welcome Back", style: Theme.of(context).textTheme.headlineLarge,),
      ],
    );
  }
}