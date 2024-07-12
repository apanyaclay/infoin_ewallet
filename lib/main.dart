import 'package:flutter/material.dart';
import 'package:infoin_ewallet/Pages/Auth/login.dart';
import 'package:infoin_ewallet/Pages/Menu/asuransi.dart';
import 'package:infoin_ewallet/Pages/Menu/bpjs.dart';
import 'package:infoin_ewallet/Pages/Menu/donasi.dart';
import 'package:infoin_ewallet/Pages/Menu/game.dart';
import 'package:infoin_ewallet/Pages/Menu/investasi.dart';
import 'package:infoin_ewallet/Pages/Menu/listrik.dart';
import 'package:infoin_ewallet/Pages/Menu/pulsa.dart';
import 'package:infoin_ewallet/Pages/Menu/water.dart';
import 'package:infoin_ewallet/Pages/home.dart';
import 'package:infoin_ewallet/Pages/pesan.dart';
import 'package:infoin_ewallet/Pages/Profile/profile.dart';
import 'package:infoin_ewallet/Pages/riwayat.dart';
import 'package:infoin_ewallet/Provider/asuransi.dart';
import 'package:infoin_ewallet/Provider/dark_mode.dart';
import 'package:infoin_ewallet/Provider/kontak.dart';
import 'package:infoin_ewallet/Provider/transaksi.dart';
import 'package:infoin_ewallet/Provider/user_profile.dart';
import 'package:infoin_ewallet/Provider/wallet.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProfile()),
      ChangeNotifierProvider(create: (_) => WalletProvider()),
      ChangeNotifierProvider(create: (_) => TransaksiProvider()),
      ChangeNotifierProvider(create: (_) => DarkMode()),
      ChangeNotifierProvider(create: (_) => KontakProvider()),
      ChangeNotifierProvider(create: (_) => AsuransiProvider()),
    ],
    child: const MainApp(),
  ));
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  final Duration transitionDuration;
  final Curve curves;

  CustomPageTransitionsBuilder({required this.transitionDuration, required this.curves});

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curves,
      ),
      child: child,
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var tema = Provider.of<DarkMode>(context);
    final customPageTransitionsBuilder = CustomPageTransitionsBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      curves: Curves.ease,
    );
    final pageTransitionsTheme = PageTransitionsTheme(builders: {
      TargetPlatform.android: customPageTransitionsBuilder,
    });

    final newThemeData = tema.enableDarkMode ? tema.dark.copyWith(pageTransitionsTheme: pageTransitionsTheme)
                                              : tema.light.copyWith(pageTransitionsTheme: pageTransitionsTheme);

   
    return MaterialApp(
      title: "Infoin_E-Wallet",
      theme: newThemeData,
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/riwayat': (context) => const Riwayat(),
        '/profile': (context) => const Profile(),
        '/pesan': (context) => const Pesan(),
        '/pulsa': (context) => const Pulsa(),
        '/water': (context) => const Water(),
        '/asuransi': (context) => const Asuransi(),
        '/bpjs': (context) => const BPJS(),
        '/donasi': (context) => const Donasi(),
        '/game': (context) => const Game(),
        '/investasi': (context) => const Investasi(),
        '/listrik': (context) => const Listrik(),
      },
    );
  }
}