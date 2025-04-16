import 'package:flutter/material.dart';

class NilaiSaya extends StatefulWidget {
  const NilaiSaya({super.key});

  @override
  State<NilaiSaya> createState() => _NilaiSayaState();
}

class _NilaiSayaState extends State<NilaiSaya> {
  // App main color
  final Color primaryColor = Color(0xFF27DEBF);
  
  // Sample data - replace with your actual data
  final List<Map<String, dynamic>> nilaiList = [
    {
      'skor': 85,
      'kelas': 'X IPA 1',
      'level': 'High',
      'pelajaran': 'Matematika',
      'waktu': '14:30',
      'tanggal': '12 April 2025',
      'jumlahSoal': 20,
      'jawabanBenar': 17,
    },
    {
      'skor': 70,
      'kelas': 'X IPA 1',
      'level': 'Medium',
      'pelajaran': 'Fisika',
      'waktu': '10:15',
      'tanggal': '10 April 2025',
      'jumlahSoal': 25,
      'jawabanBenar': 18,
    },
    {
      'skor': 60,
      'kelas': 'X IPA 1',
      'level': 'Low',
      'pelajaran': 'Kimia',
      'waktu': '09:45',
      'tanggal': '8 April 2025',
      'jumlahSoal': 30,
      'jawabanBenar': 18,
    },
    {
      'skor': 90,
      'kelas': 'X IPA 1',
      'level': 'High',
      'pelajaran': 'Biologi',
      'waktu': '13:20',
      'tanggal': '5 April 2025',
      'jumlahSoal': 20,
      'jawabanBenar': 18,
    },
    {
      'skor': 75,
      'kelas': 'X IPA 1',
      'level': 'Medium',
      'pelajaran': 'Bahasa Inggris',
      'waktu': '11:00',
      'tanggal': '2 April 2025',
      'jumlahSoal': 40,
      'jawabanBenar': 30,
    },
  ];

  // Get the appropriate color for the level
  Color getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Color(0xFF4E9F3D); // Green
      case 'medium':
        return Color(0xFFFFA41B); // Orange
      case 'low':
        return Color(0xFFE94560); // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Nilai Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Stack(
        children: [
          // Background curved shapes with enhanced opacity
          Positioned(
            top: -120,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.4),
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
                color: primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeaderSection(),
                  
                  SizedBox(height: 20),
                  
                  // List of Nilai
                  Expanded(
                    child: _buildNilaiList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Header section with title and icon
  Widget _buildHeaderSection() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.assessment_rounded,
            color: primaryColor,
            size: 22,
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Daftar Nilai',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
  
  // List of nilai cards
  Widget _buildNilaiList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: nilaiList.length,
      itemBuilder: (context, index) {
        final nilai = nilaiList[index];
        return _buildNilaiCard(nilai);
      },
    );
  }
  
  // Individual nilai card
  Widget _buildNilaiCard(Map<String, dynamic> nilai) {
    // Get level color
    final levelColor = getLevelColor(nilai['level']);
    
    // Calculate score circle color based on score value
    Color getScoreColor(int score) {
      if (score >= 80) return Color(0xFF4E9F3D); // Green for high scores
      if (score >= 70) return Color(0xFFFFA41B); // Orange for medium scores
      return Color(0xFFE94560); // Red for low scores
    }
    
    final scoreColor = getScoreColor(nilai['skor']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Top section with subject, class and level
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                // Subject icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getSubjectIcon(nilai['pelajaran']),
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                
                // Subject and class
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nilai['pelajaran'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kelas ${nilai['kelas']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Level badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: levelColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getLevelIcon(nilai['level']),
                        color: levelColor,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        nilai['level'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: levelColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Main content section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Score circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        scoreColor,
                        scoreColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scoreColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${nilai['skor']}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Skor',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        Icons.calendar_today_rounded, 
                        'Tanggal', 
                        nilai['tanggal'],
                      ),
                      SizedBox(height: 8),
                      _buildDetailItem(
                        Icons.access_time_rounded, 
                        'Waktu', 
                        nilai['waktu'],
                      ),
                      SizedBox(height: 8),
                      _buildDetailItem(
                        Icons.help_outline_rounded, 
                        'Soal', 
                        '${nilai['jawabanBenar']} / ${nilai['jumlahSoal']} benar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Button section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle detail button tap
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for detail items
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 16,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to get subject icon
  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematika':
        return Icons.calculate_rounded;
      case 'fisika':
        return Icons.science_rounded;
      case 'kimia':
        return Icons.biotech_rounded;
      case 'biologi':
        return Icons.eco_rounded;
      case 'bahasa inggris':
        return Icons.language_rounded;
      default:
        return Icons.book_rounded;
    }
  }
  
  // Helper method to get level icon
  IconData _getLevelIcon(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Icons.trending_up_rounded;
      case 'medium':
        return Icons.trending_flat_rounded;
      case 'low':
        return Icons.trending_down_rounded;
      default:
        return Icons.remove_rounded;
    }
  }
}