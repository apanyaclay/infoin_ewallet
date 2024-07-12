import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:intl/intl.dart';

class Listrik extends StatefulWidget {
  const Listrik({super.key});

  @override
  State<Listrik> createState() => _ListrikState();
}

class _ListrikState extends State<Listrik> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listrik'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pascabayar'),
            Tab(text: 'Prabayar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PascabayarScreen(),
          PrabayarScreen(),
        ],
      ),
    );
  }
}

class PascabayarScreen extends StatefulWidget {
  @override
  _PascabayarScreenState createState() => _PascabayarScreenState();
}

class _PascabayarScreenState extends State<PascabayarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idPelangganController = TextEditingController();
  bool _showBill = false;
  double _billAmount = 0.0;
  final String _namaPenerima = 'PLN';

  @override
  void dispose() {
    _idPelangganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saldoFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Padding(
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
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final amount = _billAmount + 3000.0;
                      final newTransaction = {
                        'name': 'Listrik Pascabayar',
                        'type': 'Pengeluaran',
                        'category': 'Listrik',
                        'amount': amount,
                        'date': DateFormat('dd MMM yyyy, HH:mm')
                            .format(DateTime.now()),
                        'avatar': 'assets/images/logo-listrik.png',
                        'messageContent':
                            'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} berhasil di transfer ke $_namaPenerima'
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
    );
  }
}

class PrabayarScreen extends StatefulWidget {
  @override
  _PrabayarScreenState createState() => _PrabayarScreenState();
}

class _PrabayarScreenState extends State<PrabayarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idPelangganController = TextEditingController();
  bool _showNominals = false;
  String _selectedNominal = '20.000';
  final String _namaPenerima = 'PLN';

  final List<String> _nominals = [
    '20000',
    '50000',
    '100000',
    '200000',
    '500000',
    '1000000'
  ];

  @override
  void dispose() {
    _idPelangganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            if (_showNominals == false)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _showNominals = true;
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            if (_showNominals) ...[
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _nominals.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedNominal = _nominals[index];
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedNominal == _nominals[index]
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Rp${NumberFormat('#', 'id_ID').format(double.parse(_nominals[index]))}',
                          style: TextStyle(
                            color: _selectedNominal == _nominals[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final nominal = double.parse(_selectedNominal);
                      final amount = nominal+3000.0;
                      final newTransaction = {
                        'name': 'Listrik Prabayar',
                        'type': 'Pengeluaran',
                        'category': 'Listrik',
                        'amount': amount,
                        'date': DateFormat('dd MMM yyyy, HH:mm')
                            .format(DateTime.now()),
                        'avatar': 'assets/images/logo-listrik.png',
                        'messageContent':
                            'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)} berhasil di transfer ke $_namaPenerima'
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
    );
  }
}
