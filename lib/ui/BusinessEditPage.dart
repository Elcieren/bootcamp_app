import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessEditPage extends StatefulWidget {
  final String? businessId;

  const BusinessEditPage({Key? key, this.businessId}) : super(key: key);

  @override
  _BusinessEditPageState createState() => _BusinessEditPageState();
}

class _BusinessEditPageState extends State<BusinessEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;
  List<Map<String, dynamic>> _businesses = [];

  @override
  void initState() {
    super.initState();
    if (widget.businessId != null) {
      _fetchBusinessData(widget.businessId!);
    }
    _fetchUserBusinesses();
  }

  Future<void> _fetchBusinessData(String businessId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance.collection('isletmeler').doc(businessId).get();
      final data = snapshot.data();

      if (data != null) {
        _titleController.text = data['title'] ?? '';
        _descriptionController.text = data['aciklama'] ?? '';
        _locationController.text = data['location'] ?? '';
        _imageUrlController.text = data['imageUrl'] ?? '';
      }
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserBusinesses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('isletmeler')
            .where('userEmail', isEqualTo: user.email)
            .get();
        setState(() {
          _businesses = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveBusinessData() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final businessData = {
            'title': _titleController.text,
            'aciklama': _descriptionController.text,
            'location': _locationController.text,
            'imageUrl': _imageUrlController.text,
            'etiket': 'genel',
            'userEmail': user.email,
          };

          // Check if the user already has a business record
          final snapshot = await FirebaseFirestore.instance
              .collection('isletmeler')
              .where('userEmail', isEqualTo: user.email)
              .get();

          if (snapshot.docs.isNotEmpty) {
            // Update existing record
            await FirebaseFirestore.instance.collection('isletmeler').doc(snapshot.docs.first.id).update(businessData);
          } else {
            // Add new record
            await FirebaseFirestore.instance.collection('isletmeler').add(businessData);
          }

          Navigator.pop(context);
        }
      } catch (e) {
        // Handle errors if needed
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.businessId == null ? 'Yeni İşletme' : 'İşletme Düzenleme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Image URL input field
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'İşletme Logosu (URL)',
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'İşletme logosu URL girin' : null,
                  ),
                  SizedBox(height: 20),
                  // Display image preview if URL is provided
                  if (_imageUrlController.text.isNotEmpty)
                    Image.network(
                      _imageUrlController.text,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'İşletme Adı'),
                    validator: (value) => value?.isEmpty ?? true ? 'İşletme adı girin' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'İşletme Açıklaması'),
                    validator: (value) => value?.isEmpty ?? true ? 'İşletme açıklaması girin' : null,
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'İşletme Şehri'),
                    validator: (value) => value?.isEmpty ?? true ? 'İşletme şehri girin' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveBusinessData,
                    child: Text(widget.businessId == null ? 'Kaydet' : 'Güncelle'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Profil Önizlemesi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _businesses.length,
                itemBuilder: (context, index) {
                  final business = _businesses[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (business['imageUrl'] != null)
                            Image.network(
                              business['imageUrl']!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          SizedBox(height: 10),
                          Text(
                            business['title'] ?? 'No Title',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            business['aciklama'] ?? 'No Description',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            business['location'] ?? 'No Location',
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
