// ignore_for_file: library_private_types_in_public_api

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/archive/view_archive_vent_page.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/archive_vent_data_getter.dart';
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
  
  ValueNotifier<List<_ArchivedVentsData>> archivedVentsData = ValueNotifier([]);

  void _viewVentPostPage(String title) async {

    final archiveDataInfo = await archiveDataGetter.getBodyText(
      title: title, creator: userData.user.username
    );

    final bodyText = archiveDataInfo['body_text'];

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

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load archives');
    }

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

  Widget _buildVentList() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ValueListenableBuilder(
        valueListenable: archivedVentsData,
        builder: (_, data, __) {
          return DynamicHeightGridView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()
            ),
            crossAxisCount: 1,
            itemCount: data.length,
            builder: (_, index) {
              final ventsData = data[index];
              return _buildVentPreview(ventsData.title, ventsData.postTimestamp);
            },
          );
        },
      ),
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