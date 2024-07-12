import 'package:flutter/material.dart';
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
  bool _isNominalValid = false;

  void _validateNominal(String value) {
    setState(() {
      _isNominalValid = value.isNotEmpty;
    });
  }

  void _donate() {
    if (!_isNominalValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi nominal terlebih dahulu')),
      );
      return;
    }

    double nominal = double.tryParse(_nominalController.text) ?? 0.0;
    String targetName = '';
    IconData icon = Icons.home;

    switch (_selectedTarget) {
      case DonationTarget.pantiAsuhan:
        targetName = 'Panti Asuhan';
        icon = Icons.home;
        break;
      case DonationTarget.mesjid:
        targetName = 'Mesjid';
        icon = Icons.mosque;
        break;
      case DonationTarget.gereja:
        targetName = 'Gereja';
        icon = Icons.church;
        break;
      case DonationTarget.bencana:
        targetName = 'Bencana';
        icon = Icons.warning;
        break;
    }

    Map<String, dynamic> newTransaction = {
      'name': targetName,
      'type': 'Pengeluaran',
      'category': 'Donasi',
      'amount': 'Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)}',
      'date': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
      'avatar': 'assets/images/logo-${targetName.toLowerCase()}.png'
    };

    Provider.of<TransaksiProvider>(context, listen: false).addTransaction(newTransaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donasi sebesar Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)} untuk $targetName berhasil')),
    );

    Navigator.pushReplacementNamed(context, '/riwayat');
  }

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
                  child: Text(target == DonationTarget.pantiAsuhan ? 'Panti Asuhan' : target == DonationTarget.mesjid ? 'Mesjid' : target == DonationTarget.gereja ? 'Gereja' : 'Bencana'),
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
              onChanged: _validateNominal,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isNominalValid ? _donate : null,
                child: const Text('Donasi Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}