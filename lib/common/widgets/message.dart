import 'package:flutter/material.dart';

class Message {
  final bool isUser;
  final String message;
  final DateTime date;
  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              // Assets klasöründen avatar resmini al
              backgroundImage: AssetImage("assets/sofra.jpg"),
              backgroundColor: Color(0xffFAB703), // Avatar arka plan rengi
            ),
          ),
          SizedBox(width: 8), // Avatar ile metin arasında boşluk
        ],
        Container(
          width:
              MediaQuery.of(context).size.width * 0.7, // İleti kutusu genişliği
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isUser ? Color(0xffFAB703) : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(
                  10), // Sol taraftaki mesajlarda tüm köşeleri yuvarla
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 5), // İleti ve tarih arasında boşluk
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (isUser) ...[
          SizedBox(width: 8), // Metin ile avatar arasında boşluk
        ],
      ],
    );
  }
}
