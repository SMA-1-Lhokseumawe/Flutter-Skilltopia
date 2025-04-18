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
      final body = jsonEncode({
        "username": username,
        "password": password,
      });

      final headers = {
        "Content-Type": "application/json",
      };

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
        headers: {
          "Authorization": "Bearer $accessToken",
        },
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
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    // Ensure you're properly parsing the response
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody;  // This should return the profile data correctly
    } else {
      throw Exception('Failed to load profile');
    }
  } catch (error) {
    rethrow;
  }
}

}

class NilaiSayaRepository {
  Future<List<NilaiSayaModel>> getNilaiSaya(String accessToken) async {
    final url = Uri.parse("${AppConstants.baseUrl}/nilai");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
        },
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
}

