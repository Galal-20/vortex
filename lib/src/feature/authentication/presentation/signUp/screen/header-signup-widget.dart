import 'package:flutter/material.dart';
import 'package:vortex/src/core/constants/image_strings.dart';

class HeaderSignUpWidget extends StatelessWidget {
  const HeaderSignUpWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(tWelcomeLogo), height: size.height * 0.15,),
        SizedBox(height: 20,),
        Text("Get on board", style: Theme.of(context).textTheme
            .headlineLarge,),
        Text("Create your profile to start your journey",
          style: Theme.of(context).textTheme.bodySmall,)
      ],
    );
  }
}
