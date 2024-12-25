import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/pages/search_results_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
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
    
    if(!searchHistoryNotifier.value.contains(text)) {
      await localStorageModel.addSearchHistory(text: text);
    }

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
      MaterialPageRoute(builder: (_) => SearchResultsPage(searchText: searchText))
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.84,
          child: TextFormField(
            autofocus: true,
            maxLines: 1,
            controller: searchController,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w700,
            ),
            decoration: ThemeStyle.txtFieldStye(
              customBottomPadding: 18,
              customTopPadding: 18,
              hintText: 'Search for anything...',
              customPrefix: const Padding(
                padding: EdgeInsets.only(left: 8.0), 
                child: Icon(CupertinoIcons.search, color: ThemeColor.thirdWhite, size: 20),
              ),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (searchText) {
              _addSearchHistory(text: searchText);
              _goToSearchResults(searchText: searchText);
            },
          ),
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
    
              const Icon(CupertinoIcons.search, color: ThemeColor.thirdWhite, size: 20),
    
              const SizedBox(width: 15),
    
              Text(
                searchText,
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16
                ),
              ),
    
              const Spacer(),
    
              IconButton(
                onPressed: () => _deleteSearchHistory(text: searchText),
                icon: const Icon(CupertinoIcons.clear, color: ThemeColor.secondaryWhite, size: 18)
              ),
    
            ],
          ),
        )
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 12.0, top: 25.0),
      child: ValueListenableBuilder(
        valueListenable: searchHistoryNotifier,
        builder: (_, searchHistoryText, __) {
          return ListView.builder(
            itemCount: searchHistoryText.length,
            itemBuilder: (_, index) {
              final reversedIndex = searchHistoryText.length - 1 - index;
              return _buildSearchItem(searchHistoryText[reversedIndex]);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    searchHistoryNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initializeSearchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        actions: [_buildSearchBar()]
      ).buildAppBar(),
      body: _buildRecentSearches(),
    );
  }

}