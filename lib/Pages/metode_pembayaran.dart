import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/pembayaran_detail.dart';
import 'package:infoin_ewallet/Pages/pin.dart';
import 'package:infoin_ewallet/Pages/transaksi_sukses.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MetodePembayaran extends StatefulWidget {
  final Map<String, dynamic> transaction;
  const MetodePembayaran({required this.transaction, super.key});

  @override
  State<MetodePembayaran> createState() => _MetodePembayaranState();
}

class _MetodePembayaranState extends State<MetodePembayaran> {
  String? _selectedPaymentMethod;
  String? _selectedBank;

  final List<String> _paymentMethods = [
    'Wallet',
    'Bank',
    'Alfamart',
    'Indomaret'
  ];

  final List<String> _banks = ['BRI', 'BCA', 'Mandiri', 'BNI', 'PermataBank'];

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
    double nominal = widget.transaction['amount'];
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

    if (success) {
      Map<String, dynamic> newTransaction = {
        'name': widget.transaction['name'],
        'type': widget.transaction['type'],
        'category': widget.transaction['category'],
        'amount': 'Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)}',
        'date': widget.transaction['date'],
        'avatar': widget.transaction['avatar'],
        'messageContent': widget.transaction['messageContent']
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
        Navigator.of(context).pop();
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
        const SnackBar(content: Text('Transfer gagal. Silakan coba lagi.')),
      );
    }
  }

  _detail(message) {
    double nominal = widget.transaction['amount'];

    Map<String, dynamic> newTransaction = {
      'name': widget.transaction['name'],
      'type': widget.transaction['type'],
      'category': widget.transaction['category'],
      'amount': 'Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)}',
      'date': widget.transaction['date'],
      'avatar': widget.transaction['avatar'],
      'messageContent': widget.transaction['messageContent']
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
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PembayaranDetail(paymentData: newTransaction, method: message),
        ),
      ).catchError((e) {
        print('Error navigating to TransactionSuccessPage: $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);
    final saldoFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Pembayaran:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              children: _paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                      _selectedBank = null;
                    });
                  },
                  secondary: method == 'Wallet'
                      ? Text(saldoFormat.format(wallet.balance ?? 0))
                      : null,
                );
              }).toList(),
            ),
            if (_selectedPaymentMethod == 'Bank') ...[
              const SizedBox(height: 20),
              const Text(
                'Pilih Bank:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: _banks.map((bank) {
                  return RadioListTile<String>(
                    title: Text(bank),
                    value: bank,
                    groupValue: _selectedBank,
                    onChanged: (value) {
                      setState(() {
                        _selectedBank = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            const Spacer(),
            Text(
              'Total : ${saldoFormat.format(widget.transaction['amount'])}',
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Harap pilih metode pembayaran')),
                    );
                  } else if (_selectedPaymentMethod == 'Wallet') {
                    _transfer();
                  } else if (_selectedPaymentMethod == 'Bank' &&
                      _selectedBank == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Harap pilih bank')),
                    );
                  } else {
                    String message =
                        'Metode pembayaran: $_selectedPaymentMethod';
                    if (_selectedBank != null) {
                      message = '$_selectedBank';
                    }
                    _detail(message);
                  }
                },
                child: const Text('Lanjutkan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
