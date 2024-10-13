import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/model/profile_picture_model.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPostPage extends StatefulWidget {

  const VentPostPage({super.key});

  @override
  State<VentPostPage> createState() => VentPostPageState();

}

class VentPostPageState extends State<VentPostPage> {

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-90,
      child: Column(
        children: [
          _buildHeader(context),
        ] 
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [

        Text('Needs advice on taking care of kids',
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 24
          ),
          maxLines: 2,
        ),

        Expanded(
          child: Text(
            'Yeah fuck it we balling arent we boys',
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 15.5
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: null
          ),
        ),

      ],
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
        leading: IconButton(
        icon: const Icon(CupertinoIcons.chevron_back, color: ThemeColor.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // TODO: Replace with community profile

          FutureBuilder<ValueNotifier<Uint8List?>>(
          future: ProfilePictureModel().initializeProfilePic(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return ProfilePictureWidget(
                  customHeight: 30,
                  customWidth: 30,
                  profileDataNotifier: snapshot.data!,
                );

              } else {
                return const CircularProgressIndicator(color: ThemeColor.white);

              }
            }
          ),
    
          Text('parenting-support',
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),

        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 12),
          child: IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical, size: 28),
            color: ThemeColor.thirdWhite,
            onPressed: () => print('Pressed')
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(context),
      body: _buildBody(context),
    );
  }

}