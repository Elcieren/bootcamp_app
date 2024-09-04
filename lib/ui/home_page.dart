import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bootcamp_app/ui/post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  late Future<List<String>> _imageUrlsFuture;
  late Future<List<BusinessCardModel>> _businessesFuture;
  late Future<List<BusinessCardModel>> _generalBusinessesFuture;

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

    _imageUrlsFuture = fetchSliderImages();
    _businessesFuture = fetchBusinesses();
    _generalBusinessesFuture = fetchGeneralBusinesses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<String>> fetchSliderImages() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('slider').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['link'] as String;
    }).toList();
  }

  Future<List<BusinessCardModel>> fetchBusinesses() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('isletmeler')
        .where('etiket', isEqualTo: 'ozel')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BusinessCardModel(
        imageUrl: data['imageUrl'] ?? '',
        title: data['title'] ?? '',
        description: data['aciklama'] ?? '',
        location: data['location'] ?? '',
        userEmail: data['userEmail'] ?? '',
      );
    }).toList();
  }

  Future<List<BusinessCardModel>> fetchGeneralBusinesses() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('isletmeler')
        .where('etiket', isEqualTo: 'genel')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BusinessCardModel(
        imageUrl: data['imageUrl'] ?? '',
        title: data['title'] ?? '',
        description: data['aciklama'] ?? '',
        location: data['location'] ?? '',
        userEmail: data['userEmail'] ?? '',
      );
    }).toList();
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
          FutureBuilder<List<String>>(
            future: _imageUrlsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No images found'));
              }

              final imageUrls = snapshot.data!;

              return Stack(
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
              );
            },
          ),
          SizedBox(height: 15),
          Text(
            'Dikkat Çeken İşletmeler',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<BusinessCardModel>>(
            future: _businessesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Veri bulunamadı'));
              }

              final businesses = snapshot.data!;

              return Column(
                children: businesses.map((business) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: BusinessCard(
                      imageUrl: business.imageUrl,
                      title: business.title,
                      description: business.description,
                      location: business.location,
                      userEmail: business.userEmail,
                      borderColorAnimation: _colorAnimation,
                    ),
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            'Genel İşletmeler',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<BusinessCardModel>>(
            future: _generalBusinessesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Veri bulunamadı'));
              }

              final generalBusinesses = snapshot.data!;

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: generalBusinesses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final business = generalBusinesses[index];
                  return GeneralBusinessCard(
                    business: business,
                  );
                },
              );
            },
          ),
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
  final String userEmail;

  BusinessCardModel({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.userEmail,
  });
}

class BusinessCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String location;
  final String userEmail;
  final Animation<Color?> borderColorAnimation;

  const BusinessCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.userEmail,
    required this.borderColorAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final business = BusinessCardModel(
      imageUrl: imageUrl,
      title: title,
      description: description,
      location: location,
      userEmail: userEmail,
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
                side: BorderSide(
                    color: borderColorAnimation.value ?? Colors.red, width: 3),
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

class GeneralBusinessCard extends StatelessWidget {
  final BusinessCardModel business;

  const GeneralBusinessCard({
    Key? key,
    required this.business,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailsPage(business: business),
          ),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                business.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                business.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessDetailsPage extends StatefulWidget {
  final BusinessCardModel business;

  const BusinessDetailsPage({Key? key, required this.business})
      : super(key: key);

  @override
  _BusinessDetailsPageState createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  List<PostModel> menus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  Future<void> fetchMenus() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('email', isEqualTo: widget.business.userEmail)
        .get();
    final fetchedMenus = snapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel(
        imageUrl: data['link'] ?? '',
        text: data['text'] ?? '',
        price: data['Fiyat'] ?? '',
        icerik: data['YemekIcerigi'] ?? '',
        tur: data['YemekTuru'] ?? '',
        teslimat: data['Teslimat'] ?? '',
        sahip: data['fullname'] ?? '',
        aciklama: data['ilanAciklamasi'] ?? '',
      );
    }).toList();

    setState(() {
      menus = fetchedMenus;
      isLoading = false;
    });
  }

  void _navigateToPostDetail(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          postData: {
            'email': widget.business.userEmail,
            'link': post.imageUrl,
            'text': post.text,
            'Fiyat': post.price,
            'YemekIcerigi': post.icerik,
            'YemekTuru': post.tur,
            'Teslimat': post.teslimat,
            'fullname': post.sahip,
            'ilanAciklamasi': post.aciklama,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.business.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.business.imageUrl,
                width: MediaQuery.of(context).size.width /
                    2, // Reduce size to half
              ),
              SizedBox(height: 10),
              Text(
                widget.business.title,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 10),
              Text(
                widget.business.description,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Text(
                'Adres: ${widget.business.location}',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 10),
              Text(
                'Paylaşılan Menüler',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 10),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : menus.isEmpty
                      ? Center(child: Text('No menus found'))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: menus.length,
                          itemBuilder: (context, index) {
                            final menu = menus[index];
                            return GestureDetector(
                              onTap: () => _navigateToPostDetail(menu),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.orange, width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        menu.imageUrl,
                                        width: double.infinity,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        menu.text,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          menu.price + '₺',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostModel {
  final String imageUrl;
  final String text;
  final String price;
  final String icerik;
  final String tur;
  final String teslimat;
  final String sahip;
  final String aciklama;

  PostModel(
      {required this.imageUrl,
      required this.text,
      required this.price,
      required this.icerik,
      required this.tur,
      required this.teslimat,
      required this.sahip,
      required this.aciklama});
}
