import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/model/filter/search_posts_filter.dart';
import 'package:revent/pages/empty_page.dart';
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
  final timeFilterNotifier = ValueNotifier<String>('All time');

  final searchPostsFilter = SearchPostsFilter();

  Widget _buildVentPreview(SearchVents ventData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.5),
      child: DefaultVentPreviewer(
        title: ventData.title,
        bodyText: '',
        creator: ventData.creator,
        postTimestamp: ventData.postTimestamp,
        totalLikes: ventData.totalLikes,
        totalComments: ventData.totalComments,
        pfpData: ventData.profilePic,
        useV2ActionButtons: true,
      ),
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage().customMessage(
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
      case == 'All time':
        searchPostsFilter.filterPostsByTimestamp('All time');
        break;
      case == 'Past year':
        searchPostsFilter.filterPostsByTimestamp('Past year');
        break;
      case == 'Past month':
        searchPostsFilter.filterPostsByTimestamp('Past month');
        break;
      case == 'Past week':
        searchPostsFilter.filterPostsByTimestamp('Past week');
        break;
      case == 'Today':
        searchPostsFilter.filterPostsByTimestamp('Today');
        break;
    }

    timeFilterNotifier.value = filter;

    Navigator.pop(context);

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
      
            const SizedBox(width: 12),

            const Icon(CupertinoIcons.chevron_down, color: ThemeColor.thirdWhite, size: 15),
    
            const SizedBox(width: 8),
    
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, filterText, __) {
                return Text(
                  filterText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.thirdWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 13
                  )
                );
              },
            ),
  
            const SizedBox(width: 8),
    
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 12),

              Row(
                children: [

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
                        allTimeOnPressed: () => _timeFilterNotifier('All time'),
                        pastYearOnPressed: () => _timeFilterNotifier('Past year'),
                        pastMonthOnPressed: () => _timeFilterNotifier('Past month'),
                        pastWeekOnPressed: () => _timeFilterNotifier('Past week'),
                        todayOnPressed: () => _timeFilterNotifier('Today'),
                      );
                    },
                  ),

                ],
              ),

              const SizedBox(height: 4),

            ],
          );

        }

        final reversedVentIndex = ventDataList.length - index;

        if (reversedVentIndex >= 0) {
          final vents = ventDataList[reversedVentIndex];
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
  void dispose() {
    sortOptionsNotifier.dispose();
    timeFilterNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchPostsFilter.filterPostsToBest();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchPostsProvider>(
      builder: (_, ventData, __) {

        final vents = ventData.filteredVents;

        return vents.isEmpty 
          ? _buildOnEmpty() 
          : _buildListView(vents);

      }
    );
  }

}