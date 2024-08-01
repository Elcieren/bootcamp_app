import 'package:bootcamp_app/ui/card/card_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bootcamp_app/ui/home_page.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text;
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Catering, ev yemekleri...',
                    prefixIcon: Icon(Icons.search, color: Colors.orange),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Post').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Menü Bulunamadı'));
            }

            final posts = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final yemekIcerigi = data['YemekIcerigi'] ?? '';
              return yemekIcerigi
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase());
            }).toList();

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final data = post.data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(postData: data),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(2.0), // Padding for the border
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepOrange, width: 3.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Card(
                      margin: EdgeInsets.zero, // Remove margin from the Card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data['link'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.network(
                                    data['link'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    color: Colors.grey[300],
                                  ),
                                  child: Icon(Icons.image,
                                      size: 100, color: Colors.grey[600]),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['text'] ?? 'Başlık yok',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Divider(thickness: 2),
                                Text(
                                  'Yemek İçeriği:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['YemekIcerigi'] ?? 'Bilinmiyor',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Yemek Türü:',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        data['YemekTuru'] ?? 'Bilinmiyor',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Teslimat:',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        data['Teslimat'] ?? 'Bilinmiyor',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Menü Sahibi:',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        data['fullname'] ?? 'Bilinmiyor',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Fiyat: ${data['Fiyat'] ?? 'Bilinmiyor'} TL',
                                      style: TextStyle(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> postData;

  PostDetailPage({required this.postData});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool _isDescriptionVisible = false;
  String _selectedDate = 'Tarih Seç';
  Map<String, dynamic>? businessData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBusinessDetails();
  }

  Future<void> fetchBusinessDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('isletmeler')
        .where('userEmail', isEqualTo: widget.postData['email'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        businessData = snapshot.docs.first.data();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate = DateFormat('dd MM yyyy').format(picked);
      });
    }
  }

  void _navigateToBusinessDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDetailsPage(
          business: BusinessCardModel(
            title: businessData?['title'] ?? '',
            imageUrl: businessData?['imageUrl'] ?? '',
            description: businessData?['aciklama'] ?? '',
            location: businessData?['location'] ?? '',
            userEmail: businessData?['userEmail'] ?? '',

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.postData['text'] ?? 'Detay Sayfası'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.postData['link'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.postData['link'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              )
                  : Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  widget.postData['text'] ?? 'Başlık yok',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(thickness: 2),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Yemek İçeriği:\n${widget.postData['YemekIcerigi'] ?? 'Bilinmiyor'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Yemek Türü: ${widget.postData['YemekTuru'] ?? 'Bilinmiyor'}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Teslimat: ${widget.postData['Teslimat'] ?? 'Bilinmiyor'}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Menü Sahibi: ${widget.postData['fullname'] ?? 'Bilinmiyor'}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isDescriptionVisible = !_isDescriptionVisible;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Açıklama',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.orange),
                            ),
                            Icon(
                              _isDescriptionVisible
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isDescriptionVisible,
                      child: Column(
                        children: [
                          Text(
                            widget.postData['ilanAciklamasi'] ?? 'Bilinmiyor',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Fiyat: ${widget.postData['Fiyat'] ?? 'Bilinmiyor'} TL',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            child: Text(
                              _selectedDate,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CardView(
                                  deliveryType: widget.postData['Teslimat'] ?? "Kendi Teslim Alacak",
                                  address: businessData?['address'] ?? "Adres Bilgisi Yok",
                                  price: widget.postData['Fiyat'] ?? "Fiyat Bilgisi Yok",
                                  name: widget.postData['text'] ?? "İsim Bilgisi yok",
                                  imageLink: widget.postData['link'] ?? "https://example.com/default.jpg",
                                  isletmename: businessData?['userEmail'] ?? "bilgi yok",

                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                            child: Text(
                              'Teklif Et',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : businessData == null
                  ? Center(child: Text('İşletme Bilgisi Bulunamadı'))
                  : GestureDetector(
                onTap: _navigateToBusinessDetails,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'İşletme Bilgileri',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      businessData!['imageUrl'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          businessData!['imageUrl'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                      )
                          : Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                        ),
                        child: Icon(Icons.image,
                            size: 50, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Title: ${businessData!['title'] ?? 'Bilinmiyor'}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description: ${businessData!['aciklama'] ?? 'Bilinmiyor'}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
