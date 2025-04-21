import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:skilltopia/Profile/Profile.dart';
import 'package:skilltopia/constants.dart';
import 'package:skilltopia/models.dart';
import 'package:skilltopia/repository.dart';

class EditProfile extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const EditProfile({Key? key, required this.uuid, required this.accessToken})
    : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int? id;
  String nis = '';
  String? nama = '';
  String? email = '';
  String? kelas = '';
  String umur = '';
  String? alamat = '';
  String? image = '';
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedClass;
  bool _isSubmitting = false;
  List<dynamic> kelasList = [];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchKelas();
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool _isImagePickerActive = false;

  Future<void> _pickImage() async {
    if (_isImagePickerActive) return; // If the picker is active, do nothing.

    try {
      setState(() {
        _isImagePickerActive =
            true; // Set the flag to true when picker is triggered
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    } finally {
      setState(() {
        _isImagePickerActive =
            false; // Reset the flag after the image picker is done
      });
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/profile-siswa'),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response
        final data = jsonDecode(response.body);

        // Access the 'data' field from the response JSON
        final profileData = data['data'];

        // Parse the profile data into your model
        final profile = Profile.fromJson(profileData);

        setState(() {
          // Update the form with the fetched profile data
          id = profile.id;
          _nisController.text = profile.nis.toString();
          _nameController.text = profile.nama!;
          _emailController.text = profile.email!;
          _ageController.text = profile.umur.toString();
          _addressController.text = profile.alamat!;
          _selectedClass = profile.kelas?.id.toString();
          image = profile.image;
        });
      } else {
        // Handle non-200 status codes, such as 400, 404
        print(
          'Error: Failed to load profile. Status Code: ${response.statusCode}',
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching profile')));
      }
    } catch (e) {
      print("Error fetching profile: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching profile: $e')));
    }
  }

  // Fetch class list
  Future<void> _fetchKelas() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/all-kelas'),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );
      final data = jsonDecode(response.body);
      setState(() {
        kelasList = data;
      });
    } catch (e) {
      print("Error fetching classes: $e");
    }
  }

  // Create saveProfile function
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final formData = {
      'nis': _nisController.text,
      'nama': _nameController.text,
      'email': _emailController.text,
      'kelasId': _selectedClass,
      'umur': _ageController.text,
      'alamat': _addressController.text,
    };

    if (_imageFile != null) {
      formData['file'] = _imageFile!.path; // Use the file's path as a string
    }

    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${AppConstants.baseUrl}/siswa/$id'),
      );

      request.headers['Authorization'] = 'Bearer ${widget.accessToken}';

      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', _imageFile!.path),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile Updated')));
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProfilePage(
                  uuid: widget.uuid,
                  accessToken: widget.accessToken,
                ),
          ),
        );
      } else {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile')));
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF27DEBF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF27DEBF)),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF27DEBF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Color(0xFF27DEBF)),
              ),
              onPressed: _updateProfile, // Call saveProfile here
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFF27DEBF).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: const Color(0xFF27DEBF).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    image:
                                        _imageFile != null
                                            ? DecorationImage(
                                              image: FileImage(_imageFile!),
                                              fit: BoxFit.cover,
                                            )
                                            : image != null && image!.isNotEmpty
                                            ? DecorationImage(
                                              image: NetworkImage(
                                                // Check if the image already contains a URL prefix
                                                image!.startsWith('http')
                                                    ? image! // Use it as is if it's already a full URL
                                                    : '${AppConstants.baseUrlImage}$image', // Append base URL if not
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : const DecorationImage(
                                              image: AssetImage(
                                                'assets/logo.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF27DEBF),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Ubah Foto Profil',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Form Fields Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF27DEBF).withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NIS Field
                          _buildLabelWithIcon(Icons.badge_rounded, 'NIS Siswa'),
                          _buildTextField(
                            controller: _nisController,
                            hintText: 'Masukkan NIS Anda',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'NIS tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Name Field
                          _buildLabelWithIcon(
                            Icons.person_rounded,
                            'Nama Lengkap',
                          ),
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Masukkan nama lengkap Anda',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Email Field
                          _buildLabelWithIcon(Icons.email_rounded, 'Email'),
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Masukkan alamat email Anda',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              } else if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Class Selection Field
                          _buildLabelWithIcon(
                            Icons.class_rounded,
                            'Pilih Kelas Anda',
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonFormField<String>(
                              value: _selectedClass,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.grey,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              hint: const Text('Pilih kelas Anda'),
                              items:
                                  kelasList.map((kelas) {
                                    return DropdownMenuItem<String>(
                                      value: kelas['id'].toString(),
                                      child: Text(kelas['namaKelas']),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedClass = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap pilih kelas Anda';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Age Field
                          _buildLabelWithIcon(
                            Icons.calendar_today_rounded,
                            'Umur',
                          ),
                          _buildTextField(
                            controller: _ageController,
                            hintText: 'Masukkan umur Anda',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Umur tidak boleh kosong';
                              } else if (int.tryParse(value) == null) {
                                return 'Umur harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Address Field
                          _buildLabelWithIcon(Icons.home_rounded, 'Alamat'),
                          _buildTextField(
                            controller: _addressController,
                            hintText: 'Masukkan alamat Anda',
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile, // Call saveProfile here
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27DEBF),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build field label with icon
  Widget _buildLabelWithIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF27DEBF)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF27DEBF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      validator: validator,
    );
  }
}
