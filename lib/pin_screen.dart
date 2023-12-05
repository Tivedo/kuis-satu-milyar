import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'component/join_button.dart';
import 'component/text_field.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({required this.callback, super.key});

  final Function(String) callback;

  @override
  State<PinScreen> createState() {
    return _PinScreenState();
  }
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  int validate = 0;

  void _registerAcount() {
    String pin = _pinController.text;
    if (pin == '') {
      showAlertDialog(context, 'Pin Harus diisi');
    } else {
      Future<List<dynamic>> fetchPin() async {
        final response = await http.get(Uri.parse(
            'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/get_pin_by_pin?pin=$pin'));

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load data');
        }
      }

      fetchPin().then((value) {
        setState(() {
          validate = value.length;
        });
        if(validate == 0){
          showAlertDialog(context, 'Pin salah, silahkan coba lagi!');
        }else{
          widget.callback('question-screen');
        }   
      }).catchError((error) {});
    }
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
            'PIN',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none),
          ),
          const SizedBox(height: 20),
          InputText(hintText: 'PIN', controller: _pinController),
          const SizedBox(height: 80),
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
