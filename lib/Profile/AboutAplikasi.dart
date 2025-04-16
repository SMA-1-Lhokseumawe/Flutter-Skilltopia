import 'package:flutter/material.dart';

class Aboutaplikasi extends StatefulWidget {
  const Aboutaplikasi({super.key});

  @override
  State<Aboutaplikasi> createState() => _AboutaplikasiState();
}

class _AboutaplikasiState extends State<Aboutaplikasi> {
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
          'Tentang Aplikasi',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // App Name
                  const Text(
                    'Gaya Belajar SMA 1 Lhokseumawe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27DEBF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // App Version
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // About Section
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
                        _buildSectionTitle('Tentang Aplikasi', Icons.info_outline),
                        const SizedBox(height: 16),
                        Text(
                          'Aplikasi ini dikembangkan untuk membantu siswa SMA 1 Lhokseumawe dalam mengetahui potensi gaya belajar mereka dan mengukur kemampuan belajar mereka secara komprehensif. Dengan memahami gaya belajar yang dominan, siswa dapat mengoptimalkan metode belajar yang sesuai dengan karakteristik individual mereka.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aplikasi ini menyediakan berbagai fitur analisis yang memungkinkan siswa untuk mengevaluasi kecenderungan gaya belajar mereka, apakah visual, auditori, kinestetik, atau kombinasi dari beberapa gaya. Dengan informasi ini, mereka dapat menyesuaikan strategi belajar yang paling efektif untuk meningkatkan prestasi akademik mereka di SMA 1 Lhokseumawe.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Features Section
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
                        _buildSectionTitle('Fitur Utama', Icons.star_outline),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          'Analisis Gaya Belajar',
                          'Mengidentifikasi kecenderungan gaya belajar siswa berdasarkan tes komprehensif.'
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          'Evaluasi Kemampuan',
                          'Mengukur dan melacak perkembangan kemampuan belajar siswa seiring waktu.'
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          'Rekomendasi Personalisasi',
                          'Memberikan saran strategi belajar yang sesuai dengan gaya belajar siswa.'
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          'Laporan Analitik',
                          'Menyajikan data dan statistik tentang perkembangan belajar siswa dalam bentuk visual.'
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Contact Section
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
                        _buildSectionTitle('Kontak', Icons.email_outlined),
                        const SizedBox(height: 16),
                        _buildContactItem(Icons.school, 'SMA 1 Lhokseumawe'),
                        const SizedBox(height: 12),
                        _buildContactItem(Icons.location_on_outlined, 'Jl. Pendidikan No. 1, Lhokseumawe, Aceh'),
                        const SizedBox(height: 12),
                        _buildContactItem(Icons.email_outlined, 'info@sma1lhokseumawe.sch.id'),
                        const SizedBox(height: 12),
                        _buildContactItem(Icons.phone_outlined, '(0645) 123456'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Copyright Text
                  Text(
                    '© ${DateTime.now().year} SMA 1 Lhokseumawe. Hak Cipta Dilindungi.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF27DEBF),
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper method to build feature items
  Widget _buildFeatureItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF27DEBF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF27DEBF),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build contact items
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF27DEBF).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF27DEBF),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}