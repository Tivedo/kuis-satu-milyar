class RegisterModel {
  String hp;
  String nama;

  RegisterModel({required this.nama, required this.hp});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      nama: json['nama'],
      hp: json['hp'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'hp': hp,
    };
  }
}