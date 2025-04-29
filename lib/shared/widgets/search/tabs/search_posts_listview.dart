import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/model/filter/search_posts_filter.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/search_filter.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/vent_widgets/default_vent_previewer.dart';

class SearchPostsListView extends StatefulWidget {

  const SearchPostsListView({super.key});

  @override
  State<SearchPostsListView> createState() => _SearchPostsListViewState();

}

class _SearchPostsListViewState extends State<SearchPostsListView> {

  final sortOptionsNotifier = ValueNotifier<String>('Best');
  final timeFilterNotifier = ValueNotifier<String>('All Time');

  final searchPostsFilter = SearchPostsFilter();

  Widget _buildVentPreview(SearchVents ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: DefaultVentPreviewer(
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

  Widget _buildNoResults() {
    return NoContentMessage().customMessage(
      message: 'No results.'
    );
  }

  void _sortOptionsOnPressed(String filter) {
    
    switch (filter) {
      case == 'Best':
        searchPostsFilter.filterPostsToBest();
        break;
      case == 'Latest':
        searchPostsFilter.filterPostsToLatest();
        break;
      case == 'Oldest':
        searchPostsFilter.filterPostsToOldest();
        break;
      case == 'Controversial':
        searchPostsFilter.filterToControversial();
        break;
    }

    sortOptionsNotifier.value = filter;

    Navigator.pop(context);

  }

  void _timeFilterNotifier(String filter) {
    
    switch (filter) {
      case == 'All Time':
        searchPostsFilter.filterPostsByTimestamp('All Time');
        searchPostsFilter.filterPostsToBest();
        break;
      case == 'Past Year':
        searchPostsFilter.filterPostsByTimestamp('Past Year');
        break;
      case == 'Past Month':
        searchPostsFilter.filterPostsByTimestamp('Past Month');
        break;
      case == 'Past Week':
        searchPostsFilter.filterPostsByTimestamp('Past Week');
        break;
      case == 'Today':
        searchPostsFilter.filterPostsByTimestamp('Today');
        break;
    }

    timeFilterNotifier.value = filter;

    Navigator.pop(context);

  }

  Widget _totalSearchResults() {
    return Consumer<SearchPostsProvider>(
      builder: (_, posts, __) {
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
                  text: '${posts.vents.length.toString()}   ',
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

  Widget _buildListView(List<SearchVents> ventDataList) {
    return DynamicHeightGridView(
      key: UniqueKey(),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      crossAxisCount: 1,
      itemCount: ventDataList.length + 1,
      builder: (_, index) {

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
                        bestOnPressed: () => _sortOptionsOnPressed('Best'),
                        latestOnPressed: () => _sortOptionsOnPressed('Latest'),
                        oldestOnPressed: () => _sortOptionsOnPressed('Oldest'),
                        controversialOnPressed: () => _sortOptionsOnPressed('Controversial'),
                      );
                    },
                  ),
                  
                  _buildFilterButtons(
                    notifier: timeFilterNotifier,
                    onPressed: () {
                      BottomsheetSearchFilter().buildTimeFilterBottomsheet(
                        context: context,
                        currentFilter: timeFilterNotifier.value,
                        allTimeOnPressed: () => _timeFilterNotifier('All Time'),
                        pastYearOnPressed: () => _timeFilterNotifier('Past Year'),
                        pastMonthOnPressed: () => _timeFilterNotifier('Past Month'),
                        pastWeekOnPressed: () => _timeFilterNotifier('Past Week'),
                        todayOnPressed: () => _timeFilterNotifier('Today'),
                      );
                    },
                  ),

                ],
              ),

              const SizedBox(height: 4),

              if (ventDataList.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
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