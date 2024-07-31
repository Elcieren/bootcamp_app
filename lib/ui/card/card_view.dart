import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CardView extends StatefulWidget {
  final String deliveryType;
  final String address;
  final String price;
  final String name;
  final String imageLink;
  final String isletmename;

  const CardView({
    Key? key,
    required this.deliveryType,
    required this.address,
    required this.price,
    required this.name,
    required this.imageLink,
    required this.isletmename,
  }) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool showBackView = false;
  late TextEditingController _addressController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int quantity = 1;
  late double price;
  String? _userEmail;
  String? _userAddress;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat timeFormat = DateFormat('HH:mm'); // 24 saat formatı

  @override
  void initState() {
    super.initState();
    price = double.tryParse(widget.price) ?? 0.0;
    _getUserEmail();
    _fetchUserAddress();
    _addressController = TextEditingController();
    _selectedDate = DateTime.now(); // Bugünün tarihi
  }

  Future<void> _getUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

  Future<void> _fetchUserAddress() async {
    if (_userEmail != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Kullanıcılar')
            .where('email', isEqualTo: _userEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          setState(() {
            _userAddress = userDoc['address'];
            _addressController.text = _userAddress ?? '';
          });
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Error fetching user address: $e');
      }
    }
  }

  void _updateTotalAmount() {
    setState(() {});
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
  double _calculateTotalAmount() {
    if (_selectedDate != null) {
      final now = DateTime.now().toLocal(); // Yerel zamana göre al
      final selectedDate = _selectedDate!;
      final selectedDateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day); // Sadece tarih kısmı
      final nowOnly = DateTime(now.year, now.month, now.day); // Sadece tarih kısmı

      final daysDifference = selectedDateOnly.difference(nowOnly).inDays;

      // Eğer seçilen tarih bugünden ileride ise, gün farkı kadar çarpan ekleyerek fiyatı hesapla
      if (daysDifference > 0) {
        return price * quantity * (daysDifference + 1); // +1, seçilen günü de dahil eder
      } else {
        // Eğer seçilen tarih bugün veya geçmişte ise, orijinal fiyatı döndür
        return price * quantity;
      }
    }

    // Eğer tarih seçilmemişse, sadece orijinal fiyatı döndür
    return price * quantity;
  }




  @override
  Widget build(BuildContext context) {
    final double totalAmount = _calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ödeme Sayfası"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage('assets/white.png'), fit: BoxFit.cover),
          color: Colors.black,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                  title: Text(
                    'Satın Alınan Ürün Bilgileri',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    if (widget.imageLink.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.imageLink,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                      ),
                    if (widget.name.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Satın aldığınız Menü: ${widget.name}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (widget.price.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Menü fiyatı: ${widget.price}₺",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (widget.deliveryType == 'Kendi Teslim Alacak')
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Adres: ${widget.address}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (widget.deliveryType != "Kendi Teslim Alacak")
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Kurye Teslimatı yapılacaktır",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: showBackView,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.orange,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                ),
                const SizedBox(height: 20),
                CreditCardForm(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  onCreditCardModelChange: onCreditCardModelChange,
                  themeColor: Colors.blue,
                  formKey: formKey,
                  cardNumberDecoration: const InputDecoration(
                    labelText: 'Numara',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  expiryDateDecoration: const InputDecoration(
                    labelText: 'Geçerlilik Tarihi',
                    hintText: 'XX/XX',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  cvvCodeDecoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: 'XXX',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  cardHolderDecoration: const InputDecoration(
                    labelText: 'Kart Sahibi',
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                              _updateTotalAmount();
                            });
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(fontSize: 24),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                            _updateTotalAmount();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Tarih seçin'
                              : 'Seçilen Tarih: ${dateFormat.format(_selectedDate!)}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedTime == null
                              ? 'Saat seçin'
                              : 'Seçilen Saat: ${timeFormat.format(DateTime(0, 1, 1, _selectedTime!.hour, _selectedTime!.minute))}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: _selectTime,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Adres',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Toplam Tutar: ${totalAmount.toStringAsFixed(2)}₺',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Tarih ve saat seçimi yapıldı mı kontrol et
                    if (_selectedDate == null || _selectedTime == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Eksik Bilgi"),
                            content: Text("Tarih ve saat seçilmelidir."),
                            actions: [
                              TextButton(
                                child: Text("Tamam"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    await _saveOrder(totalAmount);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Ödeme Başarılı"),
                          content: Text("Ödeme işleminiz başarıyla gerçekleştirildi."),
                          actions: [
                            TextButton(
                              child: Text("Tamam"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Ödeme Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      showBackView = creditCardModel.isCvvFocused;
    });
  }

  Future<void> _saveOrder(double totalAmount) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': _userEmail,
      'totalAmount': totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
      'urun': widget.name,
      'adres': _addressController.text,
      'isletmemail': widget.isletmename,
      'adet': quantity,
      'deliveryDate': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
      'deliveryTime': _selectedTime != null ? '${_selectedTime!.hour}:${_selectedTime!.minute}' : null,
    });
  }
}
