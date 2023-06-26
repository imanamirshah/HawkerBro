import 'package:flutter/material.dart';
// import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/screens/account_screen.dart';
import 'package:hawkerbro/screens/hawker_screen.dart';
import 'package:hawkerbro/screens/search_screen.dart';
// import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  PageController pageController = PageController(viewportFraction: 0.85);
  bool isHawkerCentre1Selected = true;

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Hi, ${ap.userModel.name} ',
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 4),
            const Text(
              'Find Delicious Hawker Food',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.black,
                // backgroundImage: NetworkImage(ap.userModel.profilePic),
                radius: 50,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 10),
                      const Text('Search...'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    'Near You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isHawkerCentre1Selected = true;
                            });
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: isHawkerCentre1Selected
                                  ? Colors.yellow
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Maxwell Hawker Centre',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isHawkerCentre1Selected = false;
                            });
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: isHawkerCentre1Selected
                                  ? Colors.grey[300]
                                  : Colors.yellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Newton Food Centre',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HawkerStallScreen(
                              postalCode: '',
                              unitNumber: '',
                            ),
                          ),
                        );
                      },
                      child: PageView.builder(
                        itemCount: isHawkerCentre1Selected ? 2 : 2,
                        itemBuilder: (context, position) {
                          if (isHawkerCentre1Selected) {
                            if (position == 0) {
                              return _buildPageItem(
                                'assets/laksa.jpeg',
                                'Old Nonya',
                                '5.0',
                                '369',
                              );
                            } else {
                              return _buildPageItem(
                                'assets/tiantian.jpeg',
                                'Tian Tian Hainanese Chicken Rice',
                                '5.0',
                                '1234',
                              );
                            }
                          } else {
                            if (position == 0) {
                              return _buildPageItem(
                                'assets/hawker3.jpeg',
                                'Hup Kee Fried Oyster Omelette',
                                '4.5',
                                '256',
                              );
                            } else {
                              return _buildPageItem(
                                'assets/hawker4.jpeg',
                                'Kwang Kee Teochew Fish Porridge',
                                '4.2',
                                '789',
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'RECOMMENDATIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildRecommendedPageItem(
                          'assets/tangshui.jpeg',
                          '115 Tang Shui',
                        ),
                        _buildRecommendedPageItem(
                          'assets/whampoaprawnmee.jpeg',
                          '545 Whampoa Prawn Noodles',
                        ),
                        _buildRecommendedPageItem(
                          'assets/75peanut.jpeg',
                          '75 China Street Peanut Soup',
                        ),
                        _buildRecommendedPageItem(
                          'assets/ahwee.jpeg',
                          'Ah Hwee BBQ',
                        ),
                        _buildRecommendedPageItem(
                          'assets/ahxiao.jpeg',
                          'Ah Xiao Teochew Braised Duck',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageItem(
    String imagePath,
    String title,
    String stars,
    String reviews,
  ) {
    return Stack(
      children: [
        Container(
          height: 250,
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFF69c5df),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(imagePath),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        stars,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '(${reviews})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedPageItem(
    String imagePath,
    String title,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HawkerStallScreen(
              postalCode: '',
              unitNumber: '',
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[300],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(imagePath),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
