import 'package:flutter/material.dart';

class ListQuiz extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const ListQuiz({
    Key? key, 
    required this.uuid,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<ListQuiz> createState() => _ListQuizState();
}

class _ListQuizState extends State<ListQuiz> {
  // Sample data for quizzes
  final List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Pythagoras Quiz',
      'subject': 'Matematika',
      'questionCount': 15,
      'duration': 30,
      'grade': 'Kelas 11',
      'icon': Icons.calculate_rounded,
      'color': Color(0xFF5C7AEA),
      'difficulty': 'Sedang',
    },
    {
      'title': 'Hukum Newton Quiz',
      'subject': 'Fisika',
      'questionCount': 20,
      'duration': 45,
      'grade': 'Kelas 10',
      'icon': Icons.science_rounded,
      'color': Color(0xFFE94560),
      'difficulty': 'Sulit',
    },
    {
      'title': 'Narrative Text Quiz',
      'subject': 'Bahasa Inggris',
      'questionCount': 10,
      'duration': 25,
      'grade': 'Kelas 10',
      'icon': Icons.language_rounded,
      'color': Color(0xFF4E9F3D),
      'difficulty': 'Mudah',
    },
    {
      'title': 'Persamaan Kuadrat Quiz',
      'subject': 'Matematika',
      'questionCount': 12,
      'duration': 35,
      'grade': 'Kelas 10',
      'icon': Icons.calculate_rounded,
      'color': Color(0xFF5C7AEA),
      'difficulty': 'Sedang',
    },
    {
      'title': 'Gerak Parabola Quiz',
      'subject': 'Fisika',
      'questionCount': 18,
      'duration': 40,
      'grade': 'Kelas 11',
      'icon': Icons.science_rounded,
      'color': Color(0xFFE94560),
      'difficulty': 'Sulit',
    },
  ];

  String _filterGrade = '';

  @override
  Widget build(BuildContext context) {
    // Filter quizzes based on grade if filter is selected
    List<Map<String, dynamic>> filteredQuizzes =
        _filterGrade.isEmpty
            ? quizzes
            : quizzes.where((quiz) => quiz['grade'] == _filterGrade).toList();

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
          'Daftar Quiz',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
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

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter info & Clear button
              // Here's the updated code for the Filter info section
              // Replace the Quiz Count Container with this:

              // Info text section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter indicators row
                    Row(
                      children: [
                        // Grade filter indicator
                        if (_filterGrade.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF27DEBF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  size: 14,
                                  color: Color(0xFF27DEBF),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  _filterGrade,
                                  style: TextStyle(
                                    color: Color(0xFF27DEBF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        Spacer(),

                        // Clear filter button
                        if (_filterGrade.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterGrade = '';
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Clear',
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

                    // Informational text section - New addition
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Color(0xFF27DEBF).withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFF27DEBF),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Temukan soal yang sesuai dengan kelas dan pelajaran. Dari dasar hingga lanjutan, semua dirancang untuk menentukan kemampuan siswa pengalaman belajar.",
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),

              // Quiz list
              Expanded(
                child:
                    filteredQuizzes.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada quiz yang tersedia',
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
                          itemCount: filteredQuizzes.length,
                          itemBuilder: (context, index) {
                            final quiz = filteredQuizzes[index];
                            return QuizCard(quiz: quiz);
                          },
                        ),
              ),
            ],
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
            title: Text('Filter Quiz'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Kelas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGradeFilterButton('Kelas 10'),
                    _buildGradeFilterButton('Kelas 11'),
                    _buildGradeFilterButton('Kelas 12'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildGradeFilterButton(String grade) {
    bool isSelected = _filterGrade == grade;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _filterGrade = isSelected ? '' : grade;
        });
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Color(0xFF27DEBF) : Colors.grey.withOpacity(0.1),
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(grade.split(' ')[1]),
    );
  }
}

class QuizCard extends StatelessWidget {
  final Map<String, dynamic> quiz;

  const QuizCard({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to quiz details or start quiz
            },
            splashColor: quiz['color'].withOpacity(0.1),
            highlightColor: quiz['color'].withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quiz title section
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: quiz['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            quiz['icon'],
                            size: 28,
                            color: quiz['color'],
                          ),
                        ),
                      ),

                      SizedBox(width: 16),

                      // Quiz title and subject
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quiz['subject'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Soal ini memiliki sebanyak 1 soal dengan type soal pilihan ganda",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Start quiz button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF27DEBF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
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

                // Quiz info section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Number of questions
                      _buildInfoItem(
                        Icons.help_outline_rounded,
                        '${quiz['questionCount']} Soal',
                      ),

                      // Vertical divider
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),

                      // Duration
                      _buildInfoItem(
                        Icons.timer_outlined,
                        '${quiz['duration']} Menit',
                      ),

                      // Vertical divider
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),

                      // Grade level
                      _buildInfoItem(Icons.school_outlined, quiz['grade']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Mudah':
        return Color(0xFF4CAF50);
      case 'Sedang':
        return Color(0xFFFFA000);
      case 'Sulit':
        return Color(0xFFE53935);
      default:
        return Color(0xFF9E9E9E);
    }
  }
}
