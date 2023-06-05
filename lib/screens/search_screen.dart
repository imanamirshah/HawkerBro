import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchHistory = [
    'Pizza',
    'Burger',
    'Sushi',
    'Pasta',
    'Salad',
  ];

  List<String> searchSuggestions = [
    'Chinese Food',
    'Indian Cuisine',
    'Mexican Food',
    'Thai Curry',
    'Steakhouse',
  ];

  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () {
        setState(
          () {
            searchText = _searchController.text;
            filteredSuggestions = searchSuggestions
                .where(
                  (suggestion) => suggestion.toLowerCase().contains(
                        searchText.toLowerCase(),
                      ),
                )
                .toList();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(
                            context,
                          ); // Navigate back to the previous page
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (searchText.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Search History',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 534.0,
                    child: ListView.builder(
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchHistory[index]),
                          onTap: () {
                            setState(
                              () {
                                _searchController.text = searchHistory[index];
                                filteredSuggestions.clear();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (searchText.isNotEmpty && filteredSuggestions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Suggestions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 580.0,
                    child: ListView.builder(
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredSuggestions[index]),
                          onTap: () {
                            setState(() {
                              _searchController.text =
                                  filteredSuggestions[index];
                              filteredSuggestions.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
