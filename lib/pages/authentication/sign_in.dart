import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/header_text.dart';
import 'package:revent/widgets/main_button.dart';
import 'package:revent/widgets/text_field/auth_textfield.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class SignInPage extends StatefulWidget {

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();

}

class SignInPageState extends State<SignInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final visiblePasswordNotifier = ValueNotifier<bool>(false);

  Widget _buildBody(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.05,
        vertical: mediaQuery.size.height * 0.05,
      ),
      child: Column(
        children: [
  
          const Padding(
            padding: EdgeInsets.only(left: 4.0, top: 22.0),
            child: HeaderText(
              title: "Sign Up", 
              subTitle: "Sign in to your account"
            ),
          ),
          
          const SizedBox(height: 30),

          MainTextField(
            hintText: "Enter your email address", 
            controller: emailController
          ),

          const SizedBox(height: 15),

          AuthTextField().passwordTextField(
            hintText: "Enter a password",
            controller: passwordController, 
            visibility: visiblePasswordNotifier
          ),

          const SizedBox(height: 30),

          MainButton(
            text: "Sign In",
            onPressed:  () {
              //
            },
          ),

          const Spacer(),

          SizedBox(
            height: 35,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.black,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      //
                    },
                    child: Text(
                      "Forgot your password?",
                      style: GoogleFonts.inter(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
    
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    visiblePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }

}