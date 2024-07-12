import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoin_ewallet/Provider/user_profile.dart';
import 'package:provider/provider.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  late String _name;
  late String _email;
  late int _phoneNumber;

  @override
  void initState() {
    super.initState();
    var userProfile = Provider.of<UserProfile>(context, listen: false);
    _name = userProfile.name ?? '';
    _email = userProfile.email ?? '';
    _phoneNumber = userProfile.phoneNumber ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<UserProfile>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  userProfile.avatarImage = File(pickedFile.path);
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: userProfile.avatarImage != null
                    ? FileImage(userProfile.avatarImage!)
                    : const AssetImage('assets/images/img_ellipse_17.png')
                        as ImageProvider<Object>,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: _phoneNumber.toString(),
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) {
                setState(() {
                  _phoneNumber = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  userProfile.name = _name;
                  userProfile.email = _email;
                  userProfile.phoneNumber = _phoneNumber;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Information updated successfully'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {
                          // Optional: Bisa melakukan sesuatu ketika tombol OK diklik
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
