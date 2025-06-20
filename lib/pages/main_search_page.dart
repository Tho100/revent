import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/pages/search_results_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';

class MainSearchPage extends StatefulWidget {

  const MainSearchPage({super.key});

  @override
  State<MainSearchPage> createState() => _MainSearchPageState();

}

class _MainSearchPageState extends State<MainSearchPage> {

  final searchController = TextEditingController();

  final searchHistoryNotifier = ValueNotifier<List<String>>([]);

  final localStorageModel = LocalStorageModel();

  void _initializeSearchHistory() async {
    searchHistoryNotifier.value = await localStorageModel.readSearchHistory();
  }

  void _addSearchHistory({required String text}) async {
    await localStorageModel.addSearchHistory(text: text);
  }

  void _deleteSearchHistory({required String text}) async {

    await localStorageModel.deleteSearchHistory(textToDelete: text);

    searchHistoryNotifier.value = searchHistoryNotifier.value
      .where((searchText) => searchText != text)
      .toList();

  }

  void _goToSearchResults({required String searchText}) {

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsPage(searchText: searchText)
      )
    );
    
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, top: 4.0),
      child: SizedBox(
        child: TextFormField(
          autofocus: true,
          maxLines: 1,
          controller: searchController,
          style: GoogleFonts.inter(
            color: ThemeColor.contentSecondary,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: 'Search for anything...',
            counterText: '',
            border: InputBorder.none,
            hintStyle: GoogleFonts.inter(
              color: ThemeColor.contentThird, 
              fontWeight: FontWeight.w700
            ),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (searchText) {
            _addSearchHistory(text: searchText);
            _goToSearchResults(searchText: searchText);
          },
        ),
      ),
    );
  }

  Widget _buildSearchItem(String searchText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWellEffect(
        onPressed: () => _goToSearchResults(searchText: searchText),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
    
              Icon(CupertinoIcons.search, color: ThemeColor.contentThird, size: 20),
    
              const SizedBox(width: 15),
    
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Text(
                  searchText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
    
              const Spacer(),
    
              IconButton(
                onPressed: () => _deleteSearchHistory(text: searchText),
                icon: Icon(CupertinoIcons.clear, color: ThemeColor.contentSecondary, size: 18)
              ),
    
            ],
          ),
        )
      ),
    );
  }

  Widget _buildNoRecentSearches() {
    return Column(
      children: [

        const SizedBox(height: 45),

        Icon(CupertinoIcons.search, color: ThemeColor.contentSecondary, size: 32),

        const SizedBox(height: 18),

        NoContentMessage().headerCustomMessage(
          header: 'No Recent Searches', 
          subheader: 'Your search history will appear here.'
        )

      ],
    );
  }

  Widget _buildClearRecentSearches() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(
          'Recent',
          style: GoogleFonts.inter(
            color: ThemeColor.contentSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 14
          )
        ),

        GestureDetector(
          onTap: () async {
            await localStorageModel.deleteAllSearchHistory().then(
              (_) => searchHistoryNotifier.value = []
            );
          },
          child: Text(
            'Clear',
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 14
            )
          ),
        ),

      ],
    );
  }

  Widget _buildRecentSearchesListView(List<String> searchesHistory) {
    return ListView.builder(
      itemCount: searchesHistory.length + 1,
      itemBuilder: (_, index) {

        if (index == 0) {
          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 25),
              child: _buildClearRecentSearches(),
            ),
          );
        }

        final reversedIndex = searchesHistory.length - index; 

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: _buildSearchItem(searchesHistory[reversedIndex]),
        );

      },
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 20.0),
      child: ValueListenableBuilder(
        valueListenable: searchHistoryNotifier,
        builder: (_, searchHistoryText, __) {
          return searchHistoryText.isEmpty 
            ? _buildNoRecentSearches()
            : _buildRecentSearchesListView(searchHistoryText);
        },
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _initializeSearchHistory();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchHistoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        titleWidget: _buildSearchBar()
      ).buildAppBar(),
      body: _buildRecentSearches(),
    );
  }

}