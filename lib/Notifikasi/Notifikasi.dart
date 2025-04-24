import 'package:flutter/material.dart';
import 'package:skilltopia/Diskusi/DiskusiPage.dart';
import 'package:skilltopia/constants.dart';
import 'package:skilltopia/repository.dart';
import 'package:skilltopia/models.dart';
import 'package:timeago/timeago.dart' as timeago;

String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  return fileName;
}

String extractTitleFromContent(String content) {
  // Look for the pattern: commented on "title": "comment"
  RegExp regex = RegExp(r'commented on \"(.*?)\":');
  var match = regex.firstMatch(content);
  
  if (match != null && match.groupCount >= 1) {
    return match.group(1) ?? ''; // Return the captured title
  }
  return ''; // Return empty string if no match found
}

class Notifikasi extends StatefulWidget {
  final String uuid;
  final String username;
  final String accessToken;

  const Notifikasi({
    Key? key,
    required this.uuid,
    required this.username,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  late int siswaId;
  bool isLoading = true;

  final Color primaryColor = Color(0xFF27DEBF);
  final NotifikasiRepository notifikasiRepo = NotifikasiRepository();

  late Future<List<NotifikasiModel>> _notifikasi;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    // Fetch notifications data from the repository
    _notifikasi = notifikasiRepo.getNotifikasi(widget.accessToken);
  }

  Future<void> _fetchProfile() async {
    try {
      final repository = UserRepository();
      final response = await repository.getProfile(widget.accessToken);

      if (response['status']) {
        final data = response['data'];
        setState(() {
          siswaId = data['id'] ?? '';
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
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching profile: $error")));
    }
  }

  // Function to mark notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      // Call API to mark notification as read
      await notifikasiRepo.markAsRead(widget.accessToken, notificationId);

      // Get the notifications from the snapshot and update the status of the one marked as read
      setState(() {
        _notifikasi.then((notifications) {
          final notification = notifications.firstWhere(
            (notif) => notif.id == notificationId,
          );
          notification.isRead = true; // Mark it as read locally
        });
      });
    } catch (e) {
      // Handle error if any
      print("Error marking notification as read: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27DEBF),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: Color(0xFF27DEBF)),
            onPressed: () {
              _showClearAllDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NotifikasiModel>>(
        future: _notifikasi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          } else {
            List<NotifikasiModel> notifications = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color:
                        notification.isRead! ? Colors.white : Color(0xFFF0FFFC),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: primaryColor.withOpacity(
                        notification.isRead! ? 0.1 : 0.2,
                      ),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Mark as read when tapped
                      setState(() {
                        notifications[index].isRead = true;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unread indicator
                          if (!(notification.isRead!))
                            Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.only(top: 6, right: 8),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          // Profile picture
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                notification.siswa?.url != null
                                    ? NetworkImage(
                                      "${AppConstants.baseUrlImage}" +
                                          getFileNameFromUrl(
                                            notification.siswa!.url!,
                                          ),
                                    )
                                    : notification.guru?.url != null
                                    ? NetworkImage(
                                      "${AppConstants.baseUrlImage}" +
                                          getFileNameFromUrl(
                                            notification.guru!.url!,
                                          ),
                                    )
                                    : null,
                            child:
                                notification.siswa?.url == null &&
                                        notification.guru?.url == null
                                    ? Text(
                                      (notification.siswa?.nama ??
                                              notification.guru?.nama ??
                                              'N')
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(color: primaryColor),
                                    )
                                    : null,
                          ),
                          SizedBox(width: 12),
                          // Notification content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: notification.content!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                InkWell(
                                  onTap: () {

                                    String judulContent = extractTitleFromContent(notification.content ?? '');

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DiskusiPage(
                                              siswaId:
                                                  siswaId, // Safe to use ! because we checked for null
                                              uuid: widget.uuid,
                                              username: widget.username,
                                              accessToken: widget.accessToken,
                                              judulContent: judulContent
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Klik disini untuk lihat',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  timeago.format(
                                    DateTime.parse(notification.createdAt!),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Column for actions like Delete and Mark as Read
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Delete button
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: Colors.red[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    notifications.removeAt(index);
                                  });
                                },
                              ),
                              SizedBox(height: 8),
                              // Mark as Read button (visible only if not already read)
                              if (!(notification.isRead!))
                                IconButton(
                                  icon: Icon(
                                    Icons.check,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  onPressed: () async {
                                    // Call mark as read function
                                    await markNotificationAsRead(
                                      notification.id!,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 70,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Anda akan menerima notifikasi ketika ada aktivitas baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Hapus Semua Notifikasi'),
            content: Text(
              'Apakah Anda yakin ingin menghapus semua notifikasi?',
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
                  backgroundColor: Colors.red[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Hapus'),
                onPressed: () {},
              ),
            ],
          ),
    );
  }
}
