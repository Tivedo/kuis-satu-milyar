import 'package:flutter/material.dart';
import 'component/join_button.dart';
import 'component/text_field.dart';
import 'package:mongo_dart/mongo_dart.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({required this.callback, super.key});

  final Function(String) callback;
  final TextEditingController _namaPemainController = TextEditingController();
  final TextEditingController _noHandphoneController = TextEditingController();
  void _registerAcount() {
    String namaPemain = _namaPemainController.text;
    String noHandphone = _noHandphoneController.text;
    insertDataToMongo(namaPemain, noHandphone);
  }

  Future<void> insertDataToMongo(String nama, String hp) async {
    const String mongoDbUri =
        'mongodb+srv://abiyyu:abiyyu@cluster0.mpwnlym.mongodb.net/kuis?retryWrites=true&w=majority';
    var db = await Db.create(mongoDbUri);

    try {
      await db.open();
      await db.collection('user').find({'name': nama, 'rating': hp}).toList();
    } catch (e) {
      print(e);
    } finally {
      await db.close();
      callback('pin-screen');
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
            'Masuk',
            style: TextStyle(
                color: Colors.purple,
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
}
