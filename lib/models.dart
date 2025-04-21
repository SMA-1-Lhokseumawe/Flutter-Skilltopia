import 'dart:ffi';

class User {
  final String? id;
  final String? username;
  final String? email;
  final String? role;

  User({this.id, this.username, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['uuid'], // Sesuaikan dengan kunci yang ada di respons
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
      status:
          true, // Karena server tidak mengembalikan status, set default ke true
      message: 'Login successful', // Anda bisa mengganti ini sesuai kebutuhan
      user: User.fromJson(json), // Langsung menggunakan json untuk User
      accessToken:
          json['accessToken'], // Ambil accessToken langsung dari response
      uuid: json['uuid'], // Ambil uuid langsung dari response
    );
  }

  // Konversi LoginResponse ke JSON
  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'accessToken': accessToken, 'uuid': uuid};
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
      image: json['image'],
      url: json['url'],
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

class Pelajaran {
  final int? id;
  final String? pelajaran;

  Pelajaran({this.id, this.pelajaran});

  factory Pelajaran.fromJson(Map<String, dynamic> json) {
    return Pelajaran(id: json['id'], pelajaran: json['pelajaran']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'pelajaran': pelajaran};
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
      pelajaran:
          json['pelajaran'] != null
              ? Pelajaran.fromJson(json['pelajaran'])
              : null,
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

class SoalModel {
  final int? id;
  final String? soal;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? optionE;
  final String? correctAnswer;

  SoalModel({
    this.id,
    this.soal,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.optionE,
    this.correctAnswer,
  });

  factory SoalModel.fromJson(Map<String, dynamic> json) {
    return SoalModel(
      id: json['id'],
      soal: json['soal'],
      optionA: json['optionA'],
      optionB: json['optionB'],
      optionC: json['optionC'],
      optionD: json['optionD'],
      optionE: json['optionE'],
      correctAnswer: json['correctAnswer'],
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
    };
  }
}

class NilaiSoal {
  final String? jawaban;
  final bool? benar;

  NilaiSoal({this.jawaban, this.benar});

  factory NilaiSoal.fromJson(Map<String, dynamic> json) {
    return NilaiSoal(jawaban: json['jawaban'], benar: json['benar']);
  }

  Map<String, dynamic> toJson() {
    return {'jawaban': jawaban, 'benar': benar};
  }
}

class NotifikasiModel {
  final int? id;
  final String? content;
  final String? urlImageProfile;
  bool? isRead;
  final int? postId;
  final String? createdAt;

  NotifikasiModel({
    this.id,
    this.content,
    this.urlImageProfile,
    this.isRead,
    this.postId,
    this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id'],
      content: json['content'],
      urlImageProfile: json['urlImageProfile'],
      isRead: json['isRead'] ?? false,
      postId: json['postId'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'urlImageProfile': urlImageProfile,
      'isRead': isRead,
      'postId': postId,
      'createdAt': createdAt,
    };
  }
}

class ModulModel {
  final int id;
  final String? judul;
  final String? deskripsi;
  final String? durasi;
  final int? kelasId;
  final int? pelajaranId;
  final Kelas? kelas;
  final Pelajaran? pelajaran;
  final String? type;
  final String? createdAt;

  ModulModel({
    required this.id,
    this.judul,
    this.deskripsi,
    this.durasi,
    this.kelasId,
    this.pelajaranId,
    this.kelas,
    this.pelajaran,
    this.type,
    this.createdAt,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      durasi: json['durasi'],
      kelasId: json['kelasId'],
      pelajaranId: json['pelajaranId'],
      kelas: json['kelas'] != null ? Kelas.fromJson(json['kelas']) : null,
      pelajaran:
          json['pelajaran'] != null
              ? Pelajaran.fromJson(json['pelajaran'])
              : null,
      type: json['type'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'durasi': durasi,
      'kelasId': kelasId,
      'pelajaranId': pelajaranId,
      'kelas': kelas,
      'pelajaran': pelajaran,
      'type': type,
      'createdAt': createdAt,
    };
  }
}

class SubModulModel {
  final int? id;
  final String subJudul;
  final String subDeskripsi;
  final String content;
  final String? audio;
  final String? video;

  SubModulModel({
    this.id,
    required this.subJudul,
    required this.subDeskripsi,
    required this.content,
    this.audio,
    this.video,
  });

  factory SubModulModel.fromJson(Map<String, dynamic> json) {
    return SubModulModel(
      id: json['id'],
      subJudul: json['subJudul'],
      subDeskripsi: json['subDeskripsi'],
      content: json['content'],
      audio: json['audio'],
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subJudul': subJudul,
      'subDeskripsi': subDeskripsi,
      'content': content,
      'audio': audio,
      'video': video,
    };
  }
}
