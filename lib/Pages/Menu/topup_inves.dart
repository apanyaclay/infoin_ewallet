import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:intl/intl.dart';

class TopUpInvestasi extends StatefulWidget {
  const TopUpInvestasi({super.key});

  @override
  State<TopUpInvestasi> createState() => _TopUpInvestasiState();
}

class _TopUpInvestasiState extends State<TopUpInvestasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topUpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Investasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _topUpController,
                decoration: const InputDecoration(
                  labelText: 'Minimal Rp 10.000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah top-up tidak boleh kosong';
                  }
                  final topUpAmount = int.tryParse(value);
                  if (topUpAmount == null || topUpAmount < 10000) {
                    return 'Jumlah top-up minimal Rp 10.000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    double nominal =
                        double.tryParse(_topUpController.text) ?? 0.0;
                    final newTransaction = {
                      'name': 'Bibit',
                      'type': 'Pengeluaran',
                      'category': 'Investasi',
                      'amount': nominal,
                      'date': DateFormat('dd MMM yyyy, HH:mm')
                          .format(DateTime.now()),
                      'avatar': 'assets/images/logo-bibit.png',
                      'messageContent':
                          'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)} berhasil di transfer ke Bibit'
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Top Up Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
