import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/Menu/topup_inves.dart';
import 'package:infoin_ewallet/Pages/pin.dart';
import 'package:infoin_ewallet/Pages/transaksi_sukses.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:infoin_ewallet/Provider/user_profile.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Investasi extends StatefulWidget {
  const Investasi({super.key});

  @override
  State<Investasi> createState() => _InvestasiState();
}

class _InvestasiState extends State<Investasi> {
  // Simulasi data investasi
  double imbalHasilSatuTahun = 4.5; // 4.5%
  double imbalHasilSatuHari = 0.045;
  double calculateTotalImbalHasil(portofolio, double imbalHasilSatuTahun) {
    return portofolio * (imbalHasilSatuTahun / 100);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = Provider.of<UserProfile>(context, listen: false);
      double portofolio = user.portofolio ?? 0;
      double totalINilaiPortofoli = calculateDailyImbalHasil(portofolio);
      user.increaseNilaiPortofolio(totalINilaiPortofoli);
      setState(() {});
    });
  }

  double calculateDailyImbalHasil(double portofolio) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    double totalImbalHasil = 0;

    // Iterate through each transaction to calculate the imbal hasil
    for (var transaction
        in Provider.of<TransaksiProvider>(context, listen: false)
            .transactions) {
      if (transaction['category'] == 'Investasi') {
        DateTime transactionDate = dateFormat.parse(transaction['date']);
        int daysDifference = DateTime.now().difference(transactionDate).inDays;

        // Calculate daily imbal hasil
        double dailyImbalHasil =
            portofolio * (imbalHasilSatuTahun / 100 / 365) * daysDifference;
        totalImbalHasil += dailyImbalHasil;
      }
    }
    return totalImbalHasil;
  }

  void _transfer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PinDialog(
          onPinEntered: () {
            Navigator.of(context).pop();
            _prosesTransfer();
          },
        );
      },
    );
  }

  void _prosesTransfer() {
    var user = Provider.of<UserProfile>(context, listen: false);
    double portofolio = user.portofolio ?? 0;
    double nilaiPortofolio = user.nilaiPortofolio ?? 0;
    double nominal = portofolio + nilaiPortofolio;
    bool success = Provider.of<WalletProvider>(context, listen: false)
        .increaseBalance(nominal);
    var userProfile = Provider.of<UserProfile>(context, listen: false);
    if (success) {
      userProfile.resetNilaiPortofolio();
      userProfile.resetPortofolio();
      Map<String, dynamic> newTransaction = {
        'name': 'Penjualan Investasi',
        'type': 'Pemasukan',
        'category': 'Investasi',
        'amount': 'Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)}',
        'date': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
        'avatar': 'assets/images/logo-bibit.png',
        'messageContent': 'Transaksi pemasukan: Rp ${NumberFormat('#,##0', 'id_ID').format(nominal)} berhasil masuk dari Penjualan Investasi'
      };
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
            builder: (context) =>
                TransactionSuccessPage(transactionData: newTransaction),
          ),
        ).catchError((e) {
          print('Error navigating to TransactionSuccessPage: $e');
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi gagal. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProfile>(context);
    double portofolio = user.portofolio ?? 0;
    double nilaiPortofolio = user.nilaiPortofolio ?? 0;
    double totalImbalHasil =
        calculateTotalImbalHasil(portofolio, imbalHasilSatuTahun);
    double totalNilaiPortofolio = portofolio + nilaiPortofolio;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investasi Cerdas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nilai Portofolio',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                          ).format(totalNilaiPortofolio),
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${imbalHasilSatuTahun}%',
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Imbal Hasil 1 Tahun Terakhir*',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              child: const VerticalDivider(),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(NumberFormat.currency(
                                          locale: 'id_ID', symbol: 'Rp ')
                                      .format(totalImbalHasil)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Total Imbal Hasil',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TopUpInvestasi()));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: const Text('Top Up Sekarang')),
                        ),
                        const SizedBox(height: 10),
                        if (portofolio > 0)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: _transfer,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                ),
                                child: const Text('Jual')),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TentangInvestasiPintar(),
            ],
          ),
        ),
      ),
    );
  }
}

class TentangInvestasiPintar extends StatelessWidget {
  const TentangInvestasiPintar({super.key});
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Tentang Investasi Cerdas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Apa Itu Investasi Cerdas?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Investasi Cerdas adalah platform investasi bagi pengguna E-Wallet untuk berinvestasi secara mudah dan aman. Investasi Cerdas merupakan hasil kerjasama antara E-Wallet dengan Agen Penjual Reksa Dana (APERD) online yang telah terdaftar dan diawasi oleh OJK, yaitu PT Bibit Tumbuh Bersama (Bibit).',
            ),
            SizedBox(height: 10),
            Text(
              'Produk Investasi Apa Yang Ditawarkan?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Produk investasi yang ditawarkan dalam platform Investasi Cerdas merupakan produk Reksa Dana Pasar Uang. Pengguna dapat mulai berinvestasi dengan nominal kecil dan menikmati kemudahan bertransaksi melalui aplikasi E-Wallet.',
            ),
          ],
        ),
      ),
    );
  }
}
