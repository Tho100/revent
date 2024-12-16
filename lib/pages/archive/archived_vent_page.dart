// ignore_for_file: library_private_types_in_public_api

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/archive/view_archive_vent_page.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/archive/archive_vent_data_getter.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class _ArchivedVentsData {
  
  final String title;
  final String postTimestamp;

  _ArchivedVentsData({
    required this.title,
    required this.postTimestamp
  });

}

class ArchivedVentPage extends StatefulWidget {

  const ArchivedVentPage({super.key});

  @override
  State<ArchivedVentPage> createState() => ArchivedVentPageState();
  
}

class ArchivedVentPageState extends State<ArchivedVentPage> {

  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  final archiveDataGetter = ArchiveVentDataGetter();

  final isPageLoadedNotifier = ValueNotifier<bool>(false);
  
  ValueNotifier<List<_ArchivedVentsData>> archivedVentsData = ValueNotifier([]);

  Future<String> _getBodyText({required String title}) async {

    final archiveDataInfo = await archiveDataGetter.getBodyText(
      title: title, creator: userData.user.username
    );

    return archiveDataInfo['body_text'];

  } 

  void _viewVentPostPage(String title) async {

    final bodyText = await _getBodyText(title: title);

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => ViewArchiveVentPage(
        title: title, 
        bodyText: bodyText, 
      )),
    );

  }

  Future<void> _loadArchiveVentsData() async {

    try {

      final archiveVentsInfo = await archiveDataGetter.getPosts(
        username: userData.user.username
      );

      final titles = archiveVentsInfo['title'] as List<String>;
      final postTimestamp = archiveVentsInfo['post_timestamp'] as List<String>;

      archivedVentsData.value = List.generate(titles.length, (index) {
        return _ArchivedVentsData(
          title: titles[index],
          postTimestamp: postTimestamp[index],
        );
      });

      isPageLoadedNotifier.value = true;

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load archives.');
    }

  }

  void _deleteVentArchive(String title) async {

    await CallVentActions(
      context: context, 
      title: title, 
      creator: userData.user.username
    ).deleteArchivePost().then((value) {
      archivedVentsData.value = archivedVentsData.value
        .where((vent) => vent.title != title)
        .toList();
    });

  } 

  Widget _buildVentPreview(String title, String postTimestamp) {

    final ventPreviewer = VentPreviewerWidgets(
      context: context,
      title: title,
      bodyText: '',
      creator: userData.user.username,
      pfpData: profileData.profilePicture,
      postTimestamp: postTimestamp,
      viewVentPostOnPressed: () => _viewVentPostPage(title),
      editOnPressed: () async {

        Navigator.pop(navigatorKey.currentContext!);
        
        final bodyText = await _getBodyText(title: title);
        NavigatePage.editVentPage(title: title, body: bodyText, isArchive: true);

      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: 'Delete this archive?', 
          buttonMessage: 'Delete',
          onPressedEvent: () => _deleteVentArchive(title)
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ventPreviewer.buildMainContainer(
        children: [
    
          Row(
            children: [
    
              ventPreviewer.buildHeaders(),
    
              const Spacer(),
    
              ventPreviewer.buildVentOptionsButton()
              
            ],
          ),
    
          const SizedBox(height: 14),
    
          ventPreviewer.buildTitle(),

          const SizedBox(height: 8),
    
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
      itemCount: archiveData.length,
      builder: (_, index) {
        final ventsData = archiveData[index];
        return _buildVentPreview(ventsData.title, ventsData.postTimestamp);
      },
    );
  }
  
  Widget _buildVentList() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ValueListenableBuilder(
        valueListenable: isPageLoadedNotifier,
        builder: (_, isLoaded, __) {
          
          if (!isLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)
            );
          }

          return ValueListenableBuilder(
            valueListenable: archivedVentsData,
            builder: (_, archiveData, __) { 
              return archiveData.isEmpty 
                ? _buildOnEmpty()
                : _buildListView(archiveData);
            },
          );
          
        },
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
      message: 'Your archive is empty.'
    );
  }

  @override
  void initState() {
    _loadArchiveVentsData();
    super.initState();
  }

  @override
  void dispose() {
    archivedVentsData.dispose();
    isPageLoadedNotifier.dispose();
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