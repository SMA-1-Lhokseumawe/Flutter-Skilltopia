import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skilltopia/Nilai/NilaiSaya.dart';
import 'package:skilltopia/repository.dart';
import '../constants.dart'; // Asumsikan berisi URL API

class StartQuiz extends StatefulWidget {
  final Map<String, dynamic> groupData;
  final String accessToken;
  final String uuid;

  const StartQuiz({
    Key? key,
    required this.groupData,
    required this.accessToken,
    required this.uuid,
  }) : super(key: key);

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  // Timer properties
  int _timeLeft = 120 * 60; // 120 minutes in seconds
  late Timer _timer;
  bool _quizStarted = false;
  bool _showInstructions = true;
  bool isLoading = true;

  // Quiz state
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  List<Map<String, dynamic>> _questions = [];

  // UI state
  bool _showConfirmModal = false;
  int? _siswaId;

  @override
  void initState() {
    super.initState();
    _formatQuestions();
    _getSiswaProfile();
  }

  @override
  void dispose() {
    if (_quizStarted) {
      _timer.cancel();
    }
    super.dispose();
  }

  // Get siswa profile
  Future<void> _getSiswaProfile() async {
    try {
      final repository = UserRepository();
      final response = await repository.getProfile(widget.accessToken!);

      if (response['status']) {
        final data = response['data'];
        setState(() {
          _siswaId = data['id'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?['message'] ?? 'Error fetching profile'),
          ),
        );
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    }
  }

  // Format questions from groupData
  void _formatQuestions() {
    final items = widget.groupData['items'] as List<dynamic>;
    
    setState(() {
      _questions = items.map((item) {
        // Parse the soal field if it's in JSON format
        String questionText = item['soal'];
        Map<String, dynamic>? questionData;

        try {
          // Process the quiz content to fix image URLs
          String processedSoal = processQuizContent(item['soal']);
          final parsedQuestion = json.decode(processedSoal);
          if (parsedQuestion['ops'] != null) {
            questionData = parsedQuestion;
            questionText = _extractTextFromOps(parsedQuestion['ops']);
          }
        } catch (e) {
          // Not valid JSON, use as is
        }

        return {
          'id': item['id'],
          'question': questionText,
          'questionData': questionData,
          'options': [
            {'id': 'A', 'text': item['optionA']},
            {'id': 'B', 'text': item['optionB']},
            {'id': 'C', 'text': item['optionC']},
            {'id': 'D', 'text': item['optionD']},
            {'id': 'E', 'text': item['optionE']},
          ],
          'category': item['pelajaran'] != null 
              ? item['pelajaran']['pelajaran'] 
              : widget.groupData['item']['pelajaran']['pelajaran'],
          'correctAnswer': item['correctAnswer'],
        };
      }).toList();
    });
  }

  // Extract text from Quill format
  String _extractTextFromOps(List<dynamic> ops) {
    return ops.map((op) {
      if (op['insert'] is String) {
        return op['insert'];
      } else if (op['insert'] is Map && op['insert']['image'] != null) {
        return '[Image]';
      }
      return '';
    }).join('');
  }

  // Start the quiz
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _showInstructions = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          _submitQuiz();
        }
      });
    });
  }

  // Show confirm submission modal
  void _showConfirmSubmission() {
    setState(() {
      _showConfirmModal = true;
    });
  }

  // Submit quiz answers
  Future _submitQuiz() async {
    setState(() {
      _showConfirmModal = false;
    });
    
    final nilaiSayaRepository = NilaiSayaRepository();
    
    try {
      final result = await nilaiSayaRepository.submitQuiz(
        accessToken: widget.accessToken,
        questions: _questions,
        userAnswers: _userAnswers,
        groupData: widget.groupData,
        siswaId: _siswaId,
      );
      
      if (result['status']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NilaiSaya(
              uuid: widget.uuid,
              accessToken: widget.accessToken,
            ),
          ),
        );
      } else {
        _showErrorMessage(result['message']);
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
      Navigator.pop(context);
    }
  }

  // Format time for display
  String _formatTime(int seconds) {
    final hrs = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return '${hrs.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // Go to next question
  void _handleNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showConfirmSubmission();
    }
  }

  // Go to previous question
  void _handlePrevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  // Process quiz content to replace image URLs
  String processQuizContent(String content) {
    try {
      // Parse the JSON content
      final jsonContent = jsonDecode(content);
      
      // Look for and replace all image URLs
      if (jsonContent['ops'] != null) {
        for (var op in jsonContent['ops']) {
          if (op['insert'] is Map && op['insert']['image'] != null) {
            String imageUrl = op['insert']['image'];
            if (imageUrl.contains('http://localhost:5000/images/')) {
              op['insert']['image'] = imageUrl.replaceAll(
                'http://localhost:5000/images/', 
                AppConstants.baseUrlImage
              );
            }
          }
        }
      }
      
      // Return the processed content
      return jsonEncode(jsonContent);
    } catch (e) {
      print("Error processing quiz content: $e");
      return content; // Return original content if error
    }
  }

  // Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Render question content including images
  Widget _renderQuestionContent(Map<String, dynamic> question) {
    if (question['questionData'] != null && 
        question['questionData']['ops'] != null) {
      final ops = question['questionData']['ops'] as List;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ops.map<Widget>((op) {
          if (op['insert'] is String) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                op['insert'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            );
          } else if (op['insert'] is Map && op['insert']['image'] != null) {
            String imageUrl = op['insert']['image'];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.9,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Gagal memuat gambar'),
                    );
                  },
                ),
              ),
            );
          }
          return SizedBox.shrink();
        }).toList(),
      );
    }
    
    // Fallback to simple text
    return Text(
      question['question'],
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
      softWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showInstructions) {
      return _buildInstructionsView();
    }
    
    return _buildQuizView();
  }

  // Instructions view
  Widget _buildInstructionsView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF27DEBF).withOpacity(0.1),
                        Color(0xFF27DEBF).withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instruksi Quiz',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Baca instruksi dengan teliti sebelum memulai',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Time instruction
                _buildInstructionItem(
                  Icons.timer_outlined,
                  'Waktu',
                  'Anda memiliki waktu 120 menit untuk menyelesaikan quiz ini.',
                ),
                
                SizedBox(height: 16),
                
                // Attention instruction
                _buildInstructionItem(
                  Icons.warning_amber_outlined,
                  'Perhatian',
                  'Pastikan koneksi internet stabil selama mengerjakan quiz.',
                ),
                
                SizedBox(height: 16),
                
                // Process instruction
                _buildInstructionItem(
                  Icons.check_circle_outline,
                  'Pengerjaan',
                  'Pilih satu jawaban yang tepat untuk setiap pertanyaan.',
                ),
                
                SizedBox(height: 24),
                
                // Quiz info
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Quiz:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        'Mata Pelajaran',
                        widget.groupData['item']['pelajaran']['pelajaran'],
                      ),
                      _buildInfoRow(
                        'Kelas', 
                        'Kelas ${widget.groupData['item']['kelas']['kelas']}',
                      ),
                      _buildInfoRow(
                        'Jumlah Soal',
                        '${widget.groupData['count']} soal',
                      ),
                      _buildInfoRow(
                        'Jenis Soal',
                        'Pilihan Ganda',
                      ),
                      _buildInfoRow(
                        'Waktu',
                        '120 menit',
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Start button
                Center(
                  child: ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27DEBF),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Mulai Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Quiz view
  Widget _buildQuizView() {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF27DEBF),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with timer
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quiz info
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          widget.groupData['item']['pelajaran']['pelajaran'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF27DEBF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ' | Soal ${_currentQuestionIndex + 1} dari ${_questions.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Timer and submit button
                  Row(
                    children: [
                      // Timer
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 16,
                              color: _timeLeft < 300 
                                ? Colors.red 
                                : Color(0xFF27DEBF),
                            ),
                            SizedBox(width: 6),
                            Text(
                              _formatTime(_timeLeft),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                color: _timeLeft < 300 
                                  ? Colors.red 
                                  : Color(0xFF27DEBF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: 8),
                      
                      // Submit button
                      TextButton(
                        onPressed: _showConfirmSubmission,
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF27DEBF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Selesaikan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Question content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question category and numbers
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Soal kategori: ${currentQuestion['category']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _questions.length > 5 ? 5 : _questions.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentQuestionIndex = index;
                                    });
                                  },
                                  child: Container(
                                    width: 32,
                                    margin: EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _currentQuestionIndex == index 
                                          ? Color(0xFF27DEBF)
                                          : Colors.grey[300]!,
                                        width: _currentQuestionIndex == index ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontWeight: _currentQuestionIndex == index 
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                          color: _currentQuestionIndex == index 
                                            ? Color(0xFF27DEBF)
                                            : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Question content
                    _renderQuestionContent(currentQuestion),
                    
                    SizedBox(height: 24),
                    
                    // Options
                    ...List.generate(5, (index) {
                      final option = currentQuestion['options'][index];
                      final optionId = option['id'];
                      final isSelected = _userAnswers[currentQuestion['id']] == optionId;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _userAnswers[currentQuestion['id']] = optionId;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected 
                                ? Color(0xFF27DEBF) 
                                : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected 
                              ? Color(0xFF27DEBF).withOpacity(0.05)
                              : Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Option letter
                              Container(
                                width: 24,
                                height: 24,
                                margin: EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected 
                                    ? Color(0xFF27DEBF)
                                    : Colors.grey[200],
                                  border: Border.all(
                                    color: isSelected 
                                      ? Color(0xFF27DEBF)
                                      : Colors.grey[400]!,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    optionId,
                                    style: TextStyle(
                                      color: isSelected 
                                        ? Colors.white
                                        : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Option text - Modified for better text wrapping
                              Expanded(
                                child: Text(
                                  option['text'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  ElevatedButton(
                    onPressed: _currentQuestionIndex > 0 
                      ? _handlePrevQuestion
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[700],
                      disabledBackgroundColor: Colors.grey[200],
                      disabledForegroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Soal Sebelumnya'),
                  ),
                  
                  // Next button
                  ElevatedButton(
                    onPressed: _handleNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27DEBF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1
                        ? 'Selesaikan'
                        : 'Soal Berikutnya'
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Confirmation modal
      bottomSheet: _showConfirmModal
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                width: 300,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Apakah yakin ingin mengakhiri jawab soal?',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showConfirmModal = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Text('Cancel'),
                        ),
                        
                        // Submit button
                        ElevatedButton(
                          onPressed: _submitQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF27DEBF),
                          ),
                          child: Text('Akhiri'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : null,
    );
  }

  // Helper for building instruction items
  Widget _buildInstructionItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF27DEBF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color(0xFF27DEBF),
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper for building info rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}