import 'package:flutter/material.dart';
import 'package:skilltopia/Materi/ListSubModul.dart';

class ListModul extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const ListModul({
    Key? key, 
    required this.uuid,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<ListModul> createState() => _ListModulState();
}

class _ListModulState extends State<ListModul> {
  // Sample data for modules
  final List<Map<String, dynamic>> modules = [
    {
      'title': 'Phytagoras',
      'type': 'Visual',
      'description':
          'Pythagoras adalah rumus yang terdapat dalam bagian geometri. Rumus ini berguna untuk menunjukkan hubungan antara panjang sisi segitiga siku-siku, dengan salah satu sudut 90 derajat.',
      'subject': 'Matematika',
      'duration': '20 Jam',
      'grade': 'Kelas 11',
      'color': Color(0xFF5C7AEA),
      'icon': Icons.visibility_outlined,
    },
    {
      'title': 'Hukum Newton',
      'type': 'Kinestetik',
      'description':
          'Hukum Newton menjelaskan hubungan antara gaya yang bekerja pada benda dan gerakannya. Terdapat tiga hukum dasar yang menjelaskan konsep gerak dalam fisika klasik.',
      'subject': 'Fisika',
      'duration': '15 Jam',
      'grade': 'Kelas 10',
      'color': Color(0xFFE94560),
      'icon': Icons.accessibility_new_rounded,
    },
    {
      'title': 'Narrative Text',
      'type': 'Auditori',
      'description':
          'Narrative text adalah jenis teks yang menceritakan sebuah kisah, baik fiksi maupun non-fiksi. Teks ini memiliki struktur dan ciri kebahasaan tertentu.',
      'subject': 'Bahasa Inggris',
      'duration': '10 Jam',
      'grade': 'Kelas 10',
      'color': Color(0xFF4E9F3D),
      'icon': Icons.hearing_outlined,
    },
    {
      'title': 'Persamaan Kuadrat',
      'type': 'Visual',
      'description':
          'Persamaan kuadrat adalah persamaan dengan variabel berderajat tertinggi dua. Persamaan ini dapat diselesaikan dengan berbagai metode seperti faktorisasi dan rumus ABC.',
      'subject': 'Matematika',
      'duration': '25 Jam',
      'grade': 'Kelas 10',
      'color': Color(0xFF5C7AEA),
      'icon': Icons.visibility_outlined,
    },
    {
      'title': 'Gerak Parabola',
      'type': 'Kinestetik',
      'description':
          'Gerak parabola adalah gerak dua dimensi yang mengikuti lintasan berbentuk parabola. Konsep ini menggabungkan gerak lurus beraturan dan gerak jatuh bebas.',
      'subject': 'Fisika',
      'duration': '18 Jam',
      'grade': 'Kelas 11',
      'color': Color(0xFFE94560),
      'icon': Icons.accessibility_new_rounded,
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter modules based on search query
    List<Map<String, dynamic>> filteredModules = modules;
    if (_searchQuery.isNotEmpty) {
      filteredModules =
          modules
              .where(
                (module) =>
                    module['title'].toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    module['description'].toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    module['subject'].toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

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
          'Daftar Materi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Color(0xFF27DEBF)),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: Color(0xFF27DEBF)),
            onPressed: () {
              _showFilterDialog();
            },
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

          // Header section with total modules
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.close, size: 14, color: Colors.red),
                              SizedBox(width: 6),
                              Text(
                                'Clear Search',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Main content - module list
              Expanded(
                child:
                    filteredModules.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada materi yang ditemukan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filteredModules.length,
                          itemBuilder: (context, index) {
                            final module = filteredModules[index];
                            return ModuleCard(module: module);
                          },
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Cari Materi'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Masukkan kata kunci',
                prefixIcon: Icon(Icons.search, color: Color(0xFF27DEBF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF27DEBF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF27DEBF), width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            actions: [
              TextButton(
                child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27DEBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Cari'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Filter Materi'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterChip('Kelas 10', Color(0xFF27DEBF)),
                    _buildFilterChip('Kelas 11', Color(0xFF27DEBF)),
                    _buildFilterChip('Kelas 12', Color(0xFF27DEBF)),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Reset', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF27DEBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Terapkan'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: color.withOpacity(0.7),
      selectedColor: color,
      selected: false,
      onSelected: (selected) {
        // Handle filter selection
      },
    );
  }
}

class ModuleCard extends StatelessWidget {
  final Map<String, dynamic> module;

  const ModuleCard({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListSubModul()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
            // Module header with type indicator
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type indicator and bookmark button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: module['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: module['color'].withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              module['icon'],
                              size: 16,
                              color: module['color'],
                            ),
                            SizedBox(width: 6),
                            Text(
                              module['type'],
                              style: TextStyle(
                                color: module['color'],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Module title
                  Text(
                    module['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.3,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Module description
                  Text(
                    module['description'],
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.withOpacity(0.1),
            ),

            // Module metadata section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.02),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Subject indicator
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF27DEBF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getSubjectIcon(module['subject']),
                      size: 18,
                      color: Color(0xFF27DEBF),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    module['subject'],
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),

                  Spacer(),

                  // Duration indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 4),
                        Text(
                          module['duration'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8),

                  // Grade level indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 4),
                        Text(
                          module['grade'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }

  // Helper method to get subject icon
  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Matematika':
        return Icons.calculate_rounded;
      case 'Fisika':
        return Icons.science_rounded;
      case 'Bahasa Inggris':
        return Icons.language_rounded;
      default:
        return Icons.book_rounded;
    }
  }
}
