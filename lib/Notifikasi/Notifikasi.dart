import 'package:flutter/material.dart';
import 'package:skilltopia/constants.dart';
import 'package:skilltopia/repository.dart';
import 'package:skilltopia/models.dart';
import 'package:timeago/timeago.dart' as timeago;

String getFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  return fileName;
}

class Notifikasi extends StatefulWidget {
  final String uuid;
  final String accessToken;

  const Notifikasi({Key? key, required this.uuid, required this.accessToken})
      : super(key: key);

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  final Color primaryColor = Color(0xFF27DEBF);
  final NotifikasiRepository notifikasiRepo = NotifikasiRepository();

  late Future<List<NotifikasiModel>> _notifikasi;

  @override
  void initState() {
    super.initState();
    // Fetch notifications data from the repository
    _notifikasi = notifikasiRepo.getNotifikasi(widget.accessToken);
  }

  // Function to mark notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
  try {
    // Call API to mark notification as read
    await notifikasiRepo.markAsRead(widget.accessToken, notificationId);

    // Get the notifications from the snapshot and update the status of the one marked as read
    setState(() {
      _notifikasi.then((notifications) {
        final notification = notifications.firstWhere((notif) => notif.id == notificationId);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF27DEBF)),
          onPressed: () => Navigator.pop(context),
        ),
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
                    color: notification.isRead! ? Colors.white : Color(0xFFF0FFFC),
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
                            backgroundImage: NetworkImage(
                              "${AppConstants.baseUrlImage}" + getFileNameFromUrl(notification.urlImageProfile!),
                            ),
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
                                Text(
                                  'Klik disini untuk lihat',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  timeago.format(DateTime.parse(notification.createdAt!)),
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
                                    await markNotificationAsRead(notification.id!);
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
      builder: (context) => AlertDialog(
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
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }
}
