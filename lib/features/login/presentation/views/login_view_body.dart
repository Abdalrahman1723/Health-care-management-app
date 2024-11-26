import 'package:ecomerce_ieee/core/utils/app_string.dart';
import 'package:ecomerce_ieee/core/utils/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../../core/global/custom_text_filed/custom_text_field.dart';

class LoginViewBody extends StatelessWidget {
  LoginViewBody({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
           Center(child: SvgPicture.asset("lib/core/assets/images/route.svg")),
            SizedBox(height: 50,),
            Text(AppString.welcomeRoute, style: AppStyle.style24),
            Text(AppString.signEmail, style: AppStyle.style16),
            SizedBox(height: 40,),
            Text(AppString.userName, style: AppStyle.style18),
            SizedBox(height: 20,),
            CustomTextField(
              controller: _emailController,
              formKey: _formKey,
              label: 'Enter your email',
              isEmail: true,
            ),
            const SizedBox(height: 30),
            Text(AppString.password, style: AppStyle.style18),

            SizedBox(height: 20,),
            CustomTextField(
              controller: _passwordController,
              formKey: _formKey,
              label: 'Enter your password',
              isPassword: true, 
            ),

            SizedBox(height: 10,),
            Align(child: Text(AppString.forgetPassword,style: AppStyle.style16,),alignment: Alignment.centerRight,),

            SizedBox(height: 50,),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging in...')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // تقويس الزر
                  ),
                ),
                child: Text(
                  'Login',
                  style: AppStyle.style20
                ),
              ),
            ),


            SizedBox(height: 10,),
            Center(child: Text("Don't have an account? Create Acount",style: AppStyle.style18,))
          ],
        ),
      ),
    );
  }
}

