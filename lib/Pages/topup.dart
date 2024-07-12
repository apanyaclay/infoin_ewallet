import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/topup_detail.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:infoin_ewallet/Widget/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { bankTransfer, alfamart, indomaret }

enum Bank { BRI, BCA, Mandiri, BNI, PermataBank }

class TopUp extends StatefulWidget {
  const TopUp({super.key});

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final TextEditingController _nominalController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.bankTransfer;
  Bank _selectedBank = Bank.BRI;
  bool _isNominalValid = false;

  void _validateNominal(String value) {
    setState(() {
      _isNominalValid = value.isNotEmpty;
    });
  }

  void _topUp() {
    if (!_isNominalValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi nominal terlebih dahulu')),
      );
      return;
    }

    double nominal = double.tryParse(_nominalController.text) ?? 0.0;
    String receiverName = '';
    String avatar = '';

    bool success = false;
    switch (_selectedPaymentMethod) {
      case PaymentMethod.bankTransfer:
        receiverName = _selectedBank.toString().split('.').last;
        avatar = 'assets/images/logo-${receiverName.toLowerCase()}.png';
        success = Provider.of<WalletProvider>(context, listen: false)
            .increaseBalance(nominal);
        break;
      case PaymentMethod.alfamart:
        receiverName = 'Alfamart';
        avatar = 'assets/images/logo-${receiverName.toLowerCase()}.png';
        success = Provider.of<WalletProvider>(context, listen: false)
            .increaseBalance(nominal);
        break;
      case PaymentMethod.indomaret:
        receiverName = 'Indomaret';
        avatar = 'assets/images/logo-${receiverName.toLowerCase()}.png';
        success = Provider.of<WalletProvider>(context, listen: false)
            .increaseBalance(nominal);
        break;
    }
    Map<String, dynamic> newTransaction = {
      'name': receiverName,
      'type': 'Pemasukan',
      'category': 'Top Up',
      'amount': 'Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)}',
      'date': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
      'avatar': avatar,
      'messageContent':
      'Transaksi pemasukan: Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)} berhasil top up dari ${receiverName}'
    };

    if (success) {
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
            builder: (context) => TopUpDetail(transactionData: newTransaction),
          ),
        ).catchError((e) {
          print('Error navigating to TransactionSuccessPage: $e');
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top Up gagal. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<PaymentMethod>(
              value: _selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              items: PaymentMethod.values.map((PaymentMethod method) {
                return DropdownMenuItem<PaymentMethod>(
                  value: method,
                  child: Text(method == PaymentMethod.bankTransfer
                      ? 'Bank Transfer'
                      : method == PaymentMethod.alfamart
                          ? 'Alfamart'
                          : method == PaymentMethod.indomaret
                              ? 'Indomaret'
                              : method.toString().split('.').last),
                );
              }).toList(),
            ),
            if (_selectedPaymentMethod == PaymentMethod.bankTransfer)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Bank',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Bank>(
                    value: _selectedBank,
                    onChanged: (Bank? value) {
                      setState(() {
                        _selectedBank = value!;
                      });
                    },
                    items: Bank.values.map((Bank bank) {
                      return DropdownMenuItem<Bank>(
                        value: bank,
                        child: Text(bank.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const Text(
              'Nominal Top Up',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                border: OutlineInputBorder(),
              ),
              onChanged: _validateNominal,
            ),
            const Spacer(),
            CustomButton(
              onPressed: _topUp,
              text: 'Top Up',
              isEnabled: _isNominalValid,
            ),
          ],
        ),
      ),
    );
  }
}
