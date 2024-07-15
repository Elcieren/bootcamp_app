import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No shadow
        automaticallyImplyLeading: false,
        title: Text('Paylaşılan Menüler'),
        backgroundColor: Colors.orange, // Match with Scaffold background
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.white],
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
              return Center(child: Text('Veri bulunamadı'));
            }

            final posts = snapshot.data!.docs;

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
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data['imageUrl'] != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            data['imageUrl'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        )
                            : Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            color: Colors.grey[300],
                          ),
                          child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['text'] ?? 'Başlık yok',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Fiyat: ${data['Fiyat'] ?? 'Bilinmiyor'} TL',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('Teslimat: ${data['Teslimat'] ?? 'Bilinmiyor'}'),
                              SizedBox(height: 5),
                              Text('Yemek İçeriği: ${data['YemekIcerigi'] ?? 'Bilinmiyor'}'),
                              SizedBox(height: 5),
                              Text('Yemek Türü: ${data['YemekTuru'] ?? 'Bilinmiyor'}'),
                              SizedBox(height: 5),
                              Text('Açıklama: ${data['ilanAciklamasi'] ?? 'Bilinmiyor'}'),
                              SizedBox(height: 5),
                              Text('Kullanıcı Adı: ${data['username'] ?? 'Bilinmiyor'}'),
                            ],
                          ),
                        ),
                      ],
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

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> postData;

  PostDetailPage({required this.postData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No shadow
        title: Text(postData['text'] ?? 'Detay Sayfası'),
        backgroundColor: Colors.orange, // Match with Scaffold background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            postData['imageUrl'] != null
                ? Image.network(
              postData['imageUrl'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            )
                : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              postData['text'] ?? 'Başlık yok',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Fiyat: ${postData['Fiyat'] ?? 'Bilinmiyor'} TL',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 5),
            Text('Teslimat: ${postData['Teslimat'] ?? 'Bilinmiyor'}'),
            SizedBox(height: 5),
            Text('Yemek İçeriği: ${postData['YemekIcerigi'] ?? 'Bilinmiyor'}'),
            SizedBox(height: 5),
            Text('Yemek Türü: ${postData['YemekTuru'] ?? 'Bilinmiyor'}'),
            SizedBox(height: 5),
            Text('Açıklama: ${postData['ilanAciklamasi'] ?? 'Bilinmiyor'}'),
            SizedBox(height: 5),
            Text('Kullanıcı Adı: ${postData['username'] ?? 'Bilinmiyor'}'),
          ],
        ),
      ),
    );
  }
}
