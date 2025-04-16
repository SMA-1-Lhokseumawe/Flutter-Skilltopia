import 'package:flutter/material.dart';
import 'HasilKuesioner.dart';

class Kuesioner extends StatefulWidget {
  const Kuesioner({super.key});

  @override
  State<Kuesioner> createState() => _KuesionerState();
}

class _KuesionerState extends State<Kuesioner> {
  // App main color
  final Color primaryColor = Color(0xFF27DEBF);
  
  // List of all questions
  final List<Map<String, dynamic>> questions = [
    {
      'question': '1. Ketika saya mengoperasikan peralatan baru, saya biasanya :',
      'options': [
        'Membaca petunjuknya terlebih dahulu',
        'Mendengarkan penjelasan dari seseorang yang pernah menggunakannya',
        'Menggunakannya langsung, saya bisa belajar ketika menggunakannya',
      ],
      'answer': null,
    },
    {
      'question': '2. Ketika saya perlu petunjuk untuk bepergian, saya biasanya :',
      'options': [
        'Melihat map atau peta',
        'Bertanya denah atau arah ke orang lain',
        'Menggunakan kompas dan mengikutinya',
      ],
      'answer': null,
    },
    {
      'question': '3. Ketika saya baru memasak, saya biasanya melakukan :',
      'options': [
        'Mengikuti petunjuk resep tertulis',
        'Meminta penjelasan kepada seorang teman',
        'Mengikuti naluri, mencicipi selagi memasaknya',
      ],
      'answer': null,
    },
    {
      'question': '4. Jika saya mengajar seseorang tentang sesuatu yang baru, saya cenderung untuk :',
      'options': [
        'Menulis instruksi untuk mereka',
        'Memberikan penjelasan secara lisan',
        'Memperagakan terlebih dahulu, kemudian meminta mereka untuk mempraktekkannya',
      ],
      'answer': null,
    },
    {
      'question': '5. Saya cenderung mengatakan:',
      'options': [
        'Lihat bagaimana saya melakukannya',
        'Dengarkan penjelasan saya',
        'Silahkan dikerjakan',
      ],
      'answer': null,
    },
    {
      'question': '6. Selama waktu luang, saya paling menikmati saat :',
      'options': [
        'Pergi ke museum atau perpustakaan',
        'Mendengarkan musik dan berbincang dengan teman-teman saya',
        'Berolahraga atau mengerjakan apa saja',
      ],
      'answer': null,
    },
    {
      'question': '7. Ketika saya pergi berbelanja pakaian, saya cenderung untuk :',
      'options': [
        'Membayangkan apakah pakaian tersebut cocok untuk saya',
        'Meminta rekomendasi dengan karyawan toko',
        'Mencoba pakaian dan melihat kecocokannya',
      ],
      'answer': null,
    },
    {
      'question': '8. Saat merencanakan liburan, saya biasanya :',
      'options': [
        'Membaca banyak informasi tempat berlibur di internet atau brosur',
        'Meminta rekomendasi dari teman-teman',
        'Membayangkan akan seperti apa jika berada di sana',
      ],
      'answer': null,
    },
    {
      'question': '9. Jika saya ingin membeli mobil baru, saya akan :',
      'options': [
        'Membaca ulasan di internet, koran, dan majalah',
        'Membahas apa yang saya butuhkan dengan teman-teman',
        'Mencoba banyak jenis mobil yang berbeda',
      ],
      'answer': null,
    },
    {
      'question': '10. Ketika saya sedang belajar keterampilan baru, saya paling senang :',
      'options': [
        'Melihat apa yang pengajar lakukan',
        'Menanyakan ke pengajar tentang apa yang seharusnya saya lakukan',
        'Mencoba dan mempraktekkannya secara langsung',
      ],
      'answer': null,
    },
    {
      'question': '11. Jika saya memilih makanan pada daftar menu, saya cenderung untuk :',
      'options': [
        'Membayangkan makanannya akan seperti apa',
        'Menanyakan rekomendasi menu',
        'Membayangkan seperti apa rasa makanan itu',
      ],
      'answer': null,
    },
    {
      'question': '12. Ketika saya mendengarkan pertunjukan sebuah band, saya cenderung untuk :',
      'options': [
        'Melihat anggota band dan orang lain di antara para penonton',
        'Mendengarkan lirik dan nada',
        'Terbawa dalam suasana dan musik',
      ],
      'answer': null,
    },
    {
      'question': '13. Ketika saya berkonsentrasi, saya paling sering :',
      'options': [
        'Fokus pada kata-kata atau gambar-gambar di depan saya',
        'Membahas masalah dan memikirkan solusi yang mungkin dapat dilakukan',
        'Banyak bergerak, bermain dengan pena dan pensil, atau menyentuh sesuatu',
      ],
      'answer': null,
    },
    {
      'question': '14. Saya memilih peralatan rumah tangga, berdasarkan :',
      'options': [
        'Warnanya dan bagaimana penampilannya',
        'Penjelasan dari salesnya',
        'Tekstur peralatan tersebut dan bagaimana rasanya ketika menyentuhnya',
      ],
      'answer': null,
    },
    {
      'question': '15. Saya mudah mengingat dan memahami sesuatu, dengan cara :',
      'options': [
        'Melihat sesuatu',
        'Mendengarkan sesuatu',
        'Melakukan sesuatu',
      ],
      'answer': null,
    },
    {
      'question': '16. Ketika saya cemas, saya akan :',
      'options': [
        'Membayangkan kemungkinan terburuk',
        'Memikirkan hal yang paling mengkhawatirkan',
        'Tidak bisa duduk tenang, terus menerus berkeliling, dan memegang sesuatu',
      ],
      'answer': null,
    },
    {
      'question': '17. Saya dapat mengingat orang lain, karena :',
      'options': [
        'Penampilan mereka',
        'Apa yang mereka katakan kepada saya',
        'Bagaimana cara mereka memperlakukan saya',
      ],
      'answer': null,
    },
    {
      'question': '18. Saat gagal ujian, saya biasanya :',
      'options': [
        'Menulis banyak catatan perbaikan',
        'Membahas catatan saya sendiri atau dengan orang lain',
        'Membuat kemajuan belajar dengan memperbaiki jawaban',
      ],
      'answer': null,
    },
    {
      'question': '19. Ketika menjelaskan sesuatu, saya cenderung :',
      'options': [
        'Menunjukkan kepada mereka apa yang saya maksud',
        'Menjelaskan kepada mereka dengan berbagai cara sampai mereka mengerti',
        'Memotivasi mereka untuk mencoba dan menyampaikan ide saya ketika mereka mengerjakan',
      ],
      'answer': null,
    },
    {
      'question': '20. Saya sangat suka :',
      'options': [
        'Menonton film, fotografi, melihat seni atau mengamati orang-orang sekitar',
        'Mendengarkan musik, radio atau bincang-bincang dengan teman-teman',
        'Berperan serta dalam kegiatan olahraga, menikmati makanan yang disajikan, atau menari',
      ],
      'answer': null,
    },
    {
      'question': '21. Sebagian besar waktu luang, saya habiskan :',
      'options': [
        'Menonton televisi atau menonton film',
        'Mengobrol dengan teman-teman',
        'Melakukan aktivitas fisik atau membuat sesuatu',
      ],
      'answer': null,
    },
    {
      'question': '22. Ketika pertama kali bertemu orang baru, saya biasanya :',
      'options': [
        'Membayangkan kegiatan yang akan dilakukan',
        'Berbicara dengan mereka melalui telepon',
        'Mencoba melakukan sesuatu bersama-sama, misalnya suatu kegiatan atau makan bersama',
      ],
      'answer': null,
    },
    {
      'question': '23. Saya memperhatikan seseorang, melalui :',
      'options': [
        'Tampilannya dan pakaiannya',
        'Suara dan cara berbicaranya',
        'Tingkah lakunya',
      ],
      'answer': null,
    },
    {
      'question': '24. Jika saya marah, saya cenderung untuk :',
      'options': [
        'Terus mengingat hal yang membuat saya marah',
        'Menyampaikan ke orang-orang sekitar tentang perasaan saya',
        'Menunjukkan kemarahan saya, misalnya : menghentakkan kaki, membanting pintu, dan lainnya',
      ],
      'answer': null,
    },
    {
      'question': '25. Saya merasa lebih mudah untuk mengingat :',
      'options': [
        'Wajah',
        'Nama',
        'Hal-hal yang telah saya lakukan',
      ],
      'answer': null,
    },
    {
      'question': '26. Saya dapat mengetahui seseorang melakukan kebohongan, jika :',
      'options': [
        'Mereka menghindari kontak mata',
        'Perubahan suara mereka',
        'Mereka menunjukkan perilaku yang aneh',
      ],
      'answer': null,
    },
    {
      'question': '27. Ketika saya bertemu dengan teman lama :',
      'options': [
        'Saya berkata "Senang bertemu denganmu!"',
        'Saya berkata "Senang mendengar kabar tentangmu!"',
        'Saya memberi mereka pelukan atau jabat tangan',
      ],
      'answer': null,
    },
    {
      'question': '28. Saya mudah mengingat sesuatu, dengan cara :',
      'options': [
        'Menulis catatan atau menyimpan materi',
        'Mengucapkan dan mengulang poin penting di pikiran saya',
        'Melakukan dan mempraktikkan secara langsung',
      ],
      'answer': null,
    },
    {
      'question': '29. Jika saya mengeluh tentang barang rusak yang sudah dibeli, saya akan memilih untuk :',
      'options': [
        'Menulis surat pengaduan',
        'Menyampaikan keluhan melalui telepon',
        'Mengembalikannya ke toko atau mengirimkannya ke kantor pusat',
      ],
      'answer': null,
    },
    {
      'question': '30. Saya cenderung mengatakan :',
      'options': [
        'Saya paham apa yang anda maksud',
        'Saya dengar apa yang anda katakan',
        'Saya tahu bagaimana yang Anda rasakan',
      ],
      'answer': null,
    },
  ];

  int currentQuestionIndex = 0;

  // Hasil perhitungan
  int visualCount = 0;
  int auditoriCount = 0;
  int kinestetikCount = 0;

  void _selectAnswer(int answerIndex) {
    setState(() {
      questions[currentQuestionIndex]['answer'] = answerIndex;
      
      // Move to next question
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _calculateResults() {
    // Reset counters
    visualCount = 0;
    auditoriCount = 0;
    kinestetikCount = 0;

    // Count each type of answer
    for (var question in questions) {
      if (question['answer'] == 0) {
        visualCount++;
      } else if (question['answer'] == 1) {
        auditoriCount++;
      } else if (question['answer'] == 2) {
        kinestetikCount++;
      }
    }

    // Navigate to results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilKuesioner(
          visualCount: visualCount,
          auditoriCount: auditoriCount,
          kinestetikCount: kinestetikCount,
          totalQuestions: questions.length,
        ),
      ),
    );
  }

  bool get _canSubmit {
    // Check if all questions have been answered
    for (var question in questions) {
      if (question['answer'] == null) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestionScreen();
  }

  Widget _buildQuestionScreen() {
    final currentQuestion = questions[currentQuestionIndex];
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kuesioner Gaya Belajar',
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with progress
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.psychology_rounded,
                                color: primaryColor,
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Pertanyaan ${currentQuestionIndex + 1}/${questions.length}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Custom progress bar
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 
                                    (currentQuestionIndex + 1) / questions.length * 0.91,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.5),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
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
                  
                  // Question Card
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Question
                            Text(
                              currentQuestion['question'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 28),
                            
                            // Options
                            Expanded(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: List.generate(
                                    currentQuestion['options'].length,
                                    (index) => _buildOptionButton(
                                      option: currentQuestion['options'][index],
                                      index: index,
                                      isSelected: currentQuestion['answer'] == index,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Navigation buttons
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Previous button
                                  TextButton.icon(
                                    onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
                                    icon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 16,
                                      color: currentQuestionIndex > 0
                                          ? primaryColor
                                          : Colors.grey[400],
                                    ),
                                    label: Text(
                                      'Sebelumnya',
                                      style: TextStyle(
                                        color: currentQuestionIndex > 0
                                            ? primaryColor
                                            : Colors.grey[400],
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: currentQuestionIndex > 0
                                          ? primaryColor.withOpacity(0.1)
                                          : Colors.grey[200],
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  
                                  // Next or Finish button
                                  if (currentQuestionIndex < questions.length - 1)
                                    TextButton.icon(
                                      onPressed: currentQuestion['answer'] != null
                                          ? () {
                                              setState(() {
                                                currentQuestionIndex++;
                                              });
                                            }
                                          : null,
                                      icon: Text(
                                        'Selanjutnya',
                                        style: TextStyle(
                                          color: currentQuestion['answer'] != null
                                              ? Colors.white
                                              : Colors.grey[400],
                                        ),
                                      ),
                                      label: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: currentQuestion['answer'] != null
                                            ? Colors.white
                                            : Colors.grey[400],
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: currentQuestion['answer'] != null
                                            ? primaryColor
                                            : Colors.grey[200],
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    )
                                  else
                                    ElevatedButton.icon(
                                      onPressed: _canSubmit ? _calculateResults : null,
                                      icon: Text(
                                        'Selesai',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      label: Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        elevation: 2,
                                        shadowColor: primaryColor.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildOptionButton({
    required String option,
    required int index,
    required bool isSelected,
  }) {
    final String label;
    switch (index) {
      case 0:
        label = 'A';
        break;
      case 1:
        label = 'B';
        break;
      case 2:
        label = 'C';
        break;
      default:
        label = '';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAnswer(index),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Option letter in circle
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryColor : Colors.grey[100],
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Option text
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                
                // Checkbox/Selection indicator
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryColor : Colors.grey[100],
                    border: isSelected
                        ? null
                        : Border.all(
                            color: Colors.grey[400]!,
                            width: 1.5,
                          ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}