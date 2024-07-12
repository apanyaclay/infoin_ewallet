import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:intl/intl.dart';

class Pulsa extends StatefulWidget {
  const Pulsa({Key? key}) : super(key: key);

  @override
  State<Pulsa> createState() => _PulsaState();
}

class _PulsaState extends State<Pulsa> {
  String _selectedNominal = '5.000';

  final List<String> _nominals = [
    '5000',
    '10000',
    '15000',
    '20000',
    '25000',
    '50000',
    '100000'
  ];

  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembelian Pulsa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                hintText: 'Masukkan nomor HP',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Nominal Pulsa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: _nominals.map((String nominal) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedNominal = nominal;
                      });
                    },
                    child: Card(
                      color: _selectedNominal == nominal
                          ? Colors.blue
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Rp${NumberFormat('#', 'id_ID').format(double.parse(nominal))}',
                            style: TextStyle(
                              fontSize: 18,
                              color: _selectedNominal == nominal
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = _phoneNumberController.text;
                String selectedNominal = _selectedNominal;
                double nominal = double.tryParse(selectedNominal) ?? 0.0;
                final amount = nominal + 2000.0;
                final newTransaction = {
                  'name': 'Isi Pulsa',
                  'type': 'Pengeluaran',
                  'category': 'Pulsa',
                  'amount': amount,
                  'date':
                      DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
                  'avatar': 'assets/images/logo-pulsa.png',
                  'messageContent':
                      'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} berhasil isi pulsa ke nomor ${phoneNumber}'
                };
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MetodePembayaran(transaction: newTransaction),
                  ),
                );
              },
              child: const Text('Beli Pulsa'),
            ),
          ],
        ),
      ),
    );
  }
}
