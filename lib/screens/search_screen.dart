// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/screens/hawker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchHistory = [];
  List<String> filteredStalls = [];
  Map<String, String> stallAddresses = {};

  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _preferences;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(
      () {
        setState(
          () {
            searchText = _searchController.text;
            fetchStalls();
          },
        );
      },
    );
  }

  Future<void> _loadSearchHistory() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = _preferences.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    await _preferences.setStringList('searchHistory', searchHistory);
  }

  void fetchStalls() async {
    if (searchText.isEmpty) {
      setState(() {
        filteredStalls = [];
      });
      return;
    }

    try {
      final QuerySnapshot snapshot =
          await _firestore.collectionGroup('stalls').get();

      setState(() {
        filteredStalls = snapshot.docs
            .map((doc) => doc['name'] as String)
            .where(
              (name) => name.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
            )
            .toList();

        stallAddresses = Map.fromEntries(
          snapshot.docs.map((doc) {
            final stallName = doc['name'] as String;
            final stallAddress = doc['address'] as String;
            return MapEntry(stallName, stallAddress);
          }),
        );
      });
    } catch (e) {
      debugPrint('Error fetching stalls: $e');
    }
  }

  void navigateToHawkerPage(String stallName) async {
    setState(() {
      _searchController.text = stallName;

      if (searchHistory.contains(stallName)) {
        searchHistory.remove(stallName);
      }

      searchHistory.insert(0, stallName);
      _saveSearchHistory();
    });

    try {
      final QuerySnapshot snapshot = await _firestore
          .collectionGroup('stalls')
          .where('name', isEqualTo: stallName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final stallData = snapshot.docs.first.data() as Map<String, dynamic>;
        final postalCode = stallData['postalCode'] as String?;
        final unitNumber = stallData['unitNumber'] as String?;

        if (postalCode != null && unitNumber != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HawkerStallScreen(
                postalCode: postalCode,
                unitNumber: unitNumber,
              ),
            ),
          );
        } else {
          debugPrint('Postal code or unit number is null');
        }
      } else {
        debugPrint('Stall not found');
      }
    } catch (e) {
      throw Exception('Error navigating to stall details: $e');
    }
  }

  void _clearSearchHistory() {
    setState(() {
      searchHistory.clear();
      _saveSearchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Search for Hawker Stalls',
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () {
                          if (_searchController.text.isEmpty) {
                            Navigator.pop(context);
                          } else {
                            _searchController.clear();
                          }
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (searchHistory.isNotEmpty)
                          TextButton(
                            onPressed: _clearSearchHistory,
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 450.0,
                    child: ListView.builder(
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchHistory[index]),
                          onTap: () {
                            setState(() {
                              _searchController.text = searchHistory[index];
                              filteredStalls.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (searchText.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStalls.length,
                  itemBuilder: (context, index) {
                    final stallName = filteredStalls[index];
                    final stallAddress =
                        stallAddresses[stallName] ?? 'Address not available';

                    return ListTile(
                      leading: const Icon(
                        Icons.place,
                        color: Colors.yellow,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stallName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            stallAddress,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        navigateToHawkerPage(stallName);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
