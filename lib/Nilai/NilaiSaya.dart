import 'package:flutter/material.dart';
import 'package:skilltopia/repository.dart';
import 'package:skilltopia/models.dart'; // Pastikan NilaiSaya model sudah diperbarui
import 'package:intl/intl.dart';

// Fungsi untuk format tanggal
String formatDate(String? dateTimeString) {
  if (dateTimeString == null) {
    return "Unknown";
  }

  // Parse the date string into DateTime
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format tanggal dengan format yyyy-MM-dd
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

// Fungsi untuk format waktu
String formatTime(String? dateTimeString) {
  if (dateTimeString == null) {
    return "Unknown";
  }

  // Parse the date string into DateTime
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format waktu dengan format HH:mm:ss
  return DateFormat('HH:mm:ss').format(dateTime);
}

String formatScore(String? score) {
  if (score == null) {
    return "0"; // Jika skor null, tampilkan 0
  }

  // Parse the score string into a double
  double parsedScore = double.parse(score);

  // Format the score to remove trailing zeros
  return parsedScore.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}

class NilaiSaya extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const NilaiSaya({Key? key,  required this.uuid, required this.accessToken})
    : super(key: key);

  @override
  State<NilaiSaya> createState() => _NilaiSayaState();
}

class _NilaiSayaState extends State<NilaiSaya> {
  final Color primaryColor = Color(0xFF27DEBF);
  final NilaiSayaRepository nilaiSayaRepo = NilaiSayaRepository();

  late Future<List<NilaiSayaModel>> _nilaiSaya;

  @override
void initState() {
  super.initState();
  // Mengambil data nilai dari API
  _nilaiSaya = nilaiSayaRepo.getNilaiSaya(widget.accessToken);
}

  // Mendapatkan warna berdasarkan level nilai
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
        iconTheme: IconThemeData(color: Colors.black87),
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
                  _buildHeaderSection(),
                  SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<NilaiSayaModel>>(
                      future: _nilaiSaya,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data found'));
                        } else {
                          final nilaiSayaList = snapshot.data!;
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: nilaiSayaList.length,
                            itemBuilder: (context, index) {
                              final nilai = nilaiSayaList[index];

                              // Get level color
                              final levelColor = getLevelColor(
                                nilai.level ?? "",
                              );

                              Color getScoreColor(double score) {
                                if (score >= 66)
                                  return Color(
                                    0xFF4E9F3D,
                                  ); // Green for high scores
                                if (score >= 33)
                                  return Color(
                                    0xFFFFA41B,
                                  ); // Orange for medium scores
                                return Color(0xFFE94560); // Red for low scores
                              }

                              final scoreColor = getScoreColor(
                                double.parse(nilai.skor ?? "0"),
                              );

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
                                    // Top section with subject, class, and level
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.05),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                0.1,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _getSubjectIcon(
                                                nilai.pelajaran?.pelajaran ??
                                                    "",
                                              ),
                                              color: primaryColor,
                                              size: 22,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  nilai.pelajaran?.pelajaran ??
                                                      "Unknown",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Kelas ${nilai.kelas?.kelas ?? "Unknown"}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: levelColor.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                color: levelColor.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  _getLevelIcon(
                                                    nilai.level ?? "",
                                                  ),
                                                  color: levelColor,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  nilai.level ?? "Unknown",
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
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        children: [
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
                                                  color: scoreColor.withOpacity(
                                                    0.3,
                                                  ),
                                                  blurRadius: 8,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    formatScore(nilai.skor),
                                                    style: TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Skor',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailItem(
                                                  Icons.calendar_today_rounded,
                                                  'Tanggal',
                                                  formatDate(nilai.updatedAt),
                                                ),
                                                SizedBox(height: 8),
                                                _buildDetailItem(
                                                  Icons.access_time_rounded,
                                                  'Waktu',
                                                  formatTime(nilai.updatedAt),
                                                ),
                                                SizedBox(height: 8),
                                                _buildDetailItem(
                                                  Icons.help_outline_rounded,
                                                  'Soal',
                                                  '${nilai.jumlahJawabanBenar ?? 0} / ${nilai.jumlahSoal ?? 0} benar',
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
                            },
                          );
                        }
                      },
                    ),
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
          child: Icon(Icons.assessment_rounded, color: primaryColor, size: 22),
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

  // Individual Nilai card

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
          child: Icon(icon, color: primaryColor, size: 16),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
}
