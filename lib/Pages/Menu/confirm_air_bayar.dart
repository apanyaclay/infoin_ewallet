import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:intl/intl.dart';
import 'package:infoin_ewallet/Pages/home.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:provider/provider.dart';

class ConfirmAirBayarPage extends StatelessWidget {
  final String idPelanggan;
  final String namaPelanggan;
  final String provider;
  final int nominalPembayaran;

  ConfirmAirBayarPage({
    required this.idPelanggan,
    required this.namaPelanggan,
    required this.provider,
    required this.nominalPembayaran,
  });

  @override
  Widget build(BuildContext context) {
    final int biayaAdmin = 3000;
    final int totalPembayaran = nominalPembayaran + biayaAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran Air'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'DETAIL TRANSAKSI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ID Pelanggan: $idPelanggan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Nama Pelanggan: $namaPelanggan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Penyedia: $provider',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'DETAIL PEMBAYARAN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nominal: Rp $nominalPembayaran',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Biaya Admin: Rp $biayaAdmin',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Total Pembayaran: Rp $totalPembayaran',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amount = totalPembayaran.toDouble();
                  final newTransaction = {
                    'name': 'Tagihan Air',
                    'type': 'Pengeluaran',
                    'category': 'Air',
                    'amount': amount,
                    'date':
                        DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
                    'avatar': 'assets/images/water.png',
                    'messageContent':
                        'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} berhasil melakukan pembayaran tagihan Air ke $provider'
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MetodePembayaran(transaction: newTransaction),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double totalPembayaran) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final transaksiProvider =
        Provider.of<TransaksiProvider>(context, listen: false);

    bool success = walletProvider.decreaseBalance(totalPembayaran);

    if (success) {
      // Add the transaction directly here
      final newTransaction = {
        'name': 'Pembayaran Air',
        'type': 'Pengeluaran',
        'category': 'Air',
        'amount':
            'Rp ${NumberFormat('#,##0', 'id_ID').format(totalPembayaran)}',
        'date': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
        'avatar':
            'assets/images/img_ellipse_17.png' // Placeholder for avatar image
      };
      transaksiProvider.addTransaction(newTransaction);

      _showSuccessSnackbar(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak cukup untuk pembayaran')),
      );
    }
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pembayaran Anda telah berhasil diproses.'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Navigasi ke halaman Home setelah pembayaran berhasil
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Home()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
    );
  }
}
