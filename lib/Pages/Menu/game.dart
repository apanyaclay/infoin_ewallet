import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/metode_pembayaran.dart';
import 'package:intl/intl.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGame;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Pilih Game',
                  border: OutlineInputBorder(),
                ),
                value: selectedGame,
                items: const [
                  DropdownMenuItem(
                    value: 'Mobile Legends: Bang Bang',
                    child: Text('Mobile Legends: Bang Bang'),
                  ),
                  DropdownMenuItem(
                    value: 'Free Fire',
                    child: Text('Free Fire'),
                  ),
                  DropdownMenuItem(
                    value: 'PUBG Mobile',
                    child: Text('PUBG Mobile'),
                  ),
                  DropdownMenuItem(
                    value: 'Clash of Clans',
                    child: Text('Clash of Clans'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGame = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Silakan pilih game' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'User ID harus diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                decoration: const InputDecoration(
                  labelText: 'Nominal Top Up',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Nominal harus diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double nominal = double.tryParse(_nominalController.text) ?? 0.0;
                    final amount = nominal + 2000.0;
                    final newTransaction = {
                      'name': 'Top Up $selectedGame',
                      'type': 'Pengeluaran',
                      'category': 'Game',
                      'amount': amount,
                      'date': DateFormat('dd MMM yyyy, HH:mm')
                          .format(DateTime.now()),
                      'avatar': 'assets/images/logo-game.png',
                      'messageContent':
                          'Transaksi pengeluaran: Rp ${NumberFormat('#,##0', 'id_ID').format(amount)} berhasil top up game $selectedGame dengan ID ${_userIdController.text}'
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
                child: const Text('Top Up Sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
