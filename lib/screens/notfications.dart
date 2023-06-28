import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('Notifications'),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: NotificationCard(
              title: _getNotificationTitle(index),
              description: _getNotificationDescription(index),
              onTap: () {
                // Handle notification tap
              },
            ),
          );
        },
      ),
    );
  }

  String _getNotificationTitle(int index) {
    switch (index) {
      case 0:
        return 'New Hawker Center Opening: Experience the Buzz at Maxwell Food Centre!';
      case 1:
        return 'Must-Try Hawker Dish: Chili Crab at Newton Food Centre!';
      case 2:
        return 'Discover Hidden Gems: Tiong Bahru Market\'s Delightful Local Eateries!';
      case 3:
        return 'Hawker Spotlight: Tian Tian Hainanese Chicken Rice at Maxwell Food Centre!';
      case 4:
        return 'New Opening: Exciting Food Stalls at Old Airport Road Food Centre!';
      case 5:
        return 'Taste of Peranakan: Nyonya Laksa at Katong Food Centre!';
      case 6:
        return 'Hawker Heritage: Satay at Lau Pa Sat!';
      case 7:
        return 'Hidden Gem: Ah Balling Peanut Soup at ABC Brickworks Market & Food Centre!';
      case 8:
        return 'Breakfast Delights: Roti Prata at Jalan Kayu Food Centre!';
      case 9:
        return 'Sweet Indulgence: Durian Desserts at Geylang Serai Market!';
      default:
        return '';
    }
  }

  String _getNotificationDescription(int index) {
    switch (index) {
      case 0:
        return 'Maxwell Food Centre, known for its diverse range of local delicacies and bustling atmosphere, is now open! Explore the array of mouthwatering food options and soak in the lively hawker culture.';
      case 1:
        return 'Indulge in the iconic Singaporean dish, chili crab, at Newton Food Centre. Experience the perfect blend of spicy and sweet flavors that make this seafood delicacy a favorite among locals and tourists alike.';
      case 2:
        return 'Uncover the hidden culinary gems within Tiong Bahru Market. From traditional kaya toast to artisanal coffee, this market offers a delightful culinary experience in a nostalgic setting.';
      case 3:
        return 'Savor the legendary Hainanese chicken rice at Tian Tian. Tender chicken, fragrant rice, and delectable sauces make this dish a must-try for any food lover visiting Maxwell Food Centre.';
      case 4:
        return 'Old Airport Road Food Centre welcomes new food stalls with exciting flavors. Explore the culinary wonders, from local favorites to international delights, and embark on a gastronomic adventure.';
      case 5:
        return 'Delight in the rich and aromatic flavors of Nyonya Laksa, a traditional Peranakan dish, at Katong Food Centre. Let the blend of spices and creamy coconut broth transport your taste buds.';
      case 6:
        return 'Experience the heritage of satay, a grilled skewered meat dish, at Lau Pa Sat. Enjoy the succulent flavors of tender meat, charred to perfection, served with a side of peanut sauce.';
      case 7:
        return 'Warm your soul with a bowl of Ah Balling Peanut Soup at ABC Brickworks Market & Food Centre. These soft and chewy glutinous rice balls served in a fragrant peanut soup will leave you craving for more.';
      case 8:
        return 'Start your day with the delectable flavors of crispy roti prata, a popular Indian flatbread, at Jalan Kayu Food Centre. Pair it with a fragrant curry dip for an unforgettable breakfast experience.';
      case 9:
        return 'Satiate your sweet tooth with a range of durian desserts at Geylang Serai Market. From durian pengat to durian puff, satisfy your love for the king of fruits in the heart of Singapore\'s cultural district.';
      default:
        return '';
    }
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Add elevation to the card for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(8.0), // Add rounded corners to the card
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0), // Add padding to the list tile
        onTap: onTap,
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                8.0), // Add rounded corners to the image container
            image: DecorationImage(
              image: AssetImage(
                  'assets/notification_placeholder.jpg'), // Placeholder image
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
          ),
        ),
        trailing: SizedBox.shrink(), // Remove the trailing arrow
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'HawkerBro App',
    home: NotificationsScreen(),
  ));
}
