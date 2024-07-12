import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Promosi extends StatefulWidget {
  const Promosi({super.key});

  @override
  State<Promosi> createState() => _PromosiState();
}

class _PromosiState extends State<Promosi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Promo"),
      ),
      body: ListView(
        children: [
          PromoCard(
            title: "Promo Pembelian Pulsa",
            description: "Dapatkan diskon hingga 10% untuk pembelian pulsa!",
            imagePath: 'assets/images/img_bi_phone.svg',
            onPressed: () {
              Navigator.pushNamed(context, '/pulsa');
            },
          ),
          PromoCard(
            title: "Promo Pembelian Game",
            description: "Beli game favoritmu dengan harga spesial!",
            imagePath: 'assets/images/img_ion_game_controller.svg',
            onPressed: () {
              Navigator.pushNamed(context, '/game');
            },
          ),
          PromoCard(
            title: "Promo Pembayaran Listrik",
            description: "Bayar tagihan listrikmu dan dapatkan cashback 5%!",
            imagePath: 'assets/images/img_flash_1.svg',
            onPressed: () {
              Navigator.pushNamed(context, '/listrik');
            },
          ),
          PromoCard(
            title: "Promo Pembelian Investasi",
            description: "Mulai investasi di waletin dan dapatkan bonus investasi!",
            imagePath: 'assets/images/img_shield_variant.svg',
            onPressed: () {
              Navigator.pushNamed(context, '/investasi');
            },
          ),
          PromoCard(
            title: "Promo Asuransi",
            description: "Dapatkan perlindungan lebih dengan promo asuransi terbaru!",
            imagePath: 'assets/images/img_umbrella_1.svg',
            onPressed: () {
              Navigator.pushNamed(context, '/asuransi');
            },
          ),
          PromoCard(
            title: "Promo BPJS Kesehatan",
            description: "Bayar tagihan BPJS Kesehatan dengan keuntungan ekstra!",
            imagePath: 'assets/images/img_healthy_living_1.svg',
            onPressed: () {
              Navigator.pushNamed(context, '/bpjs');
            },
          ),
        ],
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onPressed;

  const PromoCard({super.key, 
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SvgPicture.asset(imagePath),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
