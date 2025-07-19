// ignore_for_file: library_private_types_in_public_api

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/vent_actions_handler.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/archive/view_archived_vent_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/archived_filter_bottomsheet.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/service/query/vent/last_edit_getter.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/archive/archive_vent_data_getter.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/vent_previewer_widgets.dart';

class _ArchivedVentsData {
  
  final String title;
  final String tags;
  final String postTimestamp;

  _ArchivedVentsData({
    required this.title,
    required this.tags,
    required this.postTimestamp
  });

}

class ArchivedVentPage extends StatefulWidget {

  const ArchivedVentPage({super.key});

  @override
  State<ArchivedVentPage> createState() => _ArchivedVentPageState();
  
}

class _ArchivedVentPageState extends State<ArchivedVentPage> with 
  UserProfileProviderService, 
  VentProviderService {

  final archiveDataGetter = ArchiveVentDataGetter();

  final isPageLoadedNotifier = ValueNotifier<bool>(false);
  final filterTextNotifier = ValueNotifier<String>('Latest');

  final searchArchiveController = TextEditingController();

  ValueNotifier<List<_ArchivedVentsData>> archivedVentsData = ValueNotifier([]);

  List<_ArchivedVentsData> _allArchivedVents = [];

  Future<String> _getBodyText(String title) async {

    return await archiveDataGetter.getBodyText(
      title: title, 
      creator: userProvider.user.username
    );

  } 

  Future<String> _getLastEdit(String title) async {

    activeVentProvider.setVentData(
      ActiveVentData(
        postId: 0,
        title: title, 
        creator: userProvider.user.username, 
        body: '',
        creatorPfp: profileProvider.profile.profilePicture
      )
    );

    return await LastEditGetter().getLastEditArchive();

  }

  void _navigateViewArchiveVentPage(String title, String tags, String postTimestamp) async {

    final bodyText = await _getBodyText(title);
    final lastEdit = await _getLastEdit(title);

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => ViewArchivedVentPage(
          title: title, 
          tags: tags,
          bodyText: bodyText, 
          lastEdit: lastEdit,
          postTimestamp: postTimestamp
        )
      ),
    );

  }

  Future<void> _loadArchiveVentsData() async {

    try {

      final archiveVentsInfo = await archiveDataGetter.getPosts(
        username: userProvider.user.username
      );

      final titles = archiveVentsInfo['title'] as List<String>;
      final tags = archiveVentsInfo['tags'] as List<String>;

      final postTimestamp = archiveVentsInfo['post_timestamp'] as List<String>;

      archivedVentsData.value = List.generate(titles.length, (index) {
        return _ArchivedVentsData(
          title: titles[index],
          tags: tags[index],
          postTimestamp: postTimestamp[index],
        );
      });

      _allArchivedVents = archivedVentsData.value;

      isPageLoadedNotifier.value = true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: 'Failed to load archives.');
    }

  }

  void _onDeleteArchive(String title) async {

    await VentActionsHandler(
      title: title, 
      creator: userProvider.user.username, 
      context: context
    ).deleteArchivedPost().then(
      (_) => _removeVentFromList(title)
    );

  } 

  void _removeVentFromList(String title) {
    archivedVentsData.value = archivedVentsData.value
      .where((vent) => vent.title != title)
      .toList();
  }

  void _sortArchivedVentsToOldest() {

    final sortedList = archivedVentsData.value
      .toList()
      ..sort((a, b) => FormatDate.parseFormattedTimestamp(b.postTimestamp)
        .compareTo(FormatDate.parseFormattedTimestamp(a.postTimestamp)));

    archivedVentsData.value = sortedList;

  }

  void _sortArchivedVentsToLatest() {

    final sortedList = archivedVentsData.value
      .toList()
      ..sort((a, b) => FormatDate.parseFormattedTimestamp(a.postTimestamp)
        .compareTo(FormatDate.parseFormattedTimestamp(b.postTimestamp)));

    archivedVentsData.value = sortedList;

  }

  void _onFilterPressed({required String filter}) { 
    
    switch (filter) {
      case 'Latest':
        _sortArchivedVentsToLatest();
        break;
      case 'Oldest':
        _sortArchivedVentsToOldest();
        break;
    }

    filterTextNotifier.value = filter;

    Navigator.pop(context);

  }

  void _searchArchive({required String searchText}) {

    final query = searchText.trim().toLowerCase();

    if (query.isNotEmpty) {
      
      final filteredList = _allArchivedVents.where((vent) {
        return vent.title.toLowerCase().contains(query);
      }).toList();

      if (filteredList.isNotEmpty) {
        archivedVentsData.value = filteredList;
      } 

    } else {

      archivedVentsData.value = List.from(_allArchivedVents);

    }

  }

  Widget _buildVentPreview(String title, String tags, String postTimestamp) {

    final ventPreviewer = VentPreviewerWidgets(
      context: context,
      title: title,
      tags: tags,
      creator: userProvider.user.username,
      pfpData: profileProvider.profile.profilePicture,
      postTimestamp: postTimestamp,
      navigateVentPostPageOnPressed: () => _navigateViewArchiveVentPage(title, tags, postTimestamp),
      editOnPressed: () async {

        Navigator.pop(navigatorKey.currentContext!);
        
        final bodyText = await _getBodyText(title);

        NavigatePage.editVentPage(
          title: title, body: bodyText, isArchive: true
        );

      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: AlertMessages.deletePost, 
          buttonMessage: 'Delete',
          onPressedEvent: () => _onDeleteArchive(title)
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: ventPreviewer.buildMainContainer(
        children: [
    
          Row(
            children: [
    
              ventPreviewer.buildHeaders(),
    
              const Spacer(),
    
              ventPreviewer.buildVentOptionsButton()
              
            ],
          ),

          const SizedBox(height: 8),
      
          ventPreviewer.buildTitle(),

          if (tags.isNotEmpty) ... [

            const SizedBox(height: 8),

            ventPreviewer.buildTags(),
            
          ],

          const SizedBox(height: 8),
    
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .92,
      height: 67,
      child: MainTextField(
        controller: searchArchiveController,
        hintText: 'Search archive...',
        onChange: (searchText) => _searchArchive(searchText: searchText)
      ),
    );
  }

  Widget _buildTotalPost(int postCounts) {

    final postText = postCounts == 1 
      ? "You have 1 archived post." 
      : "You have $postCounts archived posts.";

    return Text(
      postText,
      style: GoogleFonts.inter(
        color: ThemeColor.contentThird,
        fontWeight: FontWeight.w800,
        fontSize: 14
      )
    );

  }

  Widget _buildPostsFilterButton() {
    return SizedBox(
      height: 35,
      child: InkWellEffect(
        onPressed: () {
          BottomsheetArchivedFilter().buildBottomsheet(
            context: context, 
            currentFilter: filterTextNotifier.value,
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

  Widget _buildHeaderWidgets({required int postCounts}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10.0, top: 10, bottom: 5),
      child: Column(
        children: [

          _buildSearchBar(),

          const SizedBox(height: 10),

          Row(
            children: [
    
              Align(
                alignment: Alignment.topLeft,
                child: _buildTotalPost(postCounts),
              ),
    
              const Spacer(),
    
              _buildPostsFilterButton()
    
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildListView(List<_ArchivedVentsData> archiveData) {
    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      crossAxisCount: 1,
      itemCount: archiveData.length + 1,
      builder: (_, index) {
          
        if (index == 0) {
          return _buildHeaderWidgets(postCounts: archiveData.length);
        }

        final ventsData = archiveData[index - 1];

        return _buildVentPreview(ventsData.title, ventsData.tags, ventsData.postTimestamp);

      },
    );
  }
  
  Widget _buildVentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ValueListenableBuilder(
        valueListenable: isPageLoadedNotifier,
        builder: (_, isLoaded, __) {
          
          if (!isLoaded) {
            return const PageLoading();
          }

          return ValueListenableBuilder(
            valueListenable: archivedVentsData,
            builder: (_, archiveData, __) { 
              return archiveData.isEmpty 
                ? _buildNoArchivedPosts()
                : _buildListView(archiveData);
            },
          );
          
        },
      ),
    );
  }

  Widget _buildNoArchivedPosts() {
    return NoContentMessage().customMessage(
      message: 'Your archive is empty.'
    );
  }

  @override
  void initState() {
    super.initState();
    _loadArchiveVentsData();
  }

  @override
  void dispose() {
    archivedVentsData.dispose();
    isPageLoadedNotifier.dispose();
    filterTextNotifier.dispose();
    searchArchiveController.dispose();
    activeVentProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Archive'
      ).buildAppBar(),
      body: _buildVentList(),
    );
  }

}