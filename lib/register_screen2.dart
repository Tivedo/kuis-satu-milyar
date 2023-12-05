import 'package:flutter/material.dart';
import 'component/join_button.dart';
import 'component/text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({required this.callback, super.key});

  final Function(String) callback;

  @override
  State<RegisterScreen2> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen2> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _namaPemainController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();
  int user = 0;

  void _registerAcount() {
    String namaPemain = _namaPemainController.text;
    String noHandphone = _noHandphoneController.text;
    if (namaPemain == '') {
      showAlertDialog(context, 'Nama harus diisi');
    }
    if (noHandphone == '') {
      showAlertDialog(context, 'Nomor handphone harus diisi');
    }
    if (noHandphone == '' && namaPemain == '') {
      showAlertDialog(context, 'Nama dan Nomor handphone harus diisi');
    } else {
      Future<List<dynamic>> fetchUser() async {
        final response = await http.get(Uri.parse(
            'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/get_user_by_nama?nama=$namaPemain'));

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load data');
        }
      }

      fetchUser().then((value) {
        setState(() {
          user = value.length;
        });
        createData(namaPemain, noHandphone);
      }).catchError((error) {});
    }
  }

  Future<void> createData(String nama, String hp) async {
    if (user == 0) {
      final response = await http.post(
        Uri.parse(
            'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/insert_user?nama=$nama&hp=$hp'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        saveRegistrationData();
        widget.callback(nama);
      } else {}
    } else {
      showAlertDialog(context, 'Nama sudah dipakai, Silakan coba lagi.');
    }
  }

  Future<void> saveRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('status', 'true');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/screen2.png"), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Daftar',
            style: TextStyle(
                color: Colors.red,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none),
          ),
          const SizedBox(height: 20),
          InputText(hintText: 'Nama Pemain', controller: _namaPemainController),
          const SizedBox(height: 20),
          InputText(
              hintText: 'Nomor Handphone', controller: _noHandphoneController),
          const SizedBox(height: 40),
          JoinButton(buttonText: 'OK', onPressed: _registerAcount),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    ));
  }

  void showAlertDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup pop-up dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
