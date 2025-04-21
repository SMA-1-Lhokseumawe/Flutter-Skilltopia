import 'package:flutter/material.dart';
import 'package:skilltopia/repository.dart';

class GantiPassword extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const GantiPassword({Key? key, required this.uuid, required this.accessToken})
    : super(key: key);

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Password visibility toggle
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool _isSubmitting = false;
  String _message = '';
  bool _isError = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      // Periksa apakah ada field yang kosong
      if (_oldPasswordController.text.isEmpty ||
          _newPasswordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Semua field harus diisi')));
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final userRepository = UserRepository();
      final response = await userRepository.updatePassword(
        widget.accessToken,
        _oldPasswordController.text,
        _newPasswordController.text,
        _confirmPasswordController.text,
      );

      setState(() {
        _isSubmitting = false;
        _message = response['message'];
        _isError = !response['status'];
      });

      if (!_isError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Password berhasil diperbarui')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_message)));
      }
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
          'Ganti Password',
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
              onPressed: _changePassword,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background curved shapes
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
                    // Lock Icon
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF27DEBF).withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Color(0xFF27DEBF),
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Ubah Password Anda',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pastikan password baru Anda aman dan mudah diingat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
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
                          // Old Password Field
                          _buildLabelWithIcon(
                            Icons.lock_outline_rounded,
                            'Password Lama',
                          ),
                          _buildPasswordField(
                            controller: _oldPasswordController,
                            hintText: 'Masukkan password lama Anda',
                            obscureText: _obscureOldPassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                              });
                            },
                            validator: (value) {
                              print("Old Password: $value");
                              if (value == null || value.isEmpty) {
                                return 'Password lama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // New Password Field
                          _buildLabelWithIcon(
                            Icons.lock_rounded,
                            'Password Baru',
                          ),
                          _buildPasswordField(
                            controller: _newPasswordController,
                            hintText: 'Masukkan password baru Anda',
                            obscureText: _obscureNewPassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                            validator: (value) {
                              print("New Password: $value");
                              if (value == null || value.isEmpty) {
                                return 'Password baru tidak boleh kosong';
                              } else if (value.length < 6) {
                                return 'Password baru harus minimal 6 karakter';
                              } else if (value == _oldPasswordController.text) {
                                return 'Password baru tidak boleh sama dengan password lama';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password Field
                          _buildLabelWithIcon(
                            Icons.lock_person_rounded,
                            'Konfirmasi Password',
                          ),
                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            hintText: 'Konfirmasi password baru Anda',
                            obscureText: _obscureConfirmPassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            validator: (value) {
                              print("Confirm Password: $value");
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              } else if (value != _newPasswordController.text) {
                                return 'Konfirmasi password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // Password Requirements
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              'Password harus memiliki minimal 6 karakter',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _changePassword,
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
                          'Simpan Password Baru',
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

  // Helper method to build password fields with toggle visibility
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required Function() onToggleVisibility,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      validator: validator,
    );
  }
}
