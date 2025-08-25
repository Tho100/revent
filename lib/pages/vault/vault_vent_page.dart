// ignore_for_file: library_private_types_in_public_api

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/controllers/search_controller.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/global/vent_type.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/vent_actions_handler.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vault/vault_vent_viewer_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/vault_filter_bottomsheet.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/service/query/vent/last_edit_getter.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/vault/vault_vent_data_getter.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/vent_previewer_widgets.dart';

class _VaultVentsData {
  
  final String title;
  final String tags;
  final String postTimestamp;

  _VaultVentsData({
    required this.title,
    required this.tags,
    required this.postTimestamp
  });

}

class VaultVentPage extends StatefulWidget {

  const VaultVentPage({super.key});

  @override
  State<VaultVentPage> createState() => _VaultVentPageVentPageState();
  
}

class _VaultVentPageVentPageState extends State<VaultVentPage> with 
  UserProfileProviderService, 
  VentProviderService,
  GeneralSearchController {

  final _vaultDataGetter = VaultVentDataGetter();

  final _isPageLoadedNotifier = ValueNotifier<bool>(false);
  final _filterTextNotifier = ValueNotifier<String>('Latest');

  final ValueNotifier<List<_VaultVentsData>> _vaultVentsData = ValueNotifier([]);

  List<_VaultVentsData> _allVaultVents = [];

  Future<String> _getBodyText(String title) async {

    return await _vaultDataGetter.getBodyText(
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

    return await LastEditGetter().getLastEditVault();

  }

  void _navigateViewVaultVentPage(String title, String tags, String postTimestamp) async {

    final bodyText = await _getBodyText(title);
    final lastEdit = await _getLastEdit(title);

    Navigator.push(
      AppKeys.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => VaultVentViewerPage(
          title: title, 
          tags: tags,
          bodyText: bodyText, 
          lastEdit: lastEdit,
          postTimestamp: postTimestamp
        )
      ),
    );

  }

  Future<void> _initializeVaultVentsData() async {

    try {

      final vaultVentsInfo = await _vaultDataGetter.getMetadata(
        username: userProvider.user.username
      );

      final titles = vaultVentsInfo['title'] as List<String>;
      final tags = vaultVentsInfo['tags'] as List<String>;

      final postTimestamp = vaultVentsInfo['post_timestamp'] as List<String>;

      _vaultVentsData.value = List.generate(titles.length, (index) {
        return _VaultVentsData(
          title: titles[index],
          tags: tags[index],
          postTimestamp: postTimestamp[index],
        );
      });

      _allVaultVents = _vaultVentsData.value;

      _isPageLoadedNotifier.value = true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.vaultFailedToLoad);
    }

  }

  void _removeVentFromList(String title) {
    _vaultVentsData.value = _vaultVentsData.value
      .where((vent) => vent.title != title)
      .toList();
  }

  void _sortVaultVentsToOldest() {

    final sortedList = _vaultVentsData.value
      .toList()
      ..sort((a, b) => FormatDate.parseFormattedTimestamp(b.postTimestamp)
        .compareTo(FormatDate.parseFormattedTimestamp(a.postTimestamp)));

    _vaultVentsData.value = sortedList;

  }

  void _sortVaultVentsToLatest() {

    final sortedList = _vaultVentsData.value
      .toList()
      ..sort((a, b) => FormatDate.parseFormattedTimestamp(a.postTimestamp)
        .compareTo(FormatDate.parseFormattedTimestamp(b.postTimestamp)));

    _vaultVentsData.value = sortedList;

  }

  void _onDeleteVaultPressed(String title) async {

    await VentActionsHandler(
      title: title, 
      creator: userProvider.user.username, 
      context: context
    ).deleteVaultPost().then(
      (_) => _removeVentFromList(title)
    );

  } 

  void _onFilterPressed({required String filter}) { 
    
    switch (filter) {
      case 'Latest':
        _sortVaultVentsToLatest();
        break;
      case 'Oldest':
        _sortVaultVentsToOldest();
        break;
    }

    _filterTextNotifier.value = filter;

    Navigator.pop(context);

  }

  void _searchVaultVents({required String searchText}) {

    final query = searchText.trim().toLowerCase();

    if (query.isNotEmpty) {
      
      final filteredList = _allVaultVents.where((vent) {
        return vent.title.toLowerCase().contains(query);
      }).toList();

      if (filteredList.isNotEmpty) {
        _vaultVentsData.value = filteredList;
      } 

    } else {

      _vaultVentsData.value = List.from(_allVaultVents);

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
      navigateVentPostPageOnPressed: () => _navigateViewVaultVentPage(title, tags, postTimestamp),
      editOnPressed: () async {

        Navigator.pop(AppKeys.navigatorKey.currentContext!);
        
        final bodyText = await _getBodyText(title);

        NavigatePage.editVentPage(
          title: title, body: bodyText, ventType: VentType.vault
        );

      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: AlertMessages.deletePost, 
          buttonMessage: 'Delete',
          onPressedEvent: () => _onDeleteVaultPressed(title)
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
        controller: searchController,
        hintText: 'Search in vault...',
        onChange: (searchText) => _searchVaultVents(searchText: searchText)
      ),
    );
  }

  Widget _buildTotalPost(int postCounts) {

    final postText = postCounts == 1 
      ? "You have 1 vault post." 
      : "You have $postCounts vault posts.";

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
          BottomsheetVaultFilter().buildBottomsheet(
            context: context, 
            currentFilter: _filterTextNotifier.value,
            latestOnPressed: () => _onFilterPressed(filter: 'Latest'),
            oldestOnPressed: () => _onFilterPressed(filter: 'Oldest'),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
    
            const SizedBox(width: 8),
    
            ValueListenableBuilder(
              valueListenable: _filterTextNotifier,
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

  Widget _buildListView(List<_VaultVentsData> vaultData) {
    return DynamicHeightGridView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      crossAxisCount: 1,
      itemCount: vaultData.length + 1,
      builder: (_, index) {
          
        if (index == 0) {
          return _buildHeaderWidgets(postCounts: vaultData.length);
        }

        final ventsData = vaultData[index - 1];

        return _buildVentPreview(ventsData.title, ventsData.tags, ventsData.postTimestamp);

      },
    );
  }
  
  Widget _buildVentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ValueListenableBuilder(
        valueListenable: _isPageLoadedNotifier,
        builder: (_, isLoaded, __) {
          
          if (!isLoaded) {
            return const PageLoading();
          }

          return ValueListenableBuilder(
            valueListenable: _vaultVentsData,
            builder: (_, vaultData, __) { 
              return vaultData.isEmpty 
                ? _buildNoVaultPosts()
                : _buildListView(vaultData);
            },
          );
          
        },
      ),
    );
  }

  Widget _buildNoVaultPosts() {
    return NoContentMessage().customMessage(
      message: 'Your vault is empty.'
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeVaultVentsData();
  }

  @override
  void dispose() {
    disposeControllers();
    _vaultVentsData.dispose();
    _isPageLoadedNotifier.dispose();
    _filterTextNotifier.dispose();
    activeVentProvider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Vault'
      ).buildAppBar(),
      body: _buildVentList(),
    );
  }

}