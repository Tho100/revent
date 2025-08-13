
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/cache_names.dart';
import 'package:revent/helper/cache_helper.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/service/activity_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/query/vent/vent_data_getter.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/navigation/navigation_bar_dock.dart';
import 'package:revent/shared/widgets/navigation_pages_widgets.dart';
import 'package:revent/shared/widgets/no_content_message.dart';

class ActivityPage extends StatefulWidget {

  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();

}

class _ActivityPageState extends State<ActivityPage> with 
  NavigationProviderService, 
  UserProfileProviderService {

  final activityNotifier = ValueNotifier<Map<String, List<dynamic>>>({});

  final activityService = ActivityService();

  final likedPostType = 'liked_post';
  final newFollowerType = 'new_follower';

  void _initializeActivityData() async {

    final caches = await CacheHelper().getActivityCache();

    final storedLikes = caches[CacheNames.postLikesCache];
    final storedFollowers = caches[CacheNames.followersCache];

    Map<String, List<dynamic>> combined = {};

    if (storedLikes is Map) {
      storedLikes.forEach((title, data) {
        combined[title] = [data[0], data[1], likedPostType];
      });
    }

    if (storedFollowers is Map) {
      storedFollowers.forEach((username, data) {
        combined[username] = [0, data[0], newFollowerType];
      });
    }

    activityNotifier.value = combined;

  }

  Future<void> _navigateToLikedPost({required String title}) async {
    
    final postId = await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    final ventDataGetter = VentDataGetter(postId: postId);

    final bodyText = await ventDataGetter.getBodyText();
    final metadata = await ventDataGetter.getMetadata();

    final tags = metadata['tags'];
    final totalLikes = metadata['total_likes'];
    final postTimestamp = metadata['post_timestamp'];
    final isNsfw = metadata['is_nsfw'];

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VentPostPage(
            title: title, 
            postId: postId,
            bodyText: bodyText, 
            tags: tags,
            postTimestamp: postTimestamp,
            isNsfw: isNsfw,
            totalLikes: totalLikes,
            creator: userProvider.user.username, 
            pfpData: profileProvider.profile.profilePicture,
          )
        ),
      );
    }

  }

  Future<void> _refreshActivites() async {

    activityNotifier.value.clear();

    await activityService.initializeActivities().then(
      (_) => _initializeActivityData()
    );

    await activityService.markActivityAsRead();

  }

  Map<String, List<int>> _groupIndicesByTime(List<String> timestampList) {

    Map<String, List<int>> groups = {
      'Today': [],
      'Last Week': [],
      'Last Month': [],
      'Last Year': [],
      'Earlier': [],
    };

    for (int i = 0; i < timestampList.length; i++) {

      final timestamp = timestampList[i];
      final duration = FormatDate.formatTimestampToDuration(timestamp);

      if (duration.inHours < 24) {
        groups['Today']!.add(i);
        
      } else if (duration.inDays < 7) {
        groups['Last Week']!.add(i);

      } else if (duration.inDays < 31) {
        groups['Last Month']!.add(i);

      } else if (duration.inDays < 366) {
        groups['Last Year']!.add(i);

      } else {
        groups['Earlier']!.add(i);

      }

    }

    return groups;

  }

  Widget _buildPostLikedBadge() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColor.likedColor
      ),
      child: const Icon(CupertinoIcons.heart_fill, color: Colors.white),
    );
  }

  Widget _buildNewFollowerBadge() {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent
      ),
      child: const Icon(CupertinoIcons.person_add, color: Colors.white),
    );
  }

  Widget _buildMainInfo(String activitySubject, int likes, String timestamp, {String type = 'like'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          type == newFollowerType
            ? '$activitySubject followed you'
            : likes == 1 ? 'Someone liked your post' : 'Your post received $likes likes',
          style: GoogleFonts.inter(
            color: ThemeColor.contentPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.45,
              ),
              child: Text(
                type == newFollowerType ? '' : activitySubject,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (type == likedPostType) const SizedBox(width: 6),

            Text(
              timestamp,
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),

          ],

        ),

      ],
    );
  }

  Widget _buildActivityListView({
    required List<String> subjects,
    required List<int> likes,
    required List<String> timestamp,
    required List<String> types
  }) {

    final grouped = _groupIndicesByTime(timestamp);

    return RefreshIndicator(
      onRefresh: () async => await _refreshActivites(),
      child: ListView(
        children: grouped.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10),
                child: Text(
                  entry.key, 
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentSecondary,
                    fontWeight: FontWeight.w800, 
                    fontSize: 18
                  )
                ),
              ),
              
              ...entry.value.map((index) => _buildActivityTile(
                subjects[index],
                likes[index],
                timestamp[index],
                types[index],
              )).toList()
              
            ],
          )).toList(),
      ),
    );
  }

  Widget _buildActivityTile(String subject, int likes, String ts, String type) {
    return InkWellEffect(
      onPressed: () async {
        if (type == likedPostType) {
          await _navigateToLikedPost(title: subject);
        } else if (type == newFollowerType) {
          NavigatePage.userProfilePage(username: subject);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [

              type == likedPostType
                ? _buildPostLikedBadge()
                : _buildNewFollowerBadge(),

              const SizedBox(width: 12),

              _buildMainInfo(subject, likes, ts, type: type),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(Icons.arrow_forward_ios, color: ThemeColor.contentThird, size: 18),
              ),

            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: activityNotifier,
      builder: (_, data, __) {

        final formatTimestamp = FormatDate();

        final sortedEntries = data.entries.toList()
          ..sort((a, b) {
            final aTime = formatTimestamp.convertRelativeTimestampToDateTime(b.value[1]);
            final bTime = formatTimestamp.convertRelativeTimestampToDateTime(a.value[1]);
            return aTime.compareTo(bTime);
          }
        );

        if (sortedEntries.isEmpty) {
          return _buildNoActivity();
        }

        final subjects = sortedEntries.map((e) => e.key).toList();
        final timestamp = sortedEntries.map((e) => e.value[1].toString()).toList();
        final likes = sortedEntries.map((e) => e.value[0] as int).toList();

        final types = sortedEntries.map(
          (e) => e.value.length > 2 ? e.value[2].toString() : likedPostType
        ).toList();

        return _buildActivityListView(
          subjects: subjects, 
          timestamp: timestamp, 
          likes: likes, 
          types: types
        );

      },
    );
  }

  Widget _buildNoActivity() {
    return NoContentMessage().customMessage(
      message: 'No new activity.'
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeActivityData();
  }

  @override
  void dispose() {
    activityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Activity',
          customBackOnPressed: () => NavigatePage.homePage(),
          context: context,
          actions: [NavigationPagesWidgets.profilePictureLeading()]
        ).buildNavigationAppBar(),
        body: _buildBody(),
        bottomNavigationBar: NavigationBarDock()
      ),
    );
  }

}