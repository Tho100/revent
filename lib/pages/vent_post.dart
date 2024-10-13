import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/model/profile_picture_model.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPostPage extends StatefulWidget {

  final String title;
  final String bodyText;
  final String postTimestamp;

  const VentPostPage({
    required this.title,
    required this.bodyText,
    required this.postTimestamp,
    super.key
  });

  @override
  State<VentPostPage> createState() => VentPostPageState();

}

class VentPostPageState extends State<VentPostPage> {

  final userData = GetIt.instance<UserDataProvider>();

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 18),
        child: SizedBox(
          width: MediaQuery.of(context).size.width-45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              _buildProfileHeader(),

              const SizedBox(height: 16),

              _buildHeader(context),

            ] 
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture({required bool isFromCommunity}) {
    return FutureBuilder<ValueNotifier<Uint8List?>>(
    future: ProfilePictureModel().initializeProfilePic(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return ProfilePictureWidget(
            customHeight: isFromCommunity ? 40 : 35,
            customWidth: isFromCommunity ? 40 : 35,
            profileDataNotifier: snapshot.data!,
          );

        } else {
          return const CircularProgressIndicator(color: ThemeColor.white);

        }
      }
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        _buildProfilePicture(isFromCommunity: false),

        const SizedBox(width: 10),

        Text(userData.username,
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14.5
          ),
        ),

        Text(' (dot)  ${widget.postTimestamp}',
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14.5
          ),
        ),
      
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(widget.title,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 21
          ),
          maxLines: 2,
        ),

        const SizedBox(height: 20),

        Text(
          widget.bodyText,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 12
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _buildProfilePicture(isFromCommunity: true),

          const SizedBox(width: 12),
    
          Text('parenting-support',
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            )
          ),

        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          color: ThemeColor.thirdWhite,
          onPressed: () => print('Pressed')
        ),
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