import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum DonationTarget { pantiAsuhan, mesjid, gereja, bencana }

class Donasi extends StatefulWidget {
  const Donasi({Key? key}) : super(key: key);

  @override
  State<Donasi> createState() => _DonasiState();
}

class _DonasiState extends State<Donasi> {
  final TextEditingController _nominalController = TextEditingController();
  DonationTarget _selectedTarget = DonationTarget.pantiAsuhan;
  String targetName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tujuan Donasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<DonationTarget>(
              value: _selectedTarget,
              onChanged: (DonationTarget? value) {
                setState(() {
                  _selectedTarget = value!;
                });
              },
              items: DonationTarget.values.map((DonationTarget target) {
                return DropdownMenuItem<DonationTarget>(
                  value: target,
                  child: Text(target == DonationTarget.pantiAsuhan
                      ? 'Panti Asuhan'
                      : target == DonationTarget.mesjid
                          ? 'Mesjid'
                          : target == DonationTarget.gereja
                              ? 'Gereja'
                              : 'Bencana'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nominal Donasi',
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
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  double nominal =
                      double.tryParse(_nominalController.text) ?? 0.0;
                  switch (_selectedTarget) {
                    case DonationTarget.pantiAsuhan:
                      targetName = 'Panti Asuhan';
                      break;
                    case DonationTarget.mesjid:
                      targetName = 'Mesjid';
                      break;
                    case DonationTarget.gereja:
                      targetName = 'Gereja';
                      break;
                    case DonationTarget.bencana:
                      targetName = 'Bencana';
                      break;
                  }
                  final amount = nominal;
                  final newTransaction = {
                    'name': 'Donasi ke $targetName',
                    'type': 'Pengeluaran',
                    'category': 'Donasi',
                    'amount': amount,
                    'date':
                        DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
                    'avatar': 'assets/images/logo-donasi.png',
                    'messageContent':
                        'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} untuk berdonasi ke $targetName'
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MetodePembayaran(transaction: newTransaction),
                    ),
                  );
                },
                child: const Text('Donasi Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
