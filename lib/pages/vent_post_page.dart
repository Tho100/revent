import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/post_comment_page.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_post_actions.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPostPage extends StatefulWidget {

  final String title;
  final String bodyText;
  final String postTimestamp;
  final String creator;
  final int totalLikes;
  final int totalComments;
  final Uint8List pfpData;

  const VentPostPage({
    required this.title,
    required this.bodyText,
    required this.postTimestamp,
    required this.creator,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    super.key
  });

  @override
  State<VentPostPage> createState() => VentPostPageState();

}

class VentPostPageState extends State<VentPostPage> {

  void _copyBodyText() {

    if(widget.bodyText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.bodyText));
      SnackBarDialog.temporarySnack(message: 'Copied body text.');

    } else {
      SnackBarDialog.temporarySnack(message: 'Nothing to copy...');

    }

  }

  Future<void> _deletePostOnPressed() async {

    await CallVentActions(
      context: context, 
      title: widget.title, 
      creator: widget.creator
    ).deletePost();

    if(context.mounted) {
      Navigator.pop(context);
    }

  }

  Widget _buildLikeButton() {
    return Consumer<VentDataProvider>(
      builder: (_, ventData, __) {
        final index = ventData.vents.indexWhere(
          (vent) => vent.title == widget.title && vent.creator == widget.creator
        );
        return ActionsButton().buildLikeButton(
          text: ventData.vents[index].totalLikes.toString(), 
          isLiked: ventData.vents[index].isPostLiked,
          onPressed: () async { 
            await CallVentActions(
              context: context, 
              title: widget.title, 
              creator: widget.creator
            ).likePost();
          }
        );
      },
    );
  }

  Widget _buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      text: widget.totalComments.toString(), 
      onPressed: () => print('Commented')
    );
  }

  Widget _buildProfilePicture() {
    return ProfilePictureWidget(
      customHeight: 35,
      customWidth: 35,
      pfpData: widget.pfpData,
    );
  }

  Widget _buildProfileHeader() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: widget.creator, pfpData: widget.pfpData),
      child: Row(
        children: [
    
          _buildProfilePicture(),
    
          const SizedBox(width: 10),
    
          Text(
            '@${widget.creator}',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14.5
            ),
          ),
    
          Text(
            '  •  ${widget.postTimestamp}',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14.5
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SelectableText(
          widget.title,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 21
          ),
        ),
        
        const SizedBox(height: 14),

        SelectableText(
          widget.bodyText,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w700,
            fontSize: 14
          ),
        ),

      ],
    );
  }

  Widget _buildActions() {
    return IconButton(
      icon: const Icon(CupertinoIcons.ellipsis_vertical, size: 22),
      onPressed: () => BottomsheetVentPostActions().buildBottomsheet(
        context: context, 
        creator: widget.creator,
        saveOnPressed: () {
          Navigator.pop(context);
        },
        copyOnPressed: () {
          _copyBodyText();
          Navigator.pop(context);
        },
        reportOnPressed: () {
          Navigator.pop(context);
        }, 
        blockOnPressed: () {
          Navigator.pop(context);
        },
        deleteOnPressed: () {
          CustomAlertDialog.alertDialogCustomOnPress(
            message: 'Delete this post?', 
            buttonMessage: 'Delete',
            onPressedEvent: () async => _deletePostOnPressed()
          );
        }
      )
    );
  }

  Widget _buildActionButtons() {

    final topPadding = widget.bodyText.isEmpty ? 0.0 : 30.0;
    
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: [
          
          _buildLikeButton(),
          
          const SizedBox(width: 8),

          _buildCommentButton(),

        ],
      ),
    );
    
  }

  Widget _buildCommentsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Divider(color: ThemeColor.darkWhite),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'Comments',
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              _buildProfileHeader(),

              const SizedBox(height: 18),

              _buildHeader(),

              _buildActionButtons(),

              const SizedBox(height: 20),

              _buildCommentsHeader(),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Vent',
        actions: [_buildActions()]
      ).buildAppBar(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
        child: FloatingActionButton(
          backgroundColor: ThemeColor.white,
          child: const Icon(CupertinoIcons.chat_bubble, color: ThemeColor.mediumBlack),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostCommentPage(title: widget.title))
            );
          }
        ),
      ),
      body: _buildBody(),  
    );
  }

}