import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/current_provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/filter/comments_filter.dart';
import 'package:revent/pages/comment/post_comment_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent/active_vent_provider.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/comment/vent_comment_setup.dart';
import 'package:revent/vent_query/comment/vent_comments_settings.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/bottomsheet_widgets/comment_filter.dart';
import 'package:revent/widgets/bottomsheet_widgets/comment_settings.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';
import 'package:revent/widgets/vent_widgets/comments/vent_comments_listview.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class VentPostPage extends StatefulWidget {

  final String title;
  final String bodyText;
  final String postTimestamp;
  final String creator;
  final int totalLikes;
  final Uint8List pfpData;

  const VentPostPage({
    required this.title,
    required this.bodyText,
    required this.postTimestamp,
    required this.creator,
    required this.totalLikes,
    required this.pfpData,
    super.key
  });

  @override
  State<VentPostPage> createState() => VentPostPageState();

}

class VentPostPageState extends State<VentPostPage> {

  final ventCommentProvider = GetIt.instance<VentCommentProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();
  final userData = GetIt.instance<UserDataProvider>();
  final navigation = GetIt.instance<NavigationProvider>();
  final activeVent = GetIt.instance<ActiveVentProvider>();
  
  final enableCommentNotifier = ValueNotifier<bool>(true);
  final filterTextNotifier = ValueNotifier<String>('Best');

  final commentSettings = VentCommentsSettings();
  final commentsFilter = CommentsFilter();

  Future<void> _loadCommentsSettings() async {

    final currentOptions = await commentSettings.getCurrentOptions(
      title: widget.title, creator: widget.creator
    );

    enableCommentNotifier.value = currentOptions['comment_enabled'] == 1;

  }

  Future<void> _toggleCommentsOnPressed() async {

    enableCommentNotifier.value 
      ? commentSettings.toggleComment(isEnableComment: 1, title: widget.title)
      : commentSettings.toggleComment(isEnableComment: 0, title: widget.title);

    if(enableCommentNotifier.value == false) {
      ventCommentProvider.deleteComments();
    }

  }

  void _filterOnPressed({required String filter}) {
    
    switch (filter) {
      case == 'Best':
      commentsFilter.filterCommentToBest();
      break;
    case == 'Latest':
      commentsFilter.filterCommentToLatest();
      break;
    case == 'Oldest':
      commentsFilter.filterCommentToOldest();
      break;
    }

    filterTextNotifier.value = filter;

    Navigator.pop(context);

  }

  void _initializeComments() async {

    try {

      if(enableCommentNotifier.value == false) {
        return;
      }

      await VentCommentSetup().setup(
        title: widget.title, creator: widget.creator
      );

      commentsFilter.filterCommentToBest();

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
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

      if(enableCommentNotifier.value == false) {
        return;
      }

      await CallRefresh().refreshVentPost(
        title: widget.title, 
        creator: widget.creator, 
      ).then((_) {
        commentsFilter.filterCommentToBest();
        filterTextNotifier.value = 'Best';
      });

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }

  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProvider(
      title: widget.title, creator: widget.creator
    ).getRealTimeProvider(context: context);

    return currentProvider;

  }

  Map<String, dynamic> _getLikesInfo() {

    final currentProvider = _getVentProvider();

    final ventIndex = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    dynamic totalLikes, isVentLiked;

    if(AppRoute.isOnProfile) {

      final isMyProfile = navigation.currentRoute == AppRoute.myProfile;

      totalLikes = isMyProfile
        ? ventData.myProfile.totalLikes[ventIndex].toString()
        : ventData.userProfile.totalLikes[ventIndex].toString();

      isVentLiked = isMyProfile
        ? ventData.myProfile.isPostLiked[ventIndex]
        : ventData.userProfile.isPostLiked[ventIndex];

    } else {
    
      totalLikes = ventData.vents[ventIndex].totalLikes.toString();
      isVentLiked = ventData.vents[ventIndex].isPostLiked;

    }

    return {
      'total_likes': totalLikes,
      'is_liked': isVentLiked
    };

  }

  bool _isVentSaved() {

    final currentProvider = _getVentProvider();

    final ventIndex = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    if(AppRoute.isOnProfile) {

      final isMyProfile = navigation.currentRoute == AppRoute.myProfile;

      return isMyProfile 
        ? ventData.myProfile.isPostSaved[ventIndex]
        : ventData.userProfile.isPostSaved[ventIndex];

    } else {

      return ventData.vents[ventIndex].isPostSaved;
      
    }

  }

  Widget _buildFilterButton() {
    return SizedBox(
      width: 96,
      height: 35,
      child: InkWellEffect(
        onPressed: () {
          BottomsheetCommentFilter().buildBottomsheet(
            context: context, 
            currentFilter: filterTextNotifier.value,
            bestOnPressed: () => _filterOnPressed(filter: 'Best'), 
            latestOnPressed: () => _filterOnPressed(filter: 'Latest'),
            oldestOnPressed: () => _filterOnPressed(filter: 'Oldest'),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
    
            const SizedBox(width: 10),
  
            const Icon(CupertinoIcons.chevron_down, color: ThemeColor.thirdWhite, size: 18),
    
            const SizedBox(width: 8),
    
            ValueListenableBuilder(
              valueListenable: filterTextNotifier,
              builder: (_, filterText, __) {
                return Text(
                  filterText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.thirdWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 15
                  )
                );
              },
            ),
  
            const SizedBox(width: 8),
    
          ],
        ),
      ),
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
            widget.creator,
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

        Consumer<ActiveVentProvider>(
          builder: (_, data, __) {
            return SelectableText(
            data.body,
              style: GoogleFonts.inter(
                color: ThemeColor.secondaryWhite,
                fontWeight: FontWeight.w700,
                fontSize: 14
              ),
            );
          },
        ),

      ],
    );
  }

  Widget _buildVentOptionButton() {

    final ventPreviewer = VentPreviewerWidgets(
      context: navigatorKey.currentContext!,
      title: widget.title,
      bodyText: '',
      creator: widget.creator,
      editOnPressed: () {
        Navigator.pop(context);
        NavigatePage.editVentPage(title: widget.title, body: widget.bodyText);
      },
      copyOnPressed: () {
        Navigator.pop(context);
        _copyBodyText();
      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: 'Delete this post?', 
          buttonMessage: 'Delete',
          onPressedEvent: () async {
            await CallVentActions(
              context: context, 
              title: widget.title, 
              creator: widget.creator
            ).deletePost().then((value) => Navigator.pop(context));
          }
        );
      },
      blockOnPressed: () => Navigator.pop(context),
      reportOnPressed: () => Navigator.pop(context),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: ventPreviewer.buildVentOptionsButton(
        customIconWidget: const Icon(CupertinoIcons.ellipsis_circle, size: 25)
      ),
    );

  }

  Widget _buildLikeButton() {
    return Builder(
      builder: (context) {
        final likesInfo = _getLikesInfo();
        return ActionsButton().buildLikeButton(
          text: likesInfo['total_likes'], 
          isLiked: likesInfo['is_liked'],
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
    return Consumer<VentCommentProvider>(
      builder: (_, commentsData, __) {
        return ActionsButton().buildCommentsButton(
          text: commentsData.ventComments.length.toString(), 
          onPressed: () {}
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return Builder(
      builder: (context) {
        return ActionsButton().buildSaveButton(
          isSaved: _isVentSaved(),
          onPressed: () async {
            await CallVentActions(
              context: context, 
              title: widget.title, 
              creator: widget.creator
            ).savePost();
          }
        );
      },
    );
  }

  Widget _buildActionButtons() {
    
    final topPadding = widget.bodyText.isEmpty ? 0.0 : 25.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: [
          
          _buildLikeButton(),
          
          const SizedBox(width: 8),

          _buildCommentButton(),

          const Spacer(),

          _buildSaveButton()

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

        const SizedBox(height: 6),

        Row(
          children: [
            
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                'Comments',
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
      
            const Spacer(),
      
            _buildFilterButton(),
      
          ],
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
        
                    const SizedBox(height: 12),
        
                    _buildCommentsHeader(),
        
                    const SizedBox(height: 20),
        
                    ValueListenableBuilder(
                      valueListenable: enableCommentNotifier,
                      builder: (_, isEnabled, __) {
                        return VentCommentsListView(
                          title: widget.title, 
                          creator: widget.creator,
                          creatorPfpData: widget.pfpData,
                          isCommentEnabled: enableCommentNotifier.value,
                        );
                      },
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

  Widget _buildCommentSettingsButton() {
    return SizedBox(
      height: 45,
      width: 45,
      child: ElevatedButton(
        onPressed: () {
          BottomsheetCommentsSettings().buildBottomsheet(
            context: context, 
            notifier: enableCommentNotifier, 
            onToggled: () async => await _toggleCommentsOnPressed(), 
            text: 'Enable comment'
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.thirdWhite,
          backgroundColor: ThemeColor.black,
          side: const BorderSide(
            color: ThemeColor.thirdWhite,
            width: 1.5
          ),
          shape: const StadiumBorder(),
        ),
        child: Transform.translate(
          offset: const Offset(-3, -2),
          child: const Icon(CupertinoIcons.gear, color: ThemeColor.thirdWhite)
        )
      ),
    );
  }

  Widget _buildAddComment() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
      child: Row(
        children: [
          Expanded(
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
          ),

          if(userData.user.username == widget.creator) ... [

            const SizedBox(width: 12),

            _buildCommentSettingsButton()

          ]

        ],
      ),
    );
  }

  @override
  void initState() {
    _loadCommentsSettings().then((_) {
      _initializeComments();
      activeVent.setBody(widget.bodyText);
    });
    super.initState();
  }

  @override
  void dispose() {
    ventCommentProvider.deleteComments();
    activeVent.clearData();
    filterTextNotifier.dispose();
    enableCommentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Vent',
        actions: [_buildVentOptionButton()]
      ).buildAppBar(),
      body: _buildBody(),  
      bottomNavigationBar: _buildAddComment(),
    );
  }

}