import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/user_privacy_actions.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';

class PrivacyPage extends StatefulWidget {

  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();

}

class _PrivacyPageState extends State<PrivacyPage> {

  final privateAccountNotifier = ValueNotifier<bool>(false);
  final hideFollowingListNotifier = ValueNotifier<bool>(false);
  final hideSavedPostNotifier = ValueNotifier<bool>(false);

  final userPrivacyActions = UserPrivacyActions();

  void _loadCurrentOptions() async {

    final userData = GetIt.instance<UserDataProvider>();

    final currentOptions = await userPrivacyActions.getCurrentOptions(
      username: userData.user.username
    );

    privateAccountNotifier.value = currentOptions['account'] != 0;
    hideFollowingListNotifier.value = currentOptions['following'] != 0;
    hideSavedPostNotifier.value = currentOptions['saved'] != 0;     

  }

  Future<void> _privateAccountOnPressed() async {

    privateAccountNotifier.value 
      ? userPrivacyActions.privateAccount(isMakePrivate: 1)
      : userPrivacyActions.privateAccount(isMakePrivate: 0);

  }

  Widget _buildSwitch(ValueNotifier notifier, VoidCallback onToggled, String text, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Text(
                text,
                style: GoogleFonts.inter(
                  color: ThemeColor.white,
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
                    activeColor: ThemeColor.white,
                    trackColor: ThemeColor.darkWhite,
                    thumbColor: isToggled ? ThemeColor.black : ThemeColor.white,
                  );
                }
              ),

            ],
          ),

          SizedBox(
            width: 285,
            child: Text(
              description,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
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

          _buildSwitch(
            privateAccountNotifier,
            () async => await _privateAccountOnPressed(),
            'Private account',
            "When your account is private, your profile posts, saved posts, following, and followers list can't be seen by other user."
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(color: ThemeColor.lightGrey),
          ),

          const SizedBox(height: 8),

          _buildSwitch(
            hideSavedPostNotifier,
            () => {},
            'Hide saved post',
            'Only you can see your saved vent post when this option is enabled.'
          ),

          const SizedBox(height: 16),

          _buildSwitch(
            hideFollowingListNotifier,
            () => {},
            'Hide following list',
            'Only you can see your following list when this option is enabled.'
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentOptions();
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