import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/post_comment_page.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/vent_comment_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/comment/vent_comment_setup.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_post_actions.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';
import 'package:revent/widgets/vent_widgets/comments/vent_comments_listview.dart';

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

  final ventCommentProvider = GetIt.instance<VentCommentProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  void _initializeComments() async {

    try {

      await VentCommentSetup()
        .setup(title: widget.title, creator: widget.creator);

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong');
    }

  }

  void _copyBodyText() {

    if(widget.bodyText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: widget.bodyText));
      SnackBarDialog.temporarySnack(message: 'Copied body text.');

    } else {
      SnackBarDialog.temporarySnack(message: 'Nothing to copy...');

    }

  }

  Future<void> _onPageRefresh() async {

    try {

      await CallRefresh().refreshVentPost(
        title: widget.title, creator: widget.creator
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong');
    }

  }

  Future<void> _deletePostOnPressed() async {

    await CallVentActions(
      context: context, 
      title: widget.title, 
      creator: widget.creator
    ).deletePost().then((value) => Navigator.pop(context));
    
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
      onPressed: () => {}
    );
  }

  Widget _buildProfilePicture() {
    return ProfilePictureWidget(
      customHeight: 35,
      customWidth: 35,
      customEmptyPfpSize: 20,
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
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14.5
            ),
          ),

          const SizedBox(width: 8),
        
          Text(
            widget.postTimestamp,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14
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
      icon: const Icon(CupertinoIcons.ellipsis_circle, size: 25),
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
            onPressedEvent: () async => await _deletePostOnPressed()
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
          child: Divider(color: ThemeColor.lightGrey),
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
    return Consumer<VentCommentProvider>(
      builder: (_, commentData, __) {
        return RefreshIndicator(      
          color: ThemeColor.black,
          onRefresh: () async => await _onPageRefresh(),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 18.0, right: 18.0),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                  parent: commentData.ventComments.isEmpty 
                    ? const ClampingScrollPhysics() : const BouncingScrollPhysics()
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
                    _buildProfileHeader(),
        
                    const SizedBox(height: 18),
        
                    _buildHeader(),
        
                    _buildActionButtons(),
        
                    const SizedBox(height: 15),
        
                    _buildCommentsHeader(),
        
                    const SizedBox(height: 25),
        
                    VentCommentsListView(
                      title: widget.title, 
                      creator: widget.creator
                    ),
        
                    const SizedBox(height: 10),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddComment() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
      child: InkWellEffect(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostCommentPage(title: widget.title, creator: widget.creator))
          );
        },              
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ThemeColor.thirdWhite)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [

                  ProfilePictureWidget(
                    customHeight: 26,
                    customWidth: 26,
                    pfpData: profileData.profilePicture,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    'Add a comment...',
                    style: GoogleFonts.inter(
                      color: ThemeColor.thirdWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 14
                    ),
                  ),

                ],
              ),
            ),
          )
        )
      ),
    );
  }

  @override
  void initState() {
    _initializeComments();
    super.initState();
  }

  @override
  void dispose() {
    ventCommentProvider.deleteComments();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Vent',
        actions: [_buildActions()]
      ).buildAppBar(),
      body: _buildBody(),  
      bottomNavigationBar: _buildAddComment(),
    );
  }

}