import 'package:flutter/material.dart';

class ListSubModul extends StatefulWidget {
  const ListSubModul({super.key});

  @override
  State<ListSubModul> createState() => _ListSubModulState();
}

class _ListSubModulState extends State<ListSubModul> {
  // Sample data for sub-modules
  final List<Map<String, dynamic>> subModules = [
    {
      'title': 'Pengenalan Pythagoras',
      'description':
          'Memahami konsep dasar teorema Pythagoras dan aplikasinya dalam segitiga siku-siku.',
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'title': 'Rumus Pythagoras',
      'description':
          'Mendalami rumus a² + b² = c² dan cara menerapkannya untuk mencari panjang sisi segitiga.',
      'icon': Icons.calculate_outlined,
    },
    {
      'title': 'Aplikasi Pythagoras',
      'description':
          'Menggunakan teorema Pythagoras untuk menyelesaikan masalah kehidupan sehari-hari.',
      'icon': Icons.home_work_outlined,
    },
    {
      'title': 'Pembuktian Teorema',
      'description':
          'Memahami bukti geometris dan aljabar dari teorema Pythagoras.',
      'icon': Icons.architecture_outlined,
    },
    {
      'title': 'Latihan Soal',
      'description':
          'Mengerjakan berbagai tipe soal tentang teorema Pythagoras untuk penguasaan materi.',
      'icon': Icons.quiz_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF27DEBF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pythagoras',
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

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sub Module Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_list_bulleted_rounded,
                      color: Color(0xFF27DEBF),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Daftar Sub Modul',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Sub Module List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: subModules.length,
                  itemBuilder: (context, index) {
                    final subModule = subModules[index];
                    return SubModuleCard(
                      subModule: subModule,
                      index: index + 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubModuleCard extends StatelessWidget {
  final Map<String, dynamic> subModule;
  final int index;

  const SubModuleCard({Key? key, required this.subModule, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Color(0xFF27DEBF).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        subModule['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Text(
                    subModule['description'],
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Learn button
            ElevatedButton(
              onPressed: () {
                // Navigate to sub module content
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27DEBF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                'Pelajari',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
