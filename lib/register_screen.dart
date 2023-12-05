import 'package:flutter/material.dart';
import 'component/join_button.dart';
import 'component/text_field.dart';
import 'package:mongo_dart/mongo_dart.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({required this.callLogin, super.key});

  final Function(String) callLogin;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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
      await db.collection('user').insertOne({'nama': nama, 'hp': hp});
    } catch (e) {
      print('Error inserting data to MongoDB: $e');
    } finally {
      await db.close();
      callLogin('pin-screen');
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
}
