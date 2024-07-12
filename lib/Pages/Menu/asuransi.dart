import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/Menu/pembayaran_asuransi.dart';
import 'package:infoin_ewallet/Provider/asuransi.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';  

class Asuransi extends StatefulWidget {
  const Asuransi({super.key});

  @override
  State<Asuransi> createState() => _AsuransiState();
}

class _AsuransiState extends State<Asuransi> {
  final TextEditingController _searchController = TextEditingController();
  bool showPurchased = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterAsuransi);
  }

  void _filterAsuransi() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AsuransiProvider>(context);
    final filteredAsuransi = showPurchased
        ? provider.purchasedAsuransi.where((asuransi) {
            return asuransi['title'].toLowerCase().contains(_searchController.text.toLowerCase());
          }).toList()
        : provider.allAsuransi.where((asuransi) {
            return asuransi['title'].toLowerCase().contains(_searchController.text.toLowerCase());
          }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asuransi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              setState(() {
                showPurchased = !showPurchased;
                _filterAsuransi();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Asuransi',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAsuransi.length,
                itemBuilder: (context, index) {
                  var asuransi = filteredAsuransi[index];
                  return asuransiListTile(asuransi['title'], asuransi['icon'], asuransi['premiumAmount'], context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget asuransiListTile(String title, IconData icon, double premiumAmount, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 40,
        color: Colors.blueAccent,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Premi: ${NumberFormat('#', 'id_ID').format(double.parse(premiumAmount.toString()))}'),
      onTap: () {
        final provider = Provider.of<AsuransiProvider>(context, listen: false);
        if (provider.isAsuransiPurchased(title)) {
          final details = provider.getAsuransiDetails(title)!;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(details['title']),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    details['icon'],
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                  Text('Premi: Rp ${details['premiumAmount']}'),
                  Text('Tanggal Pembelian: ${details['purchaseDate']}'),
                  Text('Tanggal Berakhir: ${details['expiryDate']}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PembayaranAsuransi(
                title: title,
                premiumAmount: premiumAmount,
              ),
            ),
          );
        }
      },
    );
  }
}
