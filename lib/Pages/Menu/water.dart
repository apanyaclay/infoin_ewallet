import 'package:flutter/material.dart';
import 'confirm_air_bayar.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  late TextEditingController _billNumberController;
  late TextEditingController _nameController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String? _selectedProvider;
  final List<String> _providers = [
    'PDAM KAB. KISARAN',
    'PDAM KAB. NIAS',
    'PDAM KOTA BINJAI',
    'PDAM KOTA PEMATANG SIANTAR',
    'PDAM Kota Medan',
    'PDAM SIMALUNGUN',
    'PDAM TARUTUNG',
    'PDAM TIRTA BULIAN',
    'PDAM TIRTANADI',
    'PDAM TIRTAULI',
  ];

  @override
  void initState() {
    super.initState();
    _billNumberController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _billNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Implement payment submission logic here
      String billNumber = _billNumberController.text;
      String namaPelanggan = _nameController.text;
      String provider = _selectedProvider!;
      print(
          'Submitting payment for provider: $provider, bill number: $billNumber, customer name: $namaPelanggan');

      // Simulate a delay for the payment processing (e.g., API call)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Navigate to confirmation page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmAirBayarPage(
              idPelanggan: billNumber,
              namaPelanggan: namaPelanggan,
              provider: provider,
              nominalPembayaran: 50000, // Replace with actual payment amount
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagihan Air'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Penyedia',
                  border: OutlineInputBorder(),
                ),
                value: _selectedProvider,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProvider = newValue!;
                  });
                },
                items:
                    _providers.map<DropdownMenuItem<String>>((String provider) {
                  return DropdownMenuItem<String>(
                    value: provider,
                    child: Text(provider),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih penyedia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _billNumberController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Tagihan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor tagihan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama pelanggan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitPayment,
                      child: const Text('Kirim Pembayaran'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
