import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  void _sortOptionsOnPressed({required String filter}) {
    
    switch (filter) {
      case == 'Best':
        break;
      case == 'Latest':
        break;
      case == 'Oldest':
        break;
      case == 'Controversial':
        break;
    }

    sortOptionsNotifier.value = filter;

    Navigator.pop(context);

  }

  void _timeFilterNotifier({required String filter}) {
    
    switch (filter) {
      case == 'All time':
        break;
      case == 'Past year':
        break;
      case == 'Past month':
        break;
      case == 'Past week':
        break;
      case == 'Today':
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
      
            const SizedBox(width: 8),

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
                        bestOnPressed: () => _sortOptionsOnPressed(filter: 'Best'), 
                        latestOnPressed: () => _sortOptionsOnPressed(filter: 'Latest'),
                        oldestOnPressed: () => _sortOptionsOnPressed(filter: 'Oldest'),
                        controversialOnPressed: () => _sortOptionsOnPressed(filter: 'Controversial'),
                      );
                    }
                  ),

                  _buildFilterButtons(
                    notifier: timeFilterNotifier,
                    onPressed: () {
                      BottomsheetSearchFilter().buildTimeFilterBottomsheet(
                        context: context, 
                        currentFilter: timeFilterNotifier.value,
                        allTimeOnPressed: () => _timeFilterNotifier(filter: 'All time'), 
                        pastYearOnPressed: () => _timeFilterNotifier(filter: 'Past year'),
                        pastMonthOnPressed: () => _timeFilterNotifier(filter: 'Past month'),
                        pastWeekOnPressed: () => _timeFilterNotifier(filter: 'Past week'),
                        todayOnPressed: () => _timeFilterNotifier(filter: 'Today'),
                      );
                    }
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
          return _buildVentPreview(vents);
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
  Widget build(BuildContext context) {
    return Consumer<SearchPostsProvider>(
      builder: (_, ventData, __) {

        final ventDataList = ventData.vents;

        return ventDataList.isEmpty 
          ? _buildOnEmpty() 
          : _buildListView(ventDataList);

      }
    );
  }

}
