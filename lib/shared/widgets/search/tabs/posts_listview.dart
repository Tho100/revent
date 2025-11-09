import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/type/post_filter_type.dart';
import 'package:revent/model/filter/search_posts_filter.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/search/posts_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/search_filter_bottomsheet.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/vent/default_vent_previewer.dart';

class SearchPostsListView extends StatefulWidget {

  const SearchPostsListView({super.key});

  @override
  State<SearchPostsListView> createState() => _SearchPostsListViewState();

}

class _SearchPostsListViewState extends State<SearchPostsListView> {

  final sortOptionsNotifier = ValueNotifier<String>('Best');
  final timeFilterNotifier = ValueNotifier<String>('All Time');

  final filterMaps = {
    PostFilterType.best: 'Best',
    PostFilterType.latest: 'Latest',
    PostFilterType.oldest: 'Oldest',
    PostFilterType.controversial: 'Controversial',
  };

  final filterDateMaps = {
    PostDateFilterType.allTime: 'All Time',
    PostDateFilterType.pastYear: 'Past Year',
    PostDateFilterType.pastMonth: 'Past Month',
    PostDateFilterType.pastWeek: 'Past Week',
    PostDateFilterType.today: 'Today',
  };

  final searchPostsFilter = SearchPostsFilter();

  void _onSortPostsPressed(PostFilterType filter) {
    
    switch (filter) {
      case PostFilterType.best:
        searchPostsFilter.filterPostsToBest();
        break;
      case PostFilterType.latest:
        searchPostsFilter.filterPostsToLatest();
        break;
      case PostFilterType.oldest:
        searchPostsFilter.filterPostsToOldest();
        break;
      case PostFilterType.controversial:
        searchPostsFilter.filterToControversial();
        break;
    }

    sortOptionsNotifier.value = filterMaps[filter]!;

    Navigator.pop(context);

  }

  void _timeFilterNotifier(PostDateFilterType filter) {

    searchPostsFilter.filterPostsByTimestamp(filter);

    if (filter == PostDateFilterType.allTime) {
      searchPostsFilter.filterPostsToBest();
    }

    timeFilterNotifier.value = filterDateMaps[filter]!;

    Navigator.pop(context);

  }

  Widget _buildVentPreview(SearchVentsData ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DefaultVentPreviewer(
        postId: ventData.postId,
        title: ventData.title,
        bodyText: '',
        tags: ventData.tags,
        postTimestamp: ventData.postTimestamp,
        totalLikes: ventData.totalLikes,
        totalComments: ventData.totalComments,
        isNsfw: ventData.isNsfw,
        creator: ventData.creator,
        pfpData: ventData.profilePic,
        disableActionButtons: true,
      ),
    );
  }

  Widget _totalSearchResults() {
    return Selector<SearchPostsProvider, int>(
      selector: (_, searchPostsData) => searchPostsData.filteredVents.length,
      builder: (_, totalVents, __) {
        return Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 2.0),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
              children: [
      
                TextSpan(
                  text: '${totalVents.toString()}   ',
                  style: TextStyle(color: ThemeColor.contentPrimary),
                ),
      
                TextSpan(
                  text: 'Results',
                  style: TextStyle(color: ThemeColor.contentThird),
                ),
      
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButtons({
    required ValueListenable notifier, 
    required VoidCallback onPressed
  }) {
    return SizedBox(
      height: 35,
      child: InkWellEffect(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            const SizedBox(width: 8),
    
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, filterText, __) {
                return Text(
                  filterText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13
                  )
                );
              },
            ),
  
            const SizedBox(width: 8),

            Icon(CupertinoIcons.chevron_down, color: ThemeColor.contentPrimary, size: 15),

            const SizedBox(width: 12),
    
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<SearchVentsData> ventDataList) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 25,
      child: ListView.builder(
        key: UniqueKey(),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: ventDataList.length + 1,
        itemBuilder: (_, index) {
    
          if (index == 0) {
    
            return Column(
              children: [
    
                const SizedBox(height: 12),
    
                Row(
                  children: [
    
                    _totalSearchResults(),
    
                    const Spacer(),
    
                    _buildFilterButtons(
                      notifier: sortOptionsNotifier,
                      onPressed: () {
                        BottomsheetSearchFilter().buildSortOptionsBottomsheet(
                          context: context,
                          currentFilter: sortOptionsNotifier.value,
                          bestOnPressed: () => _onSortPostsPressed(PostFilterType.best),
                          latestOnPressed: () => _onSortPostsPressed(PostFilterType.latest),
                          oldestOnPressed: () => _onSortPostsPressed(PostFilterType.oldest),
                          controversialOnPressed: () => _onSortPostsPressed(PostFilterType.controversial),
                        );
                      },
                    ),
                    
                    _buildFilterButtons(
                      notifier: timeFilterNotifier,
                      onPressed: () {
                        BottomsheetSearchFilter().buildTimeFilterBottomsheet(
                          context: context,
                          currentFilter: timeFilterNotifier.value,
                          allTimeOnPressed: () => _timeFilterNotifier(PostDateFilterType.allTime),
                          pastYearOnPressed: () => _timeFilterNotifier(PostDateFilterType.pastYear),
                          pastMonthOnPressed: () => _timeFilterNotifier(PostDateFilterType.pastMonth),
                          pastWeekOnPressed: () => _timeFilterNotifier(PostDateFilterType.pastWeek),
                          todayOnPressed: () => _timeFilterNotifier(PostDateFilterType.today),
                        );
                      },
                    ),
    
                  ],
                ),
    
                const SizedBox(height: 8),
    
                if (ventDataList.isEmpty)
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: Center(
                    child: _buildNoResults(),
                  ),
                ),
    
              ],
            );
    
          }
    
          final adjustedIndex = ventDataList.length - index;
    
          if (adjustedIndex >= 0) {
            final vents = ventDataList[adjustedIndex];
            return KeyedSubtree(
              key: ValueKey('${vents.title}/${vents.creator}'),
              child: _buildVentPreview(vents),
            );
          }
    
          return const SizedBox.shrink();
          
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return NoContentMessage().customMessage(
      message: 'No results.'
    );
  }

  @override
  void initState() {
    super.initState();
    searchPostsFilter.filterPostsToBest();
  }

  @override
  void dispose() {
    sortOptionsNotifier.dispose();
    timeFilterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchPostsProvider>(
      builder: (_, ventData, __) {

        final vents = ventData.vents;
        final filteredVents = ventData.filteredVents;

        return vents.isEmpty 
          ? _buildNoResults() 
          : _buildListView(filteredVents);

      }
    );
  }

}