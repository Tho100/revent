import 'package:flutter/material.dart';
import 'package:revent/widgets/main_button.dart';

class MainScreenPage extends StatelessWidget {

  const MainScreenPage({super.key});

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: MainButton(
            text: 'Sign in', 
            onPressed: () { 
              print("Hi"); 
            }
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

}