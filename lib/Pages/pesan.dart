import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:infoin_ewallet/Widget/bottom_navigation.dart';
import 'package:provider/provider.dart';

class Message {
  final String senderName;
  final String avatar;
  final String date;
  final String messageContent;

  Message(
      {required this.senderName,
      required this.avatar,
      required this.date,
      required this.messageContent});
}

class Pesan extends StatefulWidget {
  const Pesan({super.key});

  @override
  State<Pesan> createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/pesan');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      default:
        throw Exception('Invalid index');
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaksiProvider = Provider.of<TransaksiProvider>(context);
    final List<Message> messages =
        transaksiProvider.transactions.map((transaction) {
      return Message(
        senderName: transaction['name']!,
        avatar: transaction['avatar']!,
        date: transaction['date']!,
        messageContent: transaction['messageContent']!,
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Pesan'),
        centerTitle: true,
        leading: Container(),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          int reverseIndex = messages.length - 1 - index;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, 5),
                    blurRadius: 1,
                    spreadRadius: 1)
              ],
            ),
            child: ListTile(
              leading: ClipOval(
                child: Container(
                  width: 50, // Tentukan ukuran lebar
                  height: 50, // Tentukan ukuran tinggi
                  color: Colors.white, // Tambahkan background putih
                  child: Image.asset(
                    messages[reverseIndex].avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(messages[reverseIndex].senderName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(messages[reverseIndex].messageContent),
                  Text(
                    messages[reverseIndex].date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
