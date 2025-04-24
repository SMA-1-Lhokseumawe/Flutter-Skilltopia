import 'package:flutter/material.dart';
import 'package:skilltopia/Diskusi/DiskusiPage.dart';
import 'package:skilltopia/Kuesioner/Kuesioner.dart';
import 'package:skilltopia/Materi/ListModul.dart';
import 'package:skilltopia/Profile/AddProfile.dart';
import 'package:skilltopia/Quiz/ListQuiz.dart';
import 'package:skilltopia/TipsAndTrick/TipsAndTrick.dart';
import 'package:skilltopia/loginPage.dart';
import 'package:skilltopia/repository.dart';
import 'package:skilltopia/constants.dart';

class BerandaContent extends StatefulWidget {
  final String uuid;
  final String username;
  final String accessToken;

  const BerandaContent({
    Key? key,
    required this.uuid,
    required this.username,
    required this.accessToken,
  }) : super(key: key);

  @override
  _BerandaContentState createState() => _BerandaContentState();
}

class _BerandaContentState extends State<BerandaContent> {
  late int siswaId;
  String nama = '';
  String image = '';
  String gayaBelajar = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final repository = UserRepository();
      final response = await repository.getProfile(widget.accessToken);

      if (response['status']) {
        final data = response['data'];
        // Check if data is null or empty (profile not created)
        if (data == null || (data is Map && data.isEmpty)) {
          _showProfileNotCreatedDialog();
        } else {
          setState(() {
            siswaId = data['id'] ?? '';
            nama = data['nama'] ?? '';
            image = data['image'] ?? '';
            gayaBelajar = data['gayaBelajar'] ?? '';
            isLoading = false;
          });
        }
      } else {
        // Show dialog if profile doesn't exist
        _showProfileNotCreatedDialog();
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Show error message but don't show the dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching profile: $error")));
    }
  }

  void _logout(BuildContext context) async {
    if (widget.accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token tidak ditemukan, Anda belum login")),
      );
      return;
    }

    final repository = UserRepository();

    try {
      final success = await repository.logoutUser(widget.accessToken!);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Berhasil logout")));

        // Redirect ke LoginPage setelah logout
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const loginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal logout")));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  void _showProfileNotCreatedDialog() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF27DEBF)),
              SizedBox(width: 10),
              Text('Pemberitahuan'),
            ],
          ),
          content: Text(
            'Profil siswa Anda belum dibuat. Silakan buat profil untuk melanjutkan.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('KELUAR', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Call logout function
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF27DEBF),
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to AddProfile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AddProfile(
                          uuid: widget.uuid,
                          accessToken: widget.accessToken,
                          username: widget.username
                        ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String profileImage = image.isEmpty ? 'profile.png' : image;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Background curved shapes with enhanced opacity
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
              color: Color(0xFF27DEBF).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),

        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced User Welcome Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(16, 16, 16, 20),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 39, 40, 40).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Color(0xFF27DEBF).withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Profile Image with shadow effect
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFF27DEBF),
                        child: ClipOval(
                          child: Builder(
                            builder: (context) {
                              // Periksa dulu apakah image kosong
                              if (image.isEmpty) {
                                return Image.asset(
                                  'assets/profile.png',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                );
                              }

                              // Jika image tidak kosong, gunakan NetworkImage
                              String imageUrl =
                                  "${AppConstants.baseUrlImage}${image}";
                              print("Image URL: $imageUrl");

                              return Image(
                                image: NetworkImage(imageUrl),
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print("Error loading image: $error");
                                  return Image.asset(
                                    'assets/profile.png',
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 18),

                    // Welcome Text with enhanced typography
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                // Use the passed nama or default to "Pengguna"
                                'Halo, ${nama.isNotEmpty ? nama : "Pengguna"}!',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text('👋', style: TextStyle(fontSize: 19)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Ayo Tingkatkan kemampuan dalam menjawab soal soal yang tersedia!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.3,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Beranda Title with enhanced spacing and leading icon
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF27DEBF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.dashboard_rounded,
                        color: Color(0xFF27DEBF),
                        size: 22,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Beranda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced Grid Menu
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      // Enhanced Grid Items with icons
                      _buildEnhancedGridItem(
                        title: 'QnA',
                        icon: Icons.question_answer_rounded,
                        color: Color(0xFF5C7AEA),
                        onTap: () {
                          String judulContent = '';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DiskusiPage(
                                    uuid: widget.uuid,
                                    username: widget.username,
                                    accessToken: widget.accessToken,
                                    siswaId: siswaId,
                                    judulContent: judulContent,
                                  ),
                            ),
                          );
                        },
                      ),

                      _buildEnhancedGridItem(
                        title: 'Tips & Trick',
                        icon: Icons.lightbulb_rounded,
                        color: Color(0xFFFFA41B),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TipsAndTrick(
                                    uuid: widget.uuid,
                                    accessToken: widget.accessToken,
                                  ),
                            ),
                          );
                        },
                      ),

                      _buildEnhancedGridItem(
                        title: 'Materi',
                        icon: Icons.book_rounded,
                        color: Color(0xFF4E9F3D),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ListModul(
                                    uuid: widget.uuid,
                                    accessToken: widget.accessToken,
                                    gayaBelajar: gayaBelajar,
                                    username: widget.username
                                  ),
                            ),
                          );
                        },
                      ),

                      _buildEnhancedGridItem(
                        title: 'Quiz',
                        icon: Icons.quiz_rounded,
                        color: Color(0xFFE94560),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ListQuiz(
                                    uuid: widget.uuid,
                                    accessToken: widget.accessToken,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Enhanced grid item with icon and better styling
  Widget _buildEnhancedGridItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with colored background
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(height: 12),
            // Title text
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
