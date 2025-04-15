import 'package:flutter/material.dart';

class TipsAndTrick extends StatefulWidget {
  const TipsAndTrick({super.key});

  @override
  State createState() => _TipsAndTrickState();
}

class _TipsAndTrickState extends State<TipsAndTrick> {
  // Tips content
  final List<Map<String, dynamic>> tips = [
    {
      'text': 'Bacalah petunjuk dengan teliti sebelum memulai. Pastikan Anda memahami apa yang diharapkan dalam ujian ini, termasuk batas waktu dan cara menjawab setiap soal.',
      'icon': Icons.description_outlined,
      'color': Color(0xFF5C7AEA),
    },
    {
      'text': 'Saat membaca soal, pastikan Anda memahami inti dari pertanyaan tersebut. Bacalah soal beberapa kali jika diperlukan untuk memastikan pemahaman Anda.',
      'icon': Icons.visibility_outlined,
      'color': Color(0xFFE94560),
    },
    {
      'text': 'Tes potensi akademik sering kali memiliki batasan waktu, jadi sangat penting untuk mengelola waktu dengan baik. Tentukan berapa lama waktu yang akan Anda alokasikan untuk setiap pertanyaan atau bagian.',
      'icon': Icons.timer_outlined,
      'color': Color(0xFF4E9F3D),
    },
    {
      'text': 'Identifikasi kata kunci dalam soal yang memberikan petunjuk tentang apa yang diminta. Misalnya, pertanyaan "definisikan" mengharuskan Anda memberikan definisi, sementara pertanyaan "bandingkan" mengharuskan Anda untuk melakukan perbandingan.',
      'icon': Icons.search_outlined,
      'color': Color(0xFF27DEBF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF27DEBF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tips dan Trik',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
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
                color: Color(0xFF27DEBF).withOpacity(0.4),
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
                color: Color(0xFF27DEBF).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content - Tips List
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Tips Mengerjakan Soal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  // Tips list
                  Expanded(
                    child: ListView.builder(
                      itemCount: tips.length,
                      itemBuilder: (context, index) {
                        return _buildTipCard(tips[index], index);
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

  Widget _buildTipCard(Map<String, dynamic> tip, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Color(0xFF27DEBF).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tip content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tip number with icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tip['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      tip['icon'],
                      color: tip['color'],
                      size: 24,
                    ),
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Tip text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tip ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: tip['color'],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        tip['text'],
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          height: 1.5,
                        ),
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
}