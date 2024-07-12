import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:intl/intl.dart';

class BPJS extends StatefulWidget {
  const BPJS({super.key});

  @override
  State<BPJS> createState() => _BPJSState();
}

class _BPJSState extends State<BPJS> {
  final _formKey = GlobalKey<FormState>();
  final _idPelangganController = TextEditingController();
  bool _showBill = false;
  double _billAmount = 0.0;

  @override
  void dispose() {
    _idPelangganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saldoFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // AppBar background color
        title: const Text('BPJS Kesehatan'),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: _idPelangganController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID Pelanggan',
                hintText: 'cth: 081313',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harap masukkan ID Pelanggan';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (!_showBill)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _billAmount = 150000;
                        _showBill = true;
                      });
                    }
                  },
                  child: const Text('Cek Tagihan'),
                ),
              ),
            if (_showBill) ...[
              const SizedBox(height: 20),
              Text(
                'Jumlah Tagihan:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                saldoFormat.format(_billAmount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final amount = _billAmount + 3000.0;
                      final newTransaction = {
                        'name': 'Tagihan BPJS',
                        'type': 'Pengeluaran',
                        'category': 'BPJS',
                        'amount': amount,
                        'date': DateFormat('dd MMM yyyy, HH:mm')
                            .format(DateTime.now()),
                        'avatar': 'assets/images/logo-bpjs.png',
                        'messageContent':
                            'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} berhasil membayar tagihan BPJS'
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MetodePembayaran(transaction: newTransaction),
                        ),
                      );
                    }
                  },
                  child: const Text('Bayar'),
                ),
              ),
            ]
          ],
        ),
      ),
    )
    );
  }
}