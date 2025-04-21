import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:skilltopia/models.dart';
import 'package:skilltopia/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserRepository {
  Future<LoginResponse> loginUser(String username, String password) async {
    final url = Uri.parse("${AppConstants.baseUrl}/login");

    try {
      final body = jsonEncode({"username": username, "password": password});

      final headers = {"Content-Type": "application/json"};

      final response = await http.post(url, headers: headers, body: body);

      print("Request Body: $body");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Jika status code 200, artinya login berhasil
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        // Menangani status code 400 (Bad Request)
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse(
          status: false,
          message: responseData['msg'] ?? 'Unknown error',
        );
      } else if (response.statusCode == 404) {
        // Menangani status code 405 (Method Not Allowed)
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse(
          status: false,
          message: responseData['msg'] ?? 'Unknown error',
        );
      } else {
        // Untuk status code lainnya
        return LoginResponse(
          status: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (error) {
      print("Error: $error");
      return LoginResponse(
        status: false,
        message: "Error: ${error.toString()}",
      );
    }
  }

  Future<bool> logoutUser(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/logout");

    try {
      final response = await http.delete(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['msg'] == "Anda telah logout";
      } else {
        return false; // Logout gagal
      }
    } catch (error) {
      print("Error during logout: $error");
      return false;
    }
  }

  Future<Map<String, dynamic>> getProfile(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/profile-siswa");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      // Ensure you're properly parsing the response
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody; // This should return the profile data correctly
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String accessToken,
    int? id,
    required Map<String, dynamic> profileData,
    File? imageFile,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/siswa/$id");
    final request = http.MultipartRequest('PATCH', url);

    // Add Authorization header
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Add profile data to request fields
    profileData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add the image file if present
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = await response.stream.bytesToString();
        final responseJson = jsonDecode(responseBody);

        // Log the imagePath
        print("Image Path: ${responseJson['imagePath']}");

        return {
          'status': responseJson['status'] ?? true,
          'msg': responseJson['msg'] ?? 'Update berhasil',
          'imagePath': responseJson['imagePath'], // Return the imagePath
        };
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Error updating profile: $responseBody");
        return {'status': false, 'message': 'Update failed', 'imagePath': null};
      }
    } catch (e) {
      print("Exception occurred: $e");
      return {
        'status': false,
        'message': 'Exception occurred',
        'imagePath': null,
      };
    }
  }

  Future<Map<String, dynamic>> updatePassword(String accessToken, String oldPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      return {
        'status': false,
        'message': 'Password baru dan konfirmasi password tidak cocok',
      };
    }
    
    final url = Uri.parse("${AppConstants.baseUrl}/change-password");

    try {
      final body = jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confNewPassword": confirmPassword,
      });

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      };

      final response = await http.patch(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return {
          'status': true,
          'message': 'Password berhasil diperbarui',
        };
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'status': false,
          'message': responseData['msg'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Terjadi kesalahan jaringan',
      };
    }
  }
}

class NilaiSayaRepository {
  Future<List<NilaiSayaModel>> getNilaiSaya(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/nilai");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        // Memetakan setiap data JSON ke objek NilaiSaya
        return responseBody
            .map((data) => NilaiSayaModel.fromJson(data))
            .toList(); // Mengembalikan List<NilaiSaya>
      } else {
        throw Exception('Failed to load Nilai saya');
      }
    } catch (error) {
      rethrow; // Mengembalikan error yang terjadi
    }
  }

  Future<Map<String, dynamic>> submitQuiz({
    required String accessToken,
    required List<dynamic> questions,
    required Map<dynamic, dynamic> userAnswers,
    required Map<String, dynamic> groupData,
    required int? siswaId,
  }) async {
    // Calculate score
    int score = 0;
    final totalQuestions = questions.length;
    
    // Collect soalIds
    final soalIds = questions.map((q) => q['id']).toList();
    
    // Count correct answers
    questions.forEach((q) {
      if (userAnswers[q['id']] == q['correctAnswer']) {
        score++;
      }
    });
    
    // Calculate percentage
    final percentage = ((score / totalQuestions) * 100).round();
    
    // Determine level
    String level = "Low";
    if (percentage > 66.66) {
      level = "High";
    } else if (percentage > 33.33) {
      level = "Medium";
    }
    
    // Create detailed answers
    final detailedAnswers = questions.map((q) => {
      'soalId': q['id'],
      'jawaban': userAnswers[q['id']] ?? null,
      'benar': userAnswers[q['id']] == q['correctAnswer']
    }).toList();
    
    // Prepare quiz result data
    final quizResultData = {
      'skor': percentage,
      'level': level,
      'jumlahSoal': totalQuestions,
      'jumlahJawabanBenar': score,
      'pelajaranId': groupData['item']['pelajaran']['id'],
      'kelasId': groupData['item']['kelas']['id'],
      'siswaId': siswaId,
      'soalIds': soalIds,
      'detailedAnswers': detailedAnswers
    };
    
    try {
      final url = Uri.parse('${AppConstants.baseUrl}/nilai');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(quizResultData),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'nilaiId': responseData['nilaiId'],
          'message': 'Quiz submitted successfully'
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to submit quiz'
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Error: ${error.toString()}'
      };
    }
  }
}

class NotifikasiRepository {
  Future<List<NotifikasiModel>> getNotifikasi(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/notifications");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        // Memetakan setiap data JSON ke objek Notifikasi
        return responseBody
            .map((data) => NotifikasiModel.fromJson(data))
            .toList(); // Mengembalikan List<Notifikasi>
      } else {
        throw Exception('Failed to load Nilai saya');
      }
    } catch (error) {
      rethrow; // Mengembalikan error yang terjadi
    }
  }

  Future<void> markAsRead(String accessToken, int notificationId) async {
    final url = Uri.parse(
      "${AppConstants.baseUrl}/notifications/$notificationId/read",
    );

    try {
      final response = await http.patch(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (error) {
      rethrow;
    }
  }
}

class ModulRepository {
  Future<List<ModulModel>> getModul(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/modul");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        // Map JSON data to ModulModel objects
        return responseBody
            .map((data) => ModulModel.fromJson(data))
            .toList(); // Return List<ModulModel>
      } else {
        throw Exception('Failed to load modules');
      }
    } catch (error) {
      rethrow; // Propagate the error
    }
  }
}

class SubModulRepository {
  Future<List<SubModulModel>> getSubModul(
    String accessToken,
    int modulId,
  ) async {
    final url = Uri.parse(
      "${AppConstants.baseUrl}/sub-modul-by-modulid/$modulId",
    );

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(response.body);
        // Map JSON data to SubModulModel objects
        return responseBody
            .map((data) => SubModulModel.fromJson(data))
            .toList(); // Return List<SubModulModel>
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load Sub Modules');
      }
    } catch (error) {
      rethrow; // Propagate the error
    }
  }
}

class SoalRepository {
  Future<List<Map<String, dynamic>>> getSoal(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/all-soal");
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return groupSoalByKelasPelajaran(responseData);
      } else {
        throw Exception('Failed to load quiz data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching quiz data: $e');
    }
  }

  List<Map<String, dynamic>> groupSoalByKelasPelajaran(List<dynamic> data) {
    final Map<String, Map<String, dynamic>> groupedData = {};

    for (var item in data) {
      final soalItem = SoalModel.fromJson(item);
      final key = '${item['kelasId']}-${item['pelajaranId']}';

      if (!groupedData.containsKey(key)) {
        groupedData[key] = {
          'count': 0,
          'item': item,
          'items': [],
        };
      }

      groupedData[key]!['count'] = groupedData[key]!['count'] + 1;
      groupedData[key]!['items'].add(item);
    }

    return groupedData.values.toList();
  }
}