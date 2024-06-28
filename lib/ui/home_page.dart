import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0; // Geçerli slayt indeksi

  List<String> imageUrls = [
    'https://adeks.net/wp-content/uploads/2020/01/yemek-banner.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJyuvqvek7_WU5S1mDhK9_ICmgu_lU6GjtJg&s',
    'https://www.samsunkulishaber.com/images/haberler/2019/09/bir-gun-herkes-bizden-yemek-yiyecek.jpg',
    'https://m.gunhaber.com.tr/haber_resim/Catering-Hizmeti-Nedir-538979.png',
    'https://kucukyalimtal.meb.k12.tr/meb_iys_dosyalar/35/01/365840/resimler/2021_07/k_06160531_YYYECEK_YCECEK2x-100.jpg',
  ];

  List<BusinessCardModel> businesses = [
    BusinessCardModel(
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCtgBRoZi2ilPUqzw13Zhn0Z1hw-NpygjFTw&s',
      title: 'Lezzetli, Uygun Fiyatlı Menüler...',
      description:
          'Profesyonel şeflerimizle lezzet ve kaliteyi buluşturuyoruz, catering hizmetlerimizle sizinle.',
      location: 'Denizli',
    ),
    BusinessCardModel(
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnXluUYVDL1gObRnkeWt7u3aF1WS2JuvBQ-Q&s',
      title: 'Hızlı ve Kaliteli Hizmet',
      description:
          '15 yıllık tecrübe ile sizlerleyiz. Çeşitli ve özelliştirilmiş menü hizmeti. Günün her saati teslim avantajı.',
      location: 'Samsun',
    ),
    BusinessCardModel(
      imageUrl:
          'https://i.dugun.com/gallery/17720/preview_samsun-55-yemek-galerisi-1398173037.jpg',
      title: 'Ultra Ucuz Kaliteli Menüler!',
      description:
          'Güvenilir ve lezzetli catering seçenekleriyle her türlü etkinliğinizi özel kılıyoruz, detaylar için bize ulaşın!',
      location: 'Samsun',
    ),
    BusinessCardModel(
      imageUrl:
          'https://eminyavuzer.com/wp-content/uploads/2019/10/yeni-mutfak-catering-logo-sembol-dizayni.jpg',
      title: 'Uygun Fiyata Dev Hizmet',
      description:
          'Etkinlikleriniz için özenle hazırladığımız catering seçenekleriyle lezzeti doğru adrese getiriyoruz. ',
      location: 'Samsun',
    ),
  ];

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
          Column(
            children: businesses
                .map((business) => Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: BusinessCard(
                        imageUrl: business.imageUrl,
                        title: business.title,
                        description: business.description,
                        location: business.location,
                      ),
                    ))
                .toList(),
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

  const BusinessCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          fixedSize: Size(220, 180),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.black, width: 1),
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
                    Flexible(
                      child: Text(
                        description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
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
      ),
    );
  }
}
