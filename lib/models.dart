class User {
  final String? id;
  final String? username;
  final String? email;
  final String? role;

  User({this.id, this.username, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['uuid'],  // Sesuaikan dengan kunci yang ada di respons
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email, 'role': role};
  }
}


class LoginResponse {
  final bool status;
  final String message;
  final User? user;
  final String? accessToken;
  final String? uuid;

  LoginResponse({
    required this.status,
    required this.message,
    this.user,
    this.accessToken,
    this.uuid,
  });

  // Factory untuk membuat LoginResponse dari JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
  return LoginResponse(
    status: true,  // Karena server tidak mengembalikan status, set default ke true
    message: 'Login successful',  // Anda bisa mengganti ini sesuai kebutuhan
    user: User.fromJson(json),  // Langsung menggunakan json untuk User
    accessToken: json['accessToken'],  // Ambil accessToken langsung dari response
    uuid: json['uuid'],  // Ambil uuid langsung dari response
  );
}

  // Konversi LoginResponse ke JSON
  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'accessToken': accessToken, 'uuid': uuid};
  }
}

class Kelas {
  final int? id;
  final String? namaKelas;
  final int? kelas;

  Kelas({this.id, this.namaKelas, this.kelas});

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id'],
      namaKelas: json['namaKelas'],
      kelas: json['kelas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'namaKelas': namaKelas, 'kelas': kelas};
  }
}

class Profile {
  final int? id;
  final int? nis;
  final String? nama;
  final String? email;
  final Kelas? kelas;
  final String? gender;
  final int? umur;
  final String? alamat;
  final String? gayaBelajar;
  final int? persentaseVisual;
  final int? persentaseAuditori;
  final int? persentaseKinestetik;
  final String? image;
  final String? url;
  final User? user;

  Profile({
    this.id,
    this.nis,
    this.nama,
    this.email,
    this.kelas,
    this.gender,
    this.umur,
    this.alamat,
    this.gayaBelajar,
    this.persentaseVisual,
    this.persentaseAuditori,
    this.persentaseKinestetik,
    this.image,
    this.url,
    this.user,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      nis: json['nis'],
      nama: json['nama'],
      email: json['email'],
      kelas: Kelas.fromJson(json['kelas']),
      gender: json['gender'],
      umur: json['umur'],
      alamat: json['alamat'],
      gayaBelajar: json['gayaBelajar'],
      persentaseVisual: json['persentaseVisual'],
      persentaseAuditori: json['persentaseAuditori'],
      persentaseKinestetik: json['persentaseKinestetik'],
      image: json['image'],  // Ensure the key name matches the response
      url: json['url'],  // Ensure the key name matches the response
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nis': nis,
      'nama': nama,
      'email': email,
      'kelas': kelas?.toJson(),
      'gender': gender,
      'umur': umur,
      'alamat': alamat,
      'gayaBelajar': gayaBelajar,
      'persentaseVisual': persentaseVisual,
      'persentaseAuditori': persentaseAuditori,
      'persentaseKinestetik': persentaseKinestetik,
      'image': image,
      'url': url,
      'user': user?.toJson(),
    };
  }
}

class Pelajaran {
  final int? id;
  final String? pelajaran;

  Pelajaran({this.id, this.pelajaran});

  factory Pelajaran.fromJson(Map<String, dynamic> json) {
    return Pelajaran(
      id: json['id'],
      pelajaran: json['pelajaran'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pelajaran': pelajaran,
    };
  }
}

class NilaiSayaModel {
  final String? skor;
  final String? level;
  final int? jumlahSoal;
  final int? jumlahJawabanBenar;
  final Kelas? kelas;
  final Pelajaran? pelajaran;
  final String? updatedAt;

  NilaiSayaModel({
    this.skor,
    this.level,
    this.jumlahSoal,
    this.jumlahJawabanBenar,
    this.kelas,
    this.pelajaran,
    this.updatedAt,
  });

  factory NilaiSayaModel.fromJson(Map<String, dynamic> json) {
    return NilaiSayaModel(
      skor: json['skor'],
      level: json['level'],
      jumlahSoal: json['jumlahSoal'],
      jumlahJawabanBenar: json['jumlahJawabanBenar'],
      kelas: json['kelas'] != null ? Kelas.fromJson(json['kelas']) : null,
      pelajaran: json['pelajaran'] != null ? Pelajaran.fromJson(json['pelajaran']) : null,
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skor': skor,
      'level': level,
      'jumlahSoal': jumlahSoal,
      'jumlahJawabanBenar': jumlahJawabanBenar,
      'kelas': kelas?.toJson(),
      'pelajaran': pelajaran?.toJson(),
      'updatedAt': updatedAt,
    };
  }
}

class Soal {
  final int? id;
  final String? soal;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? optionE;
  final String? correctAnswer;
  final NilaiSoal? nilaiSoal;

  Soal({
    this.id,
    this.soal,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.optionE,
    this.correctAnswer,
    this.nilaiSoal,
  });

  factory Soal.fromJson(Map<String, dynamic> json) {
    return Soal(
      id: json['id'],
      soal: json['soal'],
      optionA: json['optionA'],
      optionB: json['optionB'],
      optionC: json['optionC'],
      optionD: json['optionD'],
      optionE: json['optionE'],
      correctAnswer: json['correctAnswer'],
      nilaiSoal: NilaiSoal.fromJson(json['nilai_soal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soal': soal,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'optionE': optionE,
      'correctAnswer': correctAnswer,
      'nilai_soal': nilaiSoal?.toJson(),
    };
  }
}

class NilaiSoal {
  final String? jawaban;
  final bool? benar;

  NilaiSoal({this.jawaban, this.benar});

  factory NilaiSoal.fromJson(Map<String, dynamic> json) {
    return NilaiSoal(
      jawaban: json['jawaban'],
      benar: json['benar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'jawaban': jawaban, 'benar': benar};
  }
}

