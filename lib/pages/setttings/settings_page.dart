import 'package:flutter/material.dart';
import 'package:revent/widgets/app_bar.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        context: context
      ).buildAppBar(),
    );
  }

}