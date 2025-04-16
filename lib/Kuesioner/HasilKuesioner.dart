import 'package:flutter/material.dart';

class HasilKuesioner extends StatefulWidget {
  final int visualCount;
  final int auditoriCount;
  final int kinestetikCount;
  final int totalQuestions;

  const HasilKuesioner({
    super.key,
    required this.visualCount,
    required this.auditoriCount,
    required this.kinestetikCount,
    required this.totalQuestions,
  });

  @override
  State<HasilKuesioner> createState() => _HasilKuesionerState();
}

class _HasilKuesionerState extends State<HasilKuesioner> {
  // App main color
  final Color primaryColor = Color(0xFF27DEBF);
  
  // Define colors for each learning style
  final Color visualColor = Color(0xFF5C7AEA);
  final Color auditoriColor = Color(0xFFFFA41B);
  final Color kinestetikColor = Color(0xFF4E9F3D);
  
  // Calculate percentages for each learning style
  int get visualPercentage => (widget.visualCount / widget.totalQuestions * 100).round();
  int get auditoriPercentage => (widget.auditoriCount / widget.totalQuestions * 100).round();
  int get kinestetikPercentage => (widget.kinestetikCount / widget.totalQuestions * 100).round();
  
  // Determine the dominant learning style
  String get dominantLearningStyle {
    if (widget.visualCount >= widget.auditoriCount && widget.visualCount >= widget.kinestetikCount) {
      return "Visual";
    } else if (widget.auditoriCount >= widget.visualCount && widget.auditoriCount >= widget.kinestetikCount) {
      return "Auditori";
    } else {
      return "Kinestetik";
    }
  }
  
  // Get the color associated with the dominant style
  Color get dominantColor {
    return dominantLearningStyle == "Visual" 
        ? visualColor 
        : dominantLearningStyle == "Auditori" 
            ? auditoriColor 
            : kinestetikColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Hasil Kuesioner',
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
          // Background curved shapes
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
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Trophy icon
                    _buildTrophySection(),
                    
                    // Learning style result card
                    _buildResultCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Distribution chart card
                    _buildDistributionCard(),
                    
                    const SizedBox(height: 30),
                    
                    // Button to retake test
                    _buildRetakeButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Trophy icon section
  Widget _buildTrophySection() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 30),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: dominantColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.emoji_events_rounded,
        size: 70,
        color: dominantColor,
      ),
    );
  }

  // Main result card showing the learning style
  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: dominantColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Kamu termasuk tipe',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),
            
            // Learning style name with gradient background
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dominantColor.withOpacity(0.8),
                    dominantColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: dominantColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                dominantLearningStyle,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Learning style icon
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: dominantColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                dominantLearningStyle == "Visual" 
                    ? Icons.visibility
                    : dominantLearningStyle == "Auditori" 
                        ? Icons.hearing 
                        : Icons.directions_run,
                color: dominantColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            
            // Description based on dominant style
            Text(
              _getLearningStyleDescription(dominantLearningStyle),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card showing distribution of learning styles
  Widget _buildDistributionCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with icon
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.pie_chart_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Distribusi Gaya Belajar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Visual percentage
            _buildLearningStylePercentage(
              label: 'Visual',
              percentage: visualPercentage,
              color: visualColor,
              icon: Icons.visibility,
            ),
            const SizedBox(height: 20),
            
            // Auditori percentage
            _buildLearningStylePercentage(
              label: 'Auditori',
              percentage: auditoriPercentage,
              color: auditoriColor,
              icon: Icons.hearing,
            ),
            const SizedBox(height: 20),
            
            // Kinestetik percentage
            _buildLearningStylePercentage(
              label: 'Kinestetik',
              percentage: kinestetikPercentage,
              color: kinestetikColor,
              icon: Icons.directions_run,
            ),
          ],
        ),
      ),
    );
  }
  
  // Button to retake the questionnaire
  Widget _buildRetakeButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.refresh_rounded),
        label: Text('Mengisi Kembali Kuesioner'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Widget for showing percentage bars for each learning style
  Widget _buildLearningStylePercentage({
    required String label,
    required int percentage,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Label and progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label with percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Custom progress bar
                Stack(
                  children: [
                    // Background
                    Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Foreground
                    Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 
                          (percentage / 100) * 0.6, // Adjust width based on screen size
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.8),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get description text for each learning style
  String _getLearningStyleDescription(String style) {
    switch (style) {
      case 'Visual':
        return 'Gaya belajar visual menyerap informasi terkait dengan visual, warna, gambar, peta, diagram dan belajar dari apa yang dilihat oleh mata. Artinya bukti-bukti konkret harus diperlihatkan terlebih dahulu agar mereka paham, gaya belajar seperti ini mengandalkan penglihatan atau melihat dulu buktinya untuk kemudian mempercayainya.';
      case 'Auditori':
        return 'Gaya belajar auditori menyerap informasi melalui pendengaran. Kamu lebih baik memahami sesuatu melalui penjelasan lisan dan diskusi. Kamu mungkin suka berbicara dan menyukai musik atau suara. Gaya belajar ini mengandalkan kemampuan untuk mendengar dan mengingat informasi yang disampaikan secara verbal.';
      case 'Kinestetik':
        return 'Gaya belajar kinestetik menyerap informasi melalui gerakan dan sentuhan. Kamu belajar terbaik dengan melakukan sesuatu secara langsung, bergerak aktif, dan praktik. Pengalaman langsung sangat penting bagi kamu. Gaya belajar ini cenderung menggunakan seluruh tubuh dan sentuhan dalam proses menyerap informasi atau belajar.';
      default:
        return '';
    }
  }
}