

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vortex/src/feature/authentication/presentation/login/screen/widget/forget_password_email/forget_password_mail.dart';

import '../../../../../../../core/constants/size.dart';
import 'forget-password-btn-widge.dart';

class ForgetPasswordScreen{

  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius:
        BorderRadius.circular(40.0)),
        builder: (context) => Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //title
              Text("Make Selection!", style: Theme.of(context).textTheme.headlineLarge,),
              // subtitle
              Text(
                "Select one of the options given below to reset password.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 30.0,),
              ForgetPasswordBtnWidget(
                btnIcon: Icons.mail_outline_rounded,
                title: "E-mail",
                subtitle: "Reset via mail Verification.",
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder:
                      (context) => ForgetPasswordMail()));
                },
              ),
              SizedBox(height: 20.0,),
              ForgetPasswordBtnWidget(
                btnIcon: Icons.mobile_friendly_rounded,
                title: "Phone",
                subtitle: "Reset via Phone Verification.",
                onTap: (){},
              ),
            ],
          ),
        )
    );
  }
}