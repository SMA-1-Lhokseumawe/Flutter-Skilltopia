import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:skilltopia/models.dart';
import 'package:skilltopia/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

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

      // Parse the response
      final responseBody = jsonDecode(response.body);

      // Return the response regardless of status
      return responseBody;
    } catch (error) {
      // Return a formatted error instead of rethrowing
      return {
        'status': false,
        'message': 'Error fetching profile: ${error.toString()}',
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> addProfile({
    required String accessToken,
    required Map<String, dynamic> profileData,
    File? imageFile,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/siswa");
    final request = http.MultipartRequest('POST', url);

    // Tambahkan header Authorization
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Tambahkan data profil ke fields request
    profileData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Tambahkan file gambar jika ada
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
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Log imagePath jika ada
        if (responseJson['data'] != null &&
            responseJson['data']['image'] != null) {
          print("Image Path: ${responseJson['data']['image']}");
        }

        return {
          'status': true,
          'message': responseJson['msg'] ?? 'Profil berhasil dibuat',
          'data': responseJson['data'],
        };
      } else {
        print("Error creating profile: $responseBody");
        return {
          'status': false,
          'message': responseJson['msg'] ?? 'Gagal membuat profil',
          'data': null,
        };
      }
    } catch (e) {
      print("Exception occurred: $e");
      return {
        'status': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'data': null,
      };
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

  Future<Map<String, dynamic>> updatePassword(
    String accessToken,
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
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
        return {'status': true, 'message': 'Password berhasil diperbarui'};
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {
          'status': false,
          'message': responseData['msg'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (error) {
      return {'status': false, 'message': 'Terjadi kesalahan jaringan'};
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
    final detailedAnswers =
        questions
            .map(
              (q) => {
                'soalId': q['id'],
                'jawaban': userAnswers[q['id']] ?? null,
                'benar': userAnswers[q['id']] == q['correctAnswer'],
              },
            )
            .toList();

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
      'detailedAnswers': detailedAnswers,
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
          'message': 'Quiz submitted successfully',
        };
      } else {
        return {'status': false, 'message': 'Failed to submit quiz'};
      }
    } catch (error) {
      return {'status': false, 'message': 'Error: ${error.toString()}'};
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
        groupedData[key] = {'count': 0, 'item': item, 'items': []};
      }

      groupedData[key]!['count'] = groupedData[key]!['count'] + 1;
      groupedData[key]!['items'].add(item);
    }

    return groupedData.values.toList();
  }
}

class DiskusiRepository {
  // Fetch all discussions
  Future<List<DiskusiModel>> getDiskusi(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/all-post");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DiskusiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load discussions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching discussions: $e');
    }
  }

  Future<List<DiskusiModel>> getMyDiskusi(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/post");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DiskusiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load discussions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching discussions: $e');
    }
  }

  Future<List<DiskusiModel>> getAllDiskusiWithoutComment(
    String accessToken,
  ) async {
    final url = Uri.parse("${AppConstants.baseUrl}/post-nocomment");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DiskusiModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load discussions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching discussions: $e');
    }
  }

  // Get discussion by ID
  Future<DiskusiModel> getDiskusiById(String accessToken, int postId) async {
    final url = Uri.parse("${AppConstants.baseUrl}/post/$postId");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return DiskusiModel.fromJson(data);
      } else {
        throw Exception('Failed to load discussion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching discussion: $e');
    }
  }

  // Create a new discussion post
  Future<DiskusiModel> createDiskusiWithImages({
    required String accessToken,
    required String judul,
    required String content,
    required String kategori,
    required int siswaId,
    required List<File> imageFiles,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/post");

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add text fields
      request.fields['judul'] = judul;
      request.fields['content'] = content;
      request.fields['kategori'] = kategori;
      request.fields['siswaId'] = siswaId.toString();
      request.fields['guruId'] = ''; // Empty or null

      // Add image files if any
      for (var imageFile in imageFiles) {
        final fileName = path.basename(imageFile.path);
        final fileExtension = path.extension(fileName).toLowerCase();

        // Determine mime type based on file extension
        String mimeType = 'image/jpeg'; // Default
        if (fileExtension == '.png') {
          mimeType = 'image/png';
        } else if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
          mimeType = 'image/jpeg';
        }

        // Create multipart file
        final multipartFile = await http.MultipartFile.fromPath(
          'files', // field name must match the API expectation
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        );

        // Add file to request
        request.files.add(multipartFile);
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Check response
      if (response.statusCode == 201 || response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return DiskusiModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to create discussion: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error creating discussion: $e');
    }
  }

  Future<DiskusiModel> updateDiskusiWithImages({
    required String accessToken,
    required int postId,
    required String judul,
    required String content,
    required String kategori,
    required List<String> existingImages,
    required List<String> removedImages,
    required List<File> newImageFiles,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/post/$postId");

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        url,
      ); // Use PATCH for updates

      // Add headers
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add text fields
      request.fields['judul'] = judul;
      request.fields['content'] = content;
      request.fields['kategori'] = kategori;

      // Add the list of existing images that should be kept
      request.fields['existingImages'] = json.encode(existingImages);

      // Add the list of removed images
      request.fields['removedImages'] = json.encode(removedImages);

      // Add new image files if any
      for (var imageFile in newImageFiles) {
        final fileName = path.basename(imageFile.path);
        final fileExtension = path.extension(fileName).toLowerCase();

        // Determine mime type based on file extension
        String mimeType = 'image/jpeg'; // Default
        if (fileExtension == '.png') {
          mimeType = 'image/png';
        } else if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
          mimeType = 'image/jpeg';
        }

        // Create multipart file
        final multipartFile = await http.MultipartFile.fromPath(
          'files', // field name must match the API expectation
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        );

        // Add file to request
        request.files.add(multipartFile);
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Check response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = json.decode(response.body);
        return DiskusiModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to update discussion: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating discussion: $e');
    }
  }

  Future<void> deleteDiskusi({
    required String accessToken,
    required int postId,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/post/$postId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus diskusi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error menghapus diskusi: $e');
    }
  }
}

class KomentarRepository {
  // Fetch all comments
  Future<List<KomentarModel>> getKomentar(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/all-komentar");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => KomentarModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  // Fetch comments for a specific post
  Future<List<KomentarModel>> getKomentarByPostId(
    String accessToken,
    int postId,
  ) async {
    try {
      // Fetch all comments
      final url = Uri.parse("${AppConstants.baseUrl}/all-komentar");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter comments locally by postId
        final filteredComments =
            data
                .map((json) => KomentarModel.fromJson(json))
                .where((comment) => comment.postId == postId)
                .toList();

        return filteredComments;
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      throw Exception('Error fetching comments: $e');
    }
  }

  // Post a new comment
  Future<KomentarModel> postKomentar({
    required String accessToken,
    required int postId,
    required int siswaId,
    required String content,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/komentar");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'postId': postId,
          'siswaId': siswaId,
          'guruId': null,
          'content': content,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return KomentarModel.fromJson(data);
      } else {
        throw Exception('Failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting comment: $e');
      throw Exception('Error posting comment: $e');
    }
  }

  // Update a comment
  Future<KomentarModel> updateKomentar({
    required String accessToken,
    required int komentarId,
    required String content,
  }) async {
    final url = Uri.parse("${AppConstants.baseUrl}/komentar/$komentarId");

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return KomentarModel.fromJson(data);
      } else {
        throw Exception('Failed to update comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating comment: $e');
    }
  }

  // Delete a comment
  Future<bool> deleteKomentar(String accessToken, int komentarId) async {
    final url = Uri.parse("${AppConstants.baseUrl}/komentar/$komentarId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }
}
