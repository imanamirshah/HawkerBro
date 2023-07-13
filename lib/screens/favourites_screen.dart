import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/screens/hawker_screen.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final user = ap.userModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        toolbarHeight: 70,
        title: const Text(
          'Favourites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('favourites')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(50),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: const [
                      TextSpan(
                        text:
                            'To add a stall to your Favourites tab, click on ',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(
                            Icons.bookmark_outline,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            ' on the top right-hand corner of the hawker stall description page.',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final favourite = snapshot.data!.docs[index];
              final stallName = favourite['stallName'] as String;
              final postalCode = favourite['postalCode'] as String;
              final unitNumber = favourite['unitNumber'] as String;
              final address = favourite['address'] as String;
              final imageUrl = favourite['imageUrl'];
              final displayAddress = address.isNotEmpty ? '$address,' : '';
              final leadingWidget = imageUrl != null && imageUrl.isNotEmpty
                  ? CircleAvatar(
                      foregroundImage: NetworkImage(imageUrl),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.black26,
                      ), // Placeholder icon if no image available
                    ); // Image URL

              return ListTile(
                leading: leadingWidget,
                tileColor: Colors.white10,
                title: Text(stallName),
                subtitle: Text(
                  "$displayAddress Singapore $postalCode",
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HawkerStallScreen(
                        postalCode: postalCode,
                        unitNumber: unitNumber,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
