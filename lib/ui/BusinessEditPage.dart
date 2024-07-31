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
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController(); // Added controller

  bool _isLoading = false;
  List<Map<String, dynamic>> _businesses = [];
  String? _selectedEtiket; // Variable to store selected label

  @override
  void initState() {
    super.initState();
    if (widget.businessId != null) {
      _fetchBusinessData(widget.businessId!);
    } else {
      _fetchUserBusiness();
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
        _phoneNumberController.text = data['phoneNumber'] ?? '';
        _addressController.text = data['address'] ?? ''; // Fetch address
        _selectedEtiket = data['etiket'] ?? 'genel'; // Fetch selected label
      }
    } catch (e) {
      // Handle errors if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserBusiness() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('isletmeler')
            .where('userEmail', isEqualTo: user.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          _titleController.text = data['title'] ?? '';
          _descriptionController.text = data['aciklama'] ?? '';
          _locationController.text = data['location'] ?? '';
          _imageUrlController.text = data['imageUrl'] ?? '';
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _addressController.text = data['address'] ?? ''; // Fetch address
          _selectedEtiket = data['etiket'] ?? 'genel'; // Fetch selected label
        }
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
            'phoneNumber': _phoneNumberController.text,
            'address': _addressController.text, // Save address
            'etiket': _selectedEtiket ?? 'genel', // Save selected label
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
            : SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Image URL input field
                    customTextFormField(
                      controller: _imageUrlController,
                      labelText: 'İşletme Logosu (URL)',
                    ),
                    customTextFormField(
                      controller: _titleController,
                      labelText: 'İşletme Adı',
                    ),
                    customTextFormField(
                      controller: _descriptionController,
                      labelText: 'İşletme Açıklaması',
                    ),
                    customTextFormField(
                      controller: _locationController,
                      labelText: 'İşletme Şehri',
                    ),
                    customTextFormField(
                      controller: _phoneNumberController,
                      labelText: 'Telefon Numarası',
                    ),
                    customTextFormField(
                      controller: _addressController,
                      labelText: 'Adres', // Address input field
                    ),
                    // Read-only TextFormField for displaying "etiket"
                    customTextFormField(
                      controller: TextEditingController(text: _selectedEtiket),
                      labelText: 'Etiket',
                      readOnly: true,
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: _saveBusinessData,
                      child: Text(widget.businessId == null ? 'Kaydet' : 'Güncelle'),
                    ),
                    Divider(thickness: 2,),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Profil Önizlemesi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_businesses.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_businesses[0]['imageUrl'] != null)
                        Image.network(
                          _businesses[0]['imageUrl']!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 10),
                      Text(
                        _businesses[0]['title'] ?? 'No Title',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _businesses[0]['aciklama'] ?? 'No Description',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _businesses[0]['location'] ?? 'No Location',
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _businesses[0]['phoneNumber'] ?? 'No Phone Number',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _businesses[0]['address'] ?? 'No Address', // Display address
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _businesses[0]['etiket'] ?? 'No Etiket', // Display label
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextFormField widget to match the design
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
