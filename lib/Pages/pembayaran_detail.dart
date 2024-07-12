import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class PembayaranDetail extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  final String method;
  const PembayaranDetail({super.key, required this.paymentData, required this.method});

  // Fungsi untuk menghasilkan nomor virtual account acak 10 digit
  String generateVirtualAccountNumber() {
    final random = Random();
    return List.generate(10, (_) => random.nextInt(10)).join();
  }

  @override
  Widget build(BuildContext context) {
    DateTime expiryDate = DateTime.now().add(const Duration(hours: 24));
    String avatarPath = paymentData['avatar'];
    String virtualAccountNumber = generateVirtualAccountNumber();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  avatarPath,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  paymentData['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              method,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nomor Virtual Account:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                virtualAccountNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Pembayaran:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              paymentData['amount'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tanggal Pembayaran:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Batas Waktu Pembayaran:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(expiryDate),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2, color: Colors.grey),
            const SizedBox(height: 20),
            TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
              var now = DateTime.now();
              var remaining = expiryDate.difference(now);
              return Text(
                'Waktu Pembayaran Tersisa: ${remaining.inHours}:${remaining.inMinutes.remainder(60)}:${remaining.inSeconds.remainder(60)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: const Text('Selesai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
