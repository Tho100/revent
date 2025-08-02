import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/user/user_privacy_actions.dart';
import 'package:revent/service/user/user_privacy_handler.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/boredered_container.dart';

class PrivacyPage extends StatefulWidget {

  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();

}

class _PrivacyPageState extends State<PrivacyPage> {

  final privateAccountNotifier = ValueNotifier<bool>(false);
  final hideFollowingListNotifier = ValueNotifier<bool>(false);
  final hideSavedPostNotifier = ValueNotifier<bool>(false);

  final _userPrivacyHandler = UserPrivacyHandler();

  void _initializeCurrentOptions() async {

    final currentOptions = await UserPrivacyActions().getCurrentOptions(
      username: getIt.userProvider.user.username
    );

    privateAccountNotifier.value = currentOptions['account'] != 0;
    hideFollowingListNotifier.value = currentOptions['following'] != 0;
    hideSavedPostNotifier.value = currentOptions['saved'] != 0;     

  }

  Future<void> _onPrivateAccountPressed() async {

    privateAccountNotifier.value 
      ? _userPrivacyHandler.privateAccount(isMakePrivate: 1)
      : _userPrivacyHandler.privateAccount(isMakePrivate: 0);

  }

  Future<void> _onHideFollowingPressed() async {

    hideFollowingListNotifier.value 
      ? _userPrivacyHandler.hideFollowingList(isHideFollowingList: 1)
      : _userPrivacyHandler.hideFollowingList(isHideFollowingList: 0);

  }

  Future<void> _onHideSavedPostsPressed() async {

    hideSavedPostNotifier.value 
      ? _userPrivacyHandler.hideSavedPosts(isHideSavedPosts: 1)
      : _userPrivacyHandler.hideSavedPosts(isHideSavedPosts: 0);

  }

  Widget _buildSwitch(ValueNotifier notifier, VoidCallback onToggled, String text, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Text(
                text,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18
                ),
              ),

              const Spacer(),

              ValueListenableBuilder(
                valueListenable: notifier,
                builder: (_, isToggled, __) {
                  return CupertinoSwitch(
                    value: isToggled,
                    onChanged: (_) {
                      notifier.value = !isToggled;
                      onToggled();
                    },
                    activeColor: ThemeColor.contentPrimary,
                    trackColor: ThemeColor.trackSwitch,
                    thumbColor: ThemeColor.backgroundPrimary,
                  );
                }
              ),

            ],
          ),

          SizedBox(
            width: 230,
            child: Text(
              description,
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontWeight: FontWeight.w700,
                fontSize: 12
              )
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [

          BorderedContainer(
            doubleInternalPadding: true,
            child: _buildSwitch(
              privateAccountNotifier,
              () async => await _onPrivateAccountPressed(),
              'Private Account',
              "Your posts, saves, followers, and following will be hidden from others."
            ),
          ),
          
          BorderedContainer(
            doubleInternalPadding: true,
            child: Column(
              children: [

                _buildSwitch(
                  hideSavedPostNotifier,
                  () async => await _onHideSavedPostsPressed(),
                  'Hide Saved Posts',
                  'Only you can see your saved vent post when this option is enabled.'
                ),
          
                const SizedBox(height: 16),
          
                _buildSwitch(
                  hideFollowingListNotifier,
                  () async => await _onHideFollowingPressed(),
                  'Hide Following List',
                  'Only you can see your following list when this option is enabled.'
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeCurrentOptions();
  }

  @override
  void dispose() {
    privateAccountNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Privacy'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }
  
}