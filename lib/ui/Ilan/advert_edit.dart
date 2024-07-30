import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdvertEditPage extends StatefulWidget {
  const AdvertEditPage({Key? key}) : super(key: key);

  @override
  _AdvertEditPageState createState() => _AdvertEditPageState();
}

class _AdvertEditPageState extends State<AdvertEditPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<DocumentSnapshot> _userPosts = [];

  @override
  void initState() {
    super.initState();
    _getUserPosts();
  }

  Future<void> _getUserPosts() async {
    _user = _auth.currentUser;
    if (_user != null) {
      QuerySnapshot postsSnapshot = await _firestore
          .collection('Post')
          .where('email', isEqualTo: _user!.email)
          .get();

      setState(() {
        _userPosts = postsSnapshot.docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlan Düzenleme'),
      ),
      body: _userPosts.isNotEmpty
          ? ListView.builder(
        itemCount: _userPosts.length,
        itemBuilder: (context, index) {
          var post = _userPosts[index].data() as Map<String, dynamic>;
          return ListTile(
            title: Text(post['fullname']),
            subtitle: Text(post['ilanAciklamasi']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _firestore
                    .collection('Post')
                    .doc(_userPosts[index].id)
                    .delete();
                setState(() {
                  _userPosts.removeAt(index);
                });
              },
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditPostPage(
                    postId: _userPosts[index].id,
                    post: post,
                  ),
                ),
              );
            },
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class EditPostPage extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> post;

  const EditPostPage({Key? key, required this.postId, required this.post})
      : super(key: key);

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _fiyatController;
  late TextEditingController _teslimatController;
  late TextEditingController _yemekategoriController;
  late TextEditingController _yemeicerigiController;
  late TextEditingController _yemekturuController;
  late TextEditingController _textController;
  late TextEditingController _cinsiyetController;
  late TextEditingController _ilanaciklamasiController;
  late TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _fiyatController = TextEditingController(text: widget.post['Fiyat']);
    _teslimatController = TextEditingController(text: widget.post['Teslimat']);
    _yemekategoriController =
        TextEditingController(text: widget.post['YemekKategori']);
    _yemeicerigiController =
        TextEditingController(text: widget.post['YemekIcerigi']);
    _yemekturuController = TextEditingController(text: widget.post['YemekTuru']);
    _textController = TextEditingController(text: widget.post['text']);
    _cinsiyetController = TextEditingController(text: widget.post['cinsiyet']);
    _ilanaciklamasiController =
        TextEditingController(text: widget.post['ilanAciklamasi']);
    _linkController = TextEditingController(text: widget.post['link']);
  }

  Future<void> _updatePost() async {
    await _firestore.collection('Post').doc(widget.postId).update({
      'Fiyat': _fiyatController.text,
      'Teslimat': _teslimatController.text,
      'YemekKategori': _yemekategoriController.text,
      'YemekIcerigi': _yemeicerigiController.text,
      'YemekTuru': _yemekturuController.text,
      'text': _textController.text,
      'cinsiyet': _cinsiyetController.text,
      'ilanAciklamasi': _ilanaciklamasiController.text,
      'link': _linkController.text,
    });
    Navigator.of(context).pop();
  }

  Future<void> _deletePost() async {
    await _firestore.collection('Post').doc(widget.postId).delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlan Düzenle'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updatePost,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deletePost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _fiyatController,
              decoration: InputDecoration(labelText: 'Fiyat'),
            ),
            TextField(
              controller: _teslimatController,
              decoration: InputDecoration(labelText: 'Teslimat'),
            ),
            TextField(
              controller: _yemekategoriController,
              decoration: InputDecoration(labelText: 'Yemek Kategori'),
            ),
            TextField(
              controller: _yemeicerigiController,
              decoration: InputDecoration(labelText: 'Yemek İçeriği'),
            ),
            TextField(
              controller: _yemekturuController,
              decoration: InputDecoration(labelText: 'Yemek Türü'),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Text'),
            ),
            TextField(
              controller: _cinsiyetController,
              decoration: InputDecoration(labelText: 'Cinsiyet'),
            ),
            TextField(
              controller: _ilanaciklamasiController,
              decoration: InputDecoration(labelText: 'İlan Açıklaması'),
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: 'Link'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fiyatController.dispose();
    _teslimatController.dispose();
    _yemekategoriController.dispose();
    _yemeicerigiController.dispose();
    _yemekturuController.dispose();
    _textController.dispose();
    _cinsiyetController.dispose();
    _ilanaciklamasiController.dispose();
    _linkController.dispose();
    super.dispose();
  }
}