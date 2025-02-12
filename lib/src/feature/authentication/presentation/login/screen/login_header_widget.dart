import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/image_strings.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.heightBetween,
    this.imageColor,
    this.imageHeight = 0.2
  });

  final String title, subtitle,image;
  final CrossAxisAlignment crossAxisAlignment;
  final Color?  imageColor;
  final double imageHeight;
  final double? heightBetween;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(image), height: size.height * imageHeight,),
        SizedBox(height: heightBetween,),
        Text(title, style: Theme.of(context).textTheme.headlineLarge,),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall,)
      ],
    );
  }
}


/*
*  Text("Welcome Back", style: Theme.of(context).textTheme.headlineLarge,),
        Text("Make it work, make it right, make it fast",*/