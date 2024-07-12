import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/bayar.dart';
import 'package:infoin_ewallet/Pages/promo.dart';
import 'package:infoin_ewallet/Pages/transfer.dart';
import 'package:infoin_ewallet/Pages/topup.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:infoin_ewallet/Widget/bottom_navigation.dart';
import 'package:infoin_ewallet/Widget/home_menu_item.dart';
import 'package:infoin_ewallet/Widget/menu_item_btt.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _currentAdIndex = 0;
  final List<String> _advertisementImages = [
    'assets/images/img_rectangle_4.png',
    'assets/images/ads2.jpeg',
    'assets/images/ads3.png',
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentAdIndex = (_currentAdIndex + 1) % _advertisementImages.length;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/pesan');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      default:
        throw Exception('Invalid index');
    }
  }

  @override
  Widget build(BuildContext context) {
    var wallet = Provider.of<WalletProvider>(context);
    final saldoFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waletin'),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('assets/images/wallet_logo.png',fit: BoxFit.contain,),
          
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(204, 250, 19, 2),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Center(
                              child: Image.asset(
                            'assets/images/img_image_1.png',
                            height: 50,
                            alignment: Alignment.centerLeft,
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            const Text("Saldo", style: TextStyle(color: Colors.white, fontSize: 15)),
                            const SizedBox(height: 10),
                            Text(
                              saldoFormat.format(wallet.balance ?? 0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        MenuItemBTT(svgPath: 'assets/images/img_bx_bx_scan.svg', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Bayar()),
                          );
                        },),
                        MenuItemBTT(svgPath: 'assets/images/img_transaction_1.svg', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Transfer()),
                          );
                        },),
                        MenuItemBTT(svgPath: 'assets/images/img_mdi_wallet_plus_outline.svg', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TopUp()),
                          );
                        },),
                      ],
                    ),
                    Row(
                      children: [
                        MenuItemBTT(
                          text: 'Bayar',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Bayar()),
                            );
                          },
                        ),
                        MenuItemBTT(
                          text: 'Transfer',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Transfer()),
                            );
                          },
                        ),
                        MenuItemBTT(
                          text: 'Top Up',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TopUp()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 55),
                    const Row(
                      children: [
                        CustomMenuItem(
                          routeName: '/pulsa',
                          imagePath: 'assets/images/img_bi_phone.svg',
                          text: 'Pulsa',
                          isSvg: true,
                        ),
                        Spacer(),
                        CustomMenuItem(
                          routeName: '/water',
                          imagePath: 'assets/images/water.png',
                          text: 'Water',
                        ),
                        Spacer(),
                        CustomMenuItem(
                          routeName: '/listrik',
                          imagePath: 'assets/images/img_flash_1.svg',
                          text: 'Listrik',
                          isSvg: true,
                        ),
                        Spacer(),
                        CustomMenuItem(
                          routeName: '/game',
                          imagePath: 'assets/images/img_ion_game_controller.svg',
                          text: 'Game',
                          isSvg: true,
                        ),
                        Spacer(),
                        CustomMenuItem(
                          routeName: '/donasi',
                          imagePath: 'assets/images/img_mdi_charity.svg',
                          text: 'Donasi',
                          isSvg: true,
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        const CustomMenuItem(
                          routeName: '/asuransi',
                          imagePath: 'assets/images/img_umbrella_1.svg',
                          text: 'Asuransi',
                          isSvg: true,
                        ),
                        const Spacer(),
                        const CustomMenuItem(
                          routeName: '/investasi',
                          imagePath: 'assets/images/img_shield_variant.svg',
                          text: 'Investasi',
                          isSvg: true,
                        ),
                        const Spacer(),
                        const CustomMenuItem(
                          routeName: '/bpjs',
                          imagePath: 'assets/images/img_healthy_living_1.svg',
                          text: 'BPJS',
                          isSvg: true,
                        ),
                        const Spacer(),
                        const CustomMenuItem(
                          routeName: '/home',
                          imagePath: 'assets/images/img_dashboard_2.svg',
                          text: 'Lainnya',
                          isSvg: true,
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        _advertisementImages[_currentAdIndex],
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Promosi()));
        },
        tooltip: 'Promosi',
        child: Image.asset('assets/images/promosi.png'),),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
