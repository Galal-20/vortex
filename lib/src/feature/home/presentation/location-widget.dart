
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.locationText,
  });

  final String locationText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on_sharp, size: 19,),
        SizedBox(width: 2),
        Text("$locationText",
            style: TextStyle(fontSize: 14, color: Colors
                .blue)),
        SizedBox(width: 10),
      ],
    );
  }
}