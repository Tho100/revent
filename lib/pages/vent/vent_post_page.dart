import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/helper/text_copy.dart';
import 'package:revent/pages/search_results_page.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/refresh_service.dart';
import 'package:revent/service/vent_actions_handler.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/filter/comments_filter.dart';
import 'package:revent/pages/comment/post_comment_page.dart';
import 'package:revent/service/query/vent/last_edit_getter.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/bottom_input_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/report_post_bottomsheet.dart';
import 'package:revent/shared/widgets/nsfw_widget.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/model/setup/comments_setup.dart';
import 'package:revent/service/query/vent/comment/comment_settings.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/comments/comment_filter.dart';
import 'package:revent/shared/widgets/bottomsheet/comments/comment_settings.dart';
import 'package:revent/shared/widgets/buttons/actions_button.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/comments_listview.dart';
import 'package:revent/shared/widgets/vent_widgets/vent_previewer_widgets.dart';

class VentPostPage extends StatefulWidget {

  final int postId;
  final String title;
  final String bodyText;
  final String tags;
  final String postTimestamp;
  final String creator;
  final bool isNsfw;
  final int totalLikes;
  final Uint8List pfpData;

  const VentPostPage({
    required this.postId,
    required this.title,
    required this.bodyText,
    required this.tags,
    required this.postTimestamp,
    required this.creator,
    required this.isNsfw,
    required this.totalLikes,
    required this.pfpData,
    super.key
  });

  @override
  State<VentPostPage> createState() => _VentPostPageState();

}

class _VentPostPageState extends State<VentPostPage> with 
  UserProfileProviderService,
  NavigationProviderService, 
  VentProviderService, 
  CommentsProviderService {

  final enableCommentNotifier = ValueNotifier<bool>(true);
  final filterTextNotifier = ValueNotifier<String>('Best');

  final commentSettings = CommentSettings();
  final commentsFilter = CommentsFilter();

  late VentActionsHandler actionsHandler;

  void _loadVentInfo() {

    activeVentProvider.setVentData(
      ActiveVentData(
        postId: widget.postId,
        title: widget.title, 
        creator: widget.creator, 
        body: widget.bodyText,
        creatorPfp: widget.pfpData
      )
    );

    _initializeVentActionsHandler();

    _loadCommentsSettings()
      .then((_) => _initializeComments())
      .then((_) => _loadLastEdit());

  }

  void _showNsfwConfirmationDialog() async {

    if (widget.isNsfw) {

      final isViewPost = await CustomAlertDialog.nsfwWarningDialog();

      if (isViewPost) {
        _loadVentInfo();
      } 

      return;

    }

    _loadVentInfo();

  }


  void _initializeVentActionsHandler() {
    actionsHandler = VentActionsHandler(              
      title: widget.title, 
      creator: widget.creator, 
      context: context
    );
  }

  Future<void> _loadLastEdit() async {
    await LastEditGetter().getLastEdit().then(
      (lastEdit) => activeVentProvider.setLastEdit(lastEdit)
    );
  }

  Future<void> _initializeComments() async {

    try {

      if (!enableCommentNotifier.value) {
        return;
      }

      await CommentsSetup().setup().then(
        (_) => commentsFilter.filterCommentToBest()
      );

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Comments not loaded.');
    }

  }

  Future<void> _loadCommentsSettings() async {

    final currentOptions = await commentSettings.getCurrentOptions();

    enableCommentNotifier.value = currentOptions['comment_enabled'] == 1;

  }

  Future<void> _onToggleCommentsPressed() async {

    enableCommentNotifier.value 
      ? commentSettings.toggleComment(isEnableComment: 1)
      : commentSettings.toggleComment(isEnableComment: 0);

    if (!enableCommentNotifier.value) {
      commentsProvider.deleteComments();
    }

  }

  void _onFilterPressed({required String filter}) {
    
    switch (filter) {
      case 'Best':
        commentsFilter.filterCommentToBest();
        break;
      case 'Latest':
        commentsFilter.filterCommentToLatest();
        break;
      case 'Oldest':
        commentsFilter.filterCommentToOldest();
        break;
    }

    filterTextNotifier.value = filter;

    Navigator.pop(context);

  }

  void _copyBodyText() async {

    if (widget.bodyText.isEmpty) {
      SnackBarDialog.temporarySnack(message: 'Nothing to copy.');
      return;
    }

    TextCopy(text: widget.bodyText).copy().then(
      (_) => SnackBarDialog.temporarySnack(message: AlertMessages.textCopied)
    );

  }

  Future<void> _onPageRefresh() async {

    try {

      if (!enableCommentNotifier.value) {
        return;
      }

      await RefreshService().refreshVentPost().then(
        (_) => commentsFilter.filterCommentToBest()
      );
      
      filterTextNotifier.value = 'Best';

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProviderService(
      title: widget.title, creator: widget.creator
    ).getRealTimeProvider(context: context);

    return currentProvider;

  }

  Map<String, dynamic> _getLikesInfo() {

    final currentProvider = _getVentProvider();

    final ventIndex = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    dynamic totalLikes, isVentLiked;

    if (RouteHelper.isOnProfile) {

      final isMyProfile = navigationProvider.currentRoute == AppRoute.myProfile.path;

      totalLikes = isMyProfile
        ? ventData.myProfile.totalLikes[ventIndex]
        : ventData.userProfile.totalLikes[ventIndex];

      isVentLiked = isMyProfile
        ? ventData.myProfile.isPostLiked[ventIndex]
        : ventData.userProfile.isPostLiked[ventIndex];

    } else {
    
      totalLikes = ventData.vents[ventIndex].totalLikes;
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

    if (RouteHelper.isOnProfile) {

      final isMyProfile = navigationProvider.currentRoute == AppRoute.myProfile.path;

      return isMyProfile 
        ? ventData.myProfile.isPostSaved[ventIndex]
        : ventData.userProfile.isPostSaved[ventIndex];

    } else {

      return ventData.vents[ventIndex].isPostSaved;
      
    }

  }

  Widget _buildLastEdit() {
    return Consumer<ActiveVentProvider>(
      builder: (_, data, __) {

        final lastEdit = data.ventData.lastEdit;

        if (lastEdit != '') {
          return GestureDetector(
            onTap: () => SnackBarDialog.temporarySnack(
              message: 'Post was edited ${lastEdit == 'Just now' ? 'just now' : '$lastEdit ago'}.'
            ),
            child: Row(
              children: [
          
                Icon(CupertinoIcons.pencil_outline, size: 15.5, color: ThemeColor.contentThird),
                
                const SizedBox(width: 6),
          
                Text(
                  '${lastEdit == 'Just now' ? 'Just now' : '$lastEdit ago'} ',
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentThird,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.2
                  )
                ),
          
              ],
            ),
          );
        }

        return const SizedBox.shrink();

      },
    );
  }

  Widget _buildPostHeaderInfo() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: widget.creator, pfpData: widget.pfpData),
      child: Row(
        children: [
    
          ProfilePictureWidget(
            customHeight: 35,
            customWidth: 35,
            customEmptyPfpSize: 20,
            pfpData: widget.pfpData
          ),
    
          const SizedBox(width: 10),
    
          Text(
            widget.creator,
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13.5
            ),
          ),

          const SizedBox(width: 8),
        
          Text(
            widget.postTimestamp,
            style: GoogleFonts.inter(
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.w800,
              fontSize: 12.5
            ),
          ),

          const Spacer(),

          _buildLastEdit()

        ],
      ),
    );
  }

  Widget _buildTags() {

    final tagList = widget.tags.split(' ');

    return Wrap(
      spacing: 5,
      children: tagList.map((tag) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchResultsPage(searchText: "#$tag"),
              ),
            );
          },
          child: Text(
            '#$tag',
            style: ThemeStyle.ventPostPageTagsStyle,
          ),
        );
      }).toList(),
    );

  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (widget.isNsfw)
        const NsfwWidget(),

        SelectableText(
          widget.title,
          style: ThemeStyle.ventPostPageTitleStyle
        ),

        if (widget.tags.isNotEmpty) ... [

          const SizedBox(height: 8),

          _buildTags(),

          const SizedBox(height: 12),

        ],
        
        const SizedBox(height: 10),

        Consumer<ActiveVentProvider>(
          builder: (_, data, __) {
            return StyledTextWidget(
              text: data.ventData.body,
              isSelectable: true,
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
      creator: widget.creator,
      editOnPressed: () {
        Navigator.pop(context);
        NavigatePage.editVentPage(
          title: widget.title, 
          body: activeVentProvider.ventData.body
        );
      },
      copyOnPressed: () {
        Navigator.pop(context);
        _copyBodyText();
      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: AlertMessages.deletePost, 
          buttonMessage: 'Delete',
          onPressedEvent: () async {
            await actionsHandler.deletePost().then(
              (_) => Navigator.pop(context)
            );
          }
        );
      },
      blockOnPressed: () {
        Navigator.pop(context);
        CustomAlertDialog.alertDialogCustomOnPress(
          message: 'Block @${widget.creator}?', 
          buttonMessage: 'Block', 
          onPressedEvent: () async {
            await UserActions(username: widget.creator).blockUser()
              .then((_) => Navigator.pop(context))
              .then((_) => Navigator.pop(context));
          }
        );
      },
      reportOnPressed: () {
        Navigator.pop(context);
        ReportPostBottomsheet().buildBottomsheet(context: context);
      }
    );

    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: ventPreviewer.buildVentOptionsButton(
        customIconWidget: Icon(CupertinoIcons.ellipsis_circle, size: 25, color: ThemeColor.contentPrimary)
      ),
    );

  }

  Widget _buildLikeButton() {
    return Builder(
      builder: (context) {
        final likesInfo = _getLikesInfo();
        return ActionsButton().buildLikeButton(
          value: likesInfo['total_likes'], 
          isLiked: likesInfo['is_liked'],
          onPressed: () async => await actionsHandler.likePost()
        );
      },
    );
  }

  Widget _buildCommentButton() {
    return Consumer<CommentsProvider>(
      builder: (_, commentsData, __) {
        return ActionsButton().buildCommentsButton(
          value: commentsData.comments.length
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return Builder(
      builder: (context) {
        final isSaved = _isVentSaved();
        return ActionsButton().buildSaveButton(
          isSaved: isSaved,
          onPressed: () async => actionsHandler.savePost(isSaved)
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

  Widget _buildCommentFilterButton() {
    return SizedBox(
      height: 35,
      child: InkWellEffect(
        onPressed: () {
          BottomsheetCommentFilter().buildBottomsheet(
            context: context, 
            currentFilter: filterTextNotifier.value,
            bestOnPressed: () => _onFilterPressed(filter: 'Best'), 
            latestOnPressed: () => _onFilterPressed(filter: 'Latest'),
            oldestOnPressed: () => _onFilterPressed(filter: 'Oldest'),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
    
            const SizedBox(width: 8),
    
            ValueListenableBuilder(
              valueListenable: filterTextNotifier,
              builder: (_, filterText, __) {
                return Text(
                  filterText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                  )
                );
              },
            ),

            const SizedBox(width: 8),

            Icon(CupertinoIcons.chevron_down, color: ThemeColor.contentPrimary, size: 16),

            const SizedBox(width: 8),
    
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsHeader(bool isCommentEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Divider(color: ThemeColor.divider),
        ),
  
        const SizedBox(height: 2),
  
        if (!isCommentEmpty)
        ValueListenableBuilder(
          valueListenable: enableCommentNotifier,
          builder: (_, isCommentEnabled, __) {
            return isCommentEnabled
              ? Row(
                children: [
                
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      'Comments',
                      style: GoogleFonts.inter(
                        color: ThemeColor.contentPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
            
                  const Spacer(),
            
                  _buildCommentFilterButton(),
            
                ],
              )
              : const SizedBox.shrink();
          }
        ),

        if (!isCommentEmpty)
        Column(
          children: [
            
            const SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Divider(color: ThemeColor.divider),
            ),

          ],
        ),
  
      ],
    );
  }

  Widget _buildCommentSectionListView() {
    return ValueListenableBuilder(
      valueListenable: enableCommentNotifier,
      builder: (_, isEnabled, __) {
        return CommentsListView(
          isCommentEnabled: enableCommentNotifier.value,
          isUserPost: widget.creator == userProvider.user.username
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
            onToggled: () async => await _onToggleCommentsPressed(), 
            text: 'Allow Commenting'
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: ThemeColor.contentThird,
          backgroundColor: ThemeColor.backgroundPrimary,
          side: BorderSide(
            color: ThemeColor.contentThird,
            width: 1.5
          ),
          shape: const StadiumBorder(),
        ),
        child: Transform.translate(
          offset: const Offset(-3, -1),
          child: Icon(CupertinoIcons.gear, color: ThemeColor.contentThird)
        )
      ),
    );
  }

  Widget _buildAddComment() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: enableCommentNotifier,
        builder: (_, isCommentEnabled, __) {
          return isCommentEnabled 
            ? BottomInputBar(
                hintText: 'Add a comment...', 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PostCommentPage()
                    )
                  );
                }
              )
            : const SizedBox.shrink();
        }
      ),
    );
  }

  Widget _buildBottomWidgets() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
      child: Row(
        children: [
    
          _buildAddComment(),
      
          if (userProvider.user.username == widget.creator) ... [
      
            const SizedBox(width: 12),
      
            _buildCommentSettingsButton()
      
          ]
      
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<CommentsProvider>(
      builder: (_, commentData, __) {
        return RefreshIndicator(      
          backgroundColor: ThemeColor.contentPrimary,
          color: ThemeColor.backgroundPrimary,
          onRefresh: () async => await _onPageRefresh(),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(
                parent: commentData.comments.isEmpty 
                  ? const ClampingScrollPhysics() : const BouncingScrollPhysics()
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 18.0, right: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              
                    _buildPostHeaderInfo(),
                      
                    const SizedBox(height: 16),
                      
                    _buildPostContent(),
                      
                    _buildActionButtons(),
                      
                    const SizedBox(height: 12),
                      
                    _buildCommentsHeader(commentData.comments.isEmpty),
                    
                    const SizedBox(height: 20),
                      
                    _buildCommentSectionListView(),
                      
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNsfwConfirmationDialog();
    });
  }

  @override
  void dispose() {
    commentsProvider.deleteComments();
    activeVentProvider.clearData();
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
      bottomNavigationBar: _buildBottomWidgets()
    );
  }

}