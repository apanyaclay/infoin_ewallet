import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:infoin_ewallet/Pages/pin.dart';
import 'package:infoin_ewallet/Pages/transaksi_sukses.dart';
import 'package:infoin_ewallet/Provider/asuransi.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PembayaranAsuransi extends StatefulWidget {
  final String title;
  final double premiumAmount;

  const PembayaranAsuransi(
      {super.key, required this.title, required this.premiumAmount});

  @override
  _PembayaranAsuransiState createState() => _PembayaranAsuransiState();
}

class _PembayaranAsuransiState extends State<PembayaranAsuransi> {
  final TextEditingController _paymentController = TextEditingController();
  bool _isPaymentValid = true;

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  void _transfer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PinDialog(
          onPinEntered: () {
            Navigator.of(context).pop();
            _prosesTransfer();
          },
        );
      },
    );
  }

  void _prosesTransfer() {
    double nominal = double.tryParse(_paymentController.text) ?? 0;

    if (nominal <= 0 ||
        Provider.of<WalletProvider>(context, listen: false).balance! <
            nominal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nominal tidak valid atau saldo tidak cukup')),
      );
      return;
    }

    bool success = Provider.of<WalletProvider>(context, listen: false)
        .decreaseBalance(nominal);
    var asuransi = Provider.of<AsuransiProvider>(context, listen: false);
    asuransi.purchaseAsuransi(widget.title);
    if (success) {
      Map<String, dynamic> newTransaction = {
        'name': widget.title,
        'type': 'Pengeluaran',
        'category': 'Asuransi',
        'amount': 'Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)}',
        'date': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
        'avatar': 'assets/images/logo-asuransi.png',
        'messageContent':
            'Pembayaran premi asuransi ${widget.title}: Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)} berhasil.'
      };
      Provider.of<TransaksiProvider>(context, listen: false)
          .addTransaction(newTransaction);
      showDialog(
        context: context,
        barrierDismissible:
            false, // Mencegah pengguna menutup dialog dengan menekan di luar dialog
        builder: (BuildContext context) {
          return const Center(
            child:
                CircularProgressIndicator(), // Menampilkan CircularProgressIndicator
          );
        },
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Menutup dialog loading

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionSuccessPage(transactionData: newTransaction),
          ),
        ).catchError((e) {
          print('Error navigating to TransactionSuccessPage: $e');
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi gagal. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var asuransi = Provider.of<AsuransiProvider>(context, listen: false);
    final saldoFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bayar Premi untuk ${widget.title}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Jumlah Premi: Rp ${saldoFormat.format(widget.premiumAmount)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _paymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah minimal adalah Rp 50.000',
                errorText:
                    _isPaymentValid ? null : 'Jumlah minimal adalah Rp 50.000',
                border: const OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  asuransi.purchaseAsuransi(widget.title);
                  final amount = double.tryParse(_paymentController.text) ?? 0;
                  final newTransaction = {
                    'name': 'Premi Asuransi',
                    'type': 'Pengeluaran',
                    'category': 'Asuransi',
                    'amount': amount,
                    'date':
                        DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
                    'avatar': 'assets/images/logo-asuransi.png',
                    'messageContent':
                        'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} berhasil membeli premi ${widget.title}'
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Beli Asuransi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
