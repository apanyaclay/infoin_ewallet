import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoin_ewallet/Provider/user_profile.dart';
import 'package:mnc_identifier_ocr/mnc_identifier_ocr.dart';
import 'package:mnc_identifier_ocr/model/ocr_result_model.dart';
import 'package:provider/provider.dart';

class VersiKTP extends StatefulWidget {
  const VersiKTP({super.key});

  @override
  State<VersiKTP> createState() => _VersiKTPState();
}

class _VersiKTPState extends State<VersiKTP> {
  OcrResultModel? result;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanKtp() async {
    OcrResultModel? res;
    try {
      res = await MncIdentifierOcr.startCaptureKtp(
          withFlash: true, cameraOnly: true);
    } catch (e) {
      debugPrint('something goes wrong $e');
    }

    if (!mounted) return;

    setState(() {
      result = res;
    });
  }

  _imgGlr() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    debugPrint('path: ${image?.path}');
  }

  _imgCmr() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    debugPrint('path: ${image?.path}');
  }

  void _verifyKtp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verifikasi KTP'),
          content:
              const Text('Apakah Anda yakin ingin melakukan verifikasi KTP?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  Provider.of<UserProfile>(context).verifikasi = true;
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                });
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Versi KTP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result?.isSuccess == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data KTP:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (result?.imagePath != null)
                    Image.file(File(result!.imagePath!)),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: result?.ktp?.nama ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.tempatLahir ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Tempat Lahir',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.golDarah ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Golongan Darah',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.tglLahir ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.jenisKelamin ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.alamat ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.rt ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'RT',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.rw ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'RW',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.kelurahan ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Kelurahan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.kecamatan ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Kecamatan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.agama ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Agama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue:
                        result?.ktp?.statusPerkawinan ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Status Perkawinan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.pekerjaan ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Pekerjaan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue:
                        result?.ktp?.kewarganegaraan ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Kewarganegaraan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue:
                        result?.ktp?.berlakuHingga ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Berlaku Hingga',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.provinsi ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Provinsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: result?.ktp?.kabKot ?? 'Tidak Tersedia',
                    decoration: const InputDecoration(
                      labelText: 'Kabupaten/Kota',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _verifyKtp,
                        child: const Text('VERIFIKASI KTP')),
                  ),
                ],
              ),
            if (result?.isSuccess == false || result?.isSuccess == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: scanKtp, child: const Text('PUSH HERE')),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
