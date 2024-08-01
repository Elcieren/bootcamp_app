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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFA500), // Orange color
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ListTile(
                title: Text(post['text'], style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),
                subtitle: Text(post['ilanAciklamasi'], style: TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
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
              ),
            ),
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
  final _formKey = GlobalKey<FormState>();
  final _fiyatController = TextEditingController();
  final _teslimatController = TextEditingController();
  final _yemekKategoriController = TextEditingController();
  final _yemekIcerigiController = TextEditingController();
  final _yemekTuruController = TextEditingController();
  final _textController = TextEditingController();
  final _cinsiyetController = TextEditingController();
  final _ilanAciklamasiController = TextEditingController();
  final _linkController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fiyatController.text = widget.post['Fiyat'] ?? '';
    _teslimatController.text = widget.post['Teslimat'] ?? '';
    _yemekKategoriController.text = widget.post['YemeKategori'] ?? '';
    _yemekIcerigiController.text = widget.post['YemekIcerigi'] ?? '';
    _yemekTuruController.text = widget.post['YemekTuru'] ?? '';
    _textController.text = widget.post['text'] ?? '';
    _cinsiyetController.text = widget.post['cinsiyet'] ?? '';
    _ilanAciklamasiController.text = widget.post['ilanAciklamasi'] ?? '';
    _linkController.text = widget.post['link'] ?? '';
  }

  Future<void> _updatePost() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('Post').doc(widget.postId).update({
          'Fiyat': _fiyatController.text,
          'Teslimat': _teslimatController.text,
          'YemekKategori': _yemekKategoriController.text,
          'YemekIcerigi': _yemekIcerigiController.text,
          'YemekTuru': _yemekTuruController.text,
          'text': _textController.text,
          'cinsiyet': _cinsiyetController.text,
          'ilanAciklamasi': _ilanAciklamasiController.text,
          'link': _linkController.text,
        });
        Navigator.of(context).pop();
      } catch (e) {
        // Handle errors if needed
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('Post').doc(widget.postId).delete();
      Navigator.of(context).pop();
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                customTextFormField(
                  controller: _fiyatController,
                  labelText: 'Fiyat',
                ),
                customTextFormField(
                  controller: _teslimatController,
                  labelText: 'Teslimat',
                ),
                customTextFormField(
                  controller: _yemekKategoriController,
                  labelText: 'Yemek Kategori',
                ),
                customTextFormField(
                  controller: _yemekIcerigiController,
                  labelText: 'Yemek İçeriği',
                ),
                customTextFormField(
                  controller: _yemekTuruController,
                  labelText: 'Yemek Türü',
                ),
                customTextFormField(
                  controller: _textController,
                  labelText: 'Text',
                ),
                customTextFormField(
                  controller: _cinsiyetController,
                  labelText: 'Cinsiyet',
                ),
                customTextFormField(
                  controller: _ilanAciklamasiController,
                  labelText: 'İlan Açıklaması',
                ),
                customTextFormField(
                  controller: _linkController,
                  labelText: 'Link',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePost,
                  child: Text('Kaydet'),
                ),
                SizedBox(height: 20),
                Divider(thickness: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextFormField({required TextEditingController controller, required String labelText, bool readOnly = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        readOnly: readOnly,
        validator: (value) => value?.isEmpty ?? true ? '$labelText girin' : null,
      ),
    );
  }
}