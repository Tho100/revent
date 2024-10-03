import 'package:flutter/material.dart';
import 'package:revent/model/create_new_item.dart';
import 'package:revent/widgets/main_button.dart';

class CreateVentPage extends StatelessWidget {

  CreateVentPage({super.key});

  final createItem = CreateNewItem();

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        MainButton(
          text: "Create vent", 
          onPressed: () async {
            await createItem.newVent(
              ventTitle: "My first vent", 
              ventBodyText: "Hello this is my first vent ever!"
            );
          }
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

}