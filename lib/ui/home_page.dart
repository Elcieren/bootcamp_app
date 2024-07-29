import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _current = 0;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  List<String> imageUrls = [];  // Now starts empty
  List<BusinessCardModel> businesses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.transparent,
    ).animate(_controller);

    fetchSliderImages();  // Fetch slider images
    fetchBusinesses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchSliderImages() async {
    final snapshot = await FirebaseFirestore.instance.collection('slider').get();
    final fetchedImageUrls = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['link'] as String; // Cast the imageUrl to String
    }).toList();

    setState(() {
      imageUrls = fetchedImageUrls;
    });
  }


  Future<void> fetchBusinesses() async {
    final snapshot = await FirebaseFirestore.instance.collection('isletmeler').where('etiket', isEqualTo: 'ozel').get();
    final fetchedBusinesses = snapshot.docs.map((doc) {
      final data = doc.data();
      return BusinessCardModel(
        imageUrl: data['imageUrl'] ?? '',
        title: data['title'] ?? '',
        description: data['aciklama'] ?? '',
        location: data['location'] ?? '',
      );
    }).toList();

    setState(() {
      businesses = fetchedBusinesses;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Catering, ev yemekleri...',
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Colors.grey[300],
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.card_giftcard, color: Colors.black),
                  onPressed: () {
                    // Define action when the gift icon is pressed
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications_active_outlined,
                      color: Colors.black),
                  onPressed: () {
                    // Define action when the notification icon is pressed
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CarouselSlider.builder(
                itemCount: imageUrls.length,
                options: CarouselOptions(
                  height: 180,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_current + 1}/${imageUrls.length}',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            ' Dikkat Çeken İşletmeler',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : businesses.isEmpty
              ? Center(child: Text('Veri bulunamadı'))
              : Column(
            children: businesses.map((business) => Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: BusinessCard(
                imageUrl: business.imageUrl,
                title: business.title,
                description: business.description,
                location: business.location,
                borderColorAnimation: _colorAnimation,
              ),
            )).toList(),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class BusinessCardModel {
  final String imageUrl;
  final String title;
  final String description;
  final String location;

  BusinessCardModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
  });
}

class BusinessCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String location;
  final Animation<Color?> borderColorAnimation;

  const BusinessCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.borderColorAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final business = BusinessCardModel(
      imageUrl: imageUrl,
      title: title,
      description: description,
      location: location,
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: AnimatedBuilder(
        animation: borderColorAnimation,
        builder: (context, child) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusinessDetailsPage(business: business),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(220, 180),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: borderColorAnimation.value ?? Colors.red, width: 3),
              ),
              backgroundColor: Colors.white,
              elevation: 5,
              padding: EdgeInsets.zero,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 180,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                          height: 0,
                          indent: 0,
                          endIndent: 15,
                        ),
                        SizedBox(height: 5),
                        Text(description),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BusinessDetailsPage extends StatelessWidget {
  final BusinessCardModel business;

  const BusinessDetailsPage({Key? key, required this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(business.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(business.imageUrl),
            SizedBox(height: 10),
            Text(
              business.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              business.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Location: ${business.location}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
