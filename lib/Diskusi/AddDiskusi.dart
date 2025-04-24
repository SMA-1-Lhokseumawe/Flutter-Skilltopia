import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skilltopia/repository.dart';

class AddDiskusi extends StatefulWidget {
  final String uuid;
  final String accessToken;
  final int siswaId;

  const AddDiskusi({
    Key? key,
    required this.uuid,
    required this.accessToken,
    required this.siswaId,
  }) : super(key: key);

  @override
  State<AddDiskusi> createState() => _AddDiskusiState();
}

class _AddDiskusiState extends State<AddDiskusi> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiPertanyaanController = TextEditingController();
  final _kategoriController = TextEditingController();
  
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isImagePickerActive = false;
  bool _isSubmitting = false;

  final DiskusiRepository _diskusiRepository = DiskusiRepository();

  Future<void> _pickImages() async {
    if (_isImagePickerActive) return;

    try {
      setState(() {
        _isImagePickerActive = true;
      });

      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          // Convert XFile to File and add to list
          _selectedImages.addAll(pickedFiles.map((XFile file) => File(file.path)).toList());
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    } finally {
      setState(() {
        _isImagePickerActive = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitDiskusi() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isSubmitting = true;
  });

  try {
    // Get form field values
    final String judul = _judulController.text.trim();
    final String content = _isiPertanyaanController.text.trim();
    final String kategori = _kategoriController.text.trim();

    // Use the repository's new method
    final DiskusiRepository _diskusiRepository = DiskusiRepository();
    await _diskusiRepository.createDiskusiWithImages(
      accessToken: widget.accessToken,
      judul: judul,
      content: content,
      kategori: kategori,
      siswaId: widget.siswaId,
      imageFiles: _selectedImages,
    );
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diskusi berhasil dikirim')),
    );
    Navigator.pop(context); // Go back to previous screen
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error mengirim diskusi: $e')),
    );
  } finally {
    setState(() {
      _isSubmitting = false;
    });
  }
}

  @override
  void dispose() {
    _judulController.dispose();
    _isiPertanyaanController.dispose();
    _kategoriController.dispose();
    super.dispose();
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
          'Buat Diskusi Baru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background decorations
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
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Container
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
                          // Judul Field
                          _buildLabelWithIcon(Icons.title_rounded, 'Judul'),
                          _buildTextField(
                            controller: _judulController,
                            hintText: 'Masukkan judul diskusi',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Judul tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Isi Pertanyaan Field
                          _buildLabelWithIcon(Icons.question_answer_rounded, 'Isi Pertanyaan'),
                          _buildTextField(
                            controller: _isiPertanyaanController,
                            hintText: 'Tuliskan pertanyaan atau diskusi Anda disini...',
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi pertanyaan tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Kategori Field
                          _buildLabelWithIcon(Icons.category_rounded, 'Kategori'),
                          _buildTextField(
                            controller: _kategoriController,
                            hintText: 'Masukkan kategori',
                            helperText: 'Buat kategori dipisah dengan koma (,)',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kategori tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Image Upload Section
                          _buildLabelWithIcon(Icons.image_rounded, 'Unggah Gambar'),
                          
                          GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_upload_rounded, color: Colors.grey[500], size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Klik untuk memilih gambar',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pilih beberapa gambar',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Image Preview Section
                          if (_selectedImages.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Preview Gambar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(_selectedImages.length, (index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: FileImage(_selectedImages[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Buttons Row
                    Row(
                      children: [
                        // Batal Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.grey[800],
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Kirim Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitDiskusi,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF27DEBF),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Kirim',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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
    String? helperText,
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
        helperText: helperText,
        helperStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
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