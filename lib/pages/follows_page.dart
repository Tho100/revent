import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/follows_getter.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/profile_picture.dart';

class FollowsPage extends StatefulWidget {

  final String pageType;

  const FollowsPage({
    required this.pageType, 
    super.key
  });

  @override
  State<FollowsPage> createState() => FollowsPageState();

}

class FollowsPageState extends State<FollowsPage> {

  final usernameListNotifier = ValueNotifier<List<String>>([]);

  final profileData = GetIt.instance<ProfileDataProvider>();

  Future<void> _loadData() async {

    try {

      final getFollowsInfo = await FollowsGetter().getFollows(followType: widget.pageType);

      usernameListNotifier.value = List.from(getFollowsInfo);

    } catch (err) {
      print(err.toString());
    }

  }

  Widget _buildListViewItems(String username) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
    
          ProfilePictureWidget(
            customWidth: 45,
            customHeight: 45,
            pfpData: profileData.profilePicture
          ),
    
          const SizedBox(width: 10),
    
          Text(
            username,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
    
          const Spacer(),
    
          MainButton(
            customWidth: MediaQuery.of(context).size.width * 0.19,
            customHeight: 40,
            customFontSize: 13,
            text: widget.pageType == 'Followers' ? 'Remove' : 'Follow',
            onPressed: () => print(widget.pageType)
          ),
    
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: usernameListNotifier,
      builder: (_, username, __) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
          ),
          itemCount: usernameListNotifier.value.length,
          itemBuilder: (_, index) {
            return _buildListViewItems(username[index]);
          }
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 28,
          child: ValueListenableBuilder(
            valueListenable: usernameListNotifier, 
            builder: (_, usernames, __) {
              return usernames.isEmpty 
                ?  EmptyPage().nothingToSeeHere()
                : _buildListView();
            }
          )
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: widget.pageType
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }

}